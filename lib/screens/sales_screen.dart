import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/controllers/home_controller.dart';
import 'package:eit/controllers/sales_controller.dart';
import 'package:eit/screens/print_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/reports_controllers/reports_controller.dart';
import '../custom_widgets/date_filters.dart';
import '../helpers/loader.dart';
import '../models/customer_model.dart';

class SalesScreen extends GetView<SalesController> {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final authController = Get.find<AuthController>();
          bool isVisitsBased = authController.sysInfoModel?.custSys == '1';
          isVisitsBased
              ? Get.toNamed('/visits-screen')
              : Get.toNamed('/new-invoice');
        },
        label: Text('New'.tr),
        icon: const Icon(Icons.add),
        backgroundColor: darkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListTile(
                      leading: ElevatedButton(
                        onPressed: () async {
                          controller.customerNameFilter('');
                          controller.salesScreenDropDownCustomer.value =
                              CustomerModel(custName: 'Choose Customer'.tr);
                          controller.dateFromFilter.value =
                              firstOfJanuaryLastYear();
                          controller.dateToFilter(DateTime.now());
                          controller.getFilteredInvoices();
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll<Color>(darkColor)),
                        child: Text(
                          'All invoices'.tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Obx(
                        () => customerController.customersList.isEmpty
                            ? Text('Choose A Customer'.tr)
                            : DropdownSearch<CustomerModel>(
                                popupProps:
                                    const PopupProps.menu(showSearchBox: true),
                                items: customerController.customersList,
                                itemAsString: (customer) => customer.custName!,
                                onChanged: (customer) async {
                                  CustomerModel customerModel = customer!;
                                  controller.customerNameFilter(
                                      customerModel.custName!);
                                  Loading.load();
                                  await controller.getFilteredInvoices();
                                  Loading.dispose();
                                },
                                selectedItem: controller
                                    .salesScreenDropDownCustomer.value,
                              ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          showFilterBottomSheet(context, controller);
                        },
                        child: const Card(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: accentColor,
                            )),
                      )),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => controller.apiInvList.isEmpty
                    ? Center(child: Text('No Invoices For Today'.tr))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await controller.getFilteredInvoices();
                        },
                        color: accentColor,
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            itemCount: controller.apiInvList.length,
                            itemBuilder: (context, index) {
                              return ExpansionTile(
                                  textColor: accentColor,
                                  iconColor: accentColor,
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Invoice No: '.tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(controller.apiInvList[index].transID
                                          .toString()),
                                    ],
                                  ),
                                  children: [
                                    Row(children: [
                                      Text('Date: '.tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(controller.formatDate(
                                          controller.apiInvList[index].invDate))
                                    ]),
                                    Row(children: [
                                      Text('Customer Name: '.tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(controller.apiInvList[index].custName
                                          .toString())
                                    ]),
                                    const Divider(
                                      color: darkColor,
                                      thickness: 1,
                                    ),
                                    Row(children: [
                                      Text('Price: '.tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(controller
                                          .apiInvList[index].invAmount
                                          .toString())
                                    ]),
                                    Row(children: [
                                      Card(
                                        child: IconButton(
                                            onPressed: () async {
                                              final reportsController =
                                                  Get.find<ReportsController>();
                                              bool isPO =
                                                  await reportsController
                                                      .getInvDetails(
                                                          apiInv: controller
                                                                  .apiInvList[
                                                              index]);
                                              if (isPO) {
                                                Get.defaultDialog(
                                                    title: '',
                                                    middleText:
                                                        'Invoice pending acceptance, proceed to print PO?'
                                                            .tr,
                                                    textConfirm: 'Proceed'.tr,
                                                    textCancel: 'Cancel'.tr,
                                                    onConfirm: () async {
                                                      Get.back();
                                                      await printPOpreview(
                                                          poMaster:
                                                              reportsController
                                                                  .poMaster,
                                                          invoiceItems:
                                                              reportsController
                                                                  .salesInvDetails,
                                                          salesPODetails:
                                                              reportsController
                                                                  .salesPODetails,
                                                          isPO: isPO);
                                                    });
                                              } else {
                                                final homeController =
                                                    Get.find<HomeController>();
                                                await printPOpreview(
                                                    invMaster: reportsController
                                                        .invMaster,
                                                    vatIncluded: homeController
                                                        .vatIncluded.value,
                                                    invoiceItems:
                                                        reportsController
                                                            .salesInvDetails,
                                                    salesPODetails:
                                                        reportsController
                                                            .salesPODetails,
                                                    isPO: isPO);
                                              }
                                            },
                                            icon: Icon(
                                              Icons.print,
                                              color: darkColor.withOpacity(0.7),
                                            )),
                                      ),
                                      Card(
                                        child: controller.apiInvList[index]
                                                    .sysInvID ==
                                                0
                                            ? const Icon(
                                                Icons.pause_presentation,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.verified_outlined,
                                                color: Colors.green,
                                              ),
                                      )
                                    ]),
                                  ]);
                            })),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showFilterBottomSheet(BuildContext context, SalesController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    builder: (BuildContext context) {
      return Obx(
        () => Form(
          key: controller.filterFormKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filter'.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                          children: [
                            Text('Price Range From'.tr),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: accentColor),
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextFormField(
                                onTap: () {
                                  controller.priceFrom.clear();
                                },
                                controller: controller.priceFrom,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                            dateFromFilterMethod(
                                controller.dateFromFilter, context)
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Column(
                          children: [
                            Text('Price Range To'.tr),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: accentColor),
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextFormField(
                                onTap: () {
                                  controller.priceTo.clear();
                                },
                                controller: controller.priceTo,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                            dateToFilterMethod(controller.dateToFilter, context)
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.getFilteredInvoices(
                        amountFrom: double.parse(controller.priceFrom.text),
                        amountTo: double.parse(controller.priceTo.text),
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                    child: Text('Apply'.tr),
                  )
                ]),
          ),
        ),
      );
    },
  );
}
