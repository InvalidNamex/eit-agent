import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/home_controller.dart';
import 'package:eit/controllers/sales_controller.dart';
import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/screens/new_invoice/save_files.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/customer_controller.dart';
import '/custom_widgets/custom_drawer.dart';
import '/models/item_model.dart';
import '../../constants.dart';
import '../../custom_widgets/add_item_dialog.dart';
import '../../custom_widgets/items_table.dart';
import '../../helpers/loader.dart';
import '../../helpers/toast.dart';
import '../../models/customer_model.dart';
import '../../utilities/qr_scanner.dart';
import 'isCashDropDown.dart';
import 'items_dropdown_widget.dart';

class NewInvoice extends GetView<SalesController> {
  const NewInvoice({super.key});
  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    final homeController = Get.find<HomeController>();
    List<CustomerModel> customersList = customerController.customersList;
    controller.isSubmitting(false);
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = controller.invoiceItemsList.isEmpty
            ? true
            : await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Are you sure?'.tr),
                  content: Text('Do you want to leave without saving?'.tr),
                  actions: [
                    TextButton(
                      child: Text('No'.tr),
                      onPressed: () {
                        Get.back();
                      }, // Disallow pop
                    ),
                    TextButton(
                      child: Text('Yes'.tr),
                      onPressed: () {
                        controller.invoiceNote.clear();
                        controller.invoiceItemsList.clear();
                        controller.isCustomerChosen(false);
                        controller.resetValues();
                        controller.isVisit(false);
                        controller.addItemDropDownCustomer.value =
                            CustomerModel(custName: 'Choose Customer'.tr);
                        controller.filterItemsByTreeList(0);
                        Get.offAllNamed('/index-screen');
                      },
                    ),
                  ],
                ),
              );
        controller.isCustomerChosen(false);
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: customAppBar(
          text: 'New Invoice'.tr,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => controller.isVisit.value
                      ? Card(
                          child: ListTile(
                            title:
                                Text(controller.customerModel?.custName ?? ''),
                            trailing: const Icon(
                              Icons.person,
                              color: accentColor,
                            ),
                          ),
                        )
                      : customersList.isEmpty
                          ? Text('Choose A Customer'.tr)
                          : Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.search,
                                  color: accentColor,
                                ),
                                title: DropdownSearch<CustomerModel>(
                                  popupProps: const PopupProps.menu(
                                      showSearchBox: true),
                                  items: customersList,
                                  itemAsString: (customer) =>
                                      customer.custName!,
                                  onChanged: (customer) async {
                                    try {
                                      CustomerModel customerModel = customer!;
                                      controller.customerModel = customer;
                                      controller.isCustomerChosen(true);
                                      if (controller
                                          .invoiceItemsList.isNotEmpty) {
                                        Get.defaultDialog(
                                          title:
                                              'Items in the invoice will be deleted as you change customer.\n Do you wish to proceed?'
                                                  .tr,
                                          titleStyle:
                                              const TextStyle(fontSize: 14),
                                          content: Column(children: [
                                            SizedBox(
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      controller
                                                          .invoiceItemsList
                                                          .clear();
                                                      await controller
                                                          .getFilteredItemsByCustomer(
                                                        customerID:
                                                            customerModel
                                                                .custCode!,
                                                      )
                                                          .whenComplete(() {
                                                        controller
                                                            .filterItemsByTreeList(
                                                                0);
                                                      });
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      'Yes'.tr,
                                                      style: const TextStyle(
                                                          color: darkColor),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        'No'.tr,
                                                        style: const TextStyle(
                                                            color: darkColor),
                                                      ))
                                                ],
                                              ),
                                            )
                                          ]),
                                        );
                                      } else {
                                        await controller
                                            .getFilteredItemsByCustomer(
                                          customerID: customerModel.custCode!,
                                        )
                                            .whenComplete(() {
                                          controller.filterItemsByTreeList(0);
                                        });
                                      }
                                    } catch (e) {
                                      AppToasts.errorToast(
                                          'Cannot find customer'.tr);
                                    }
                                  },
                                  selectedItem:
                                      controller.addItemDropDownCustomer.value,
                                ),
                              ),
                            ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Card(
                    child: ListTile(
                        leading: !controller.isCustomerChosen.value
                            ? const SizedBox()
                            : controller.customerItemsList.isEmpty
                                ? const Icon(
                                    Icons.qr_code_2,
                                    color: darkColor,
                                    size: 40,
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.qr_code_2,
                                      color: accentColor,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      String barcodeString =
                                          await barcodeScanner();
                                      ItemModel? item = controller
                                          .customerItemsList
                                          .firstWhereOrNull((item) =>
                                              item.barCode == barcodeString);
                                      if (item != null) {
                                        itemQtyPopUp(item, controller);
                                      } else {
                                        AppToasts.errorToast(
                                            '$barcodeString\nBarcode Not Found'
                                                .tr);
                                      }
                                    },
                                  ),
                        title: !controller.isCustomerChosen.value
                            ? InkWell(
                                onTap: () => Get.dialog(AlertDialog(
                                      content: Text(
                                          'You must first choose a customer'
                                              .tr),
                                    )),
                                child: Text('Choose Item'.tr))
                            : controller.isLoading.value
                                ? loader()
                                : controller.customerItemsList.isEmpty
                                    ? Text('No items or No price list available'
                                        .tr)
                                    : InkWell(
                                        onTap: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: itemsDropDownWidget(
                                                      controller: controller),
                                                );
                                              },
                                            ),
                                        child: Text('Choose Item'.tr))),
                  ),
                ),
              ),
              buildTable(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total Tax:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Text(
                      controller.totalTax.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total Discount:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Text(
                      controller.totalDiscount.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Text(
                      controller.grandTotal.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Note:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Flexible(
                        child: TextFormField(
                      controller: controller.invoiceNote,
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => !homeController.isPayTypeCash.value
                    ? Row(
                        children: [
                          Text(
                            'Pay Type: '.tr,
                            style:
                                const TextStyle(color: darkColor, fontSize: 18),
                          ),
                          Flexible(child: isCashDropDown(controller))
                        ],
                      )
                    : const SizedBox()),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Rounded corners
                      ),
                    ),
                    onPressed: () async {
                      controller.isSubmitting.value
                          ? null
                          : await saveInvoice(
                              controller: controller,
                              payType: controller.payType.value,
                              custID: controller.customerModel!.id,
                              isPrint: false);
                    },
                    child: controller.isSubmitting.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Save'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Rounded corners
                      ),
                    ),
                    onPressed: () async {
                      controller.isSubmitting.value
                          ? null
                          : await saveInvoice(
                              controller: controller,
                              payType: controller.payType.value,
                              custID: controller.customerModel!.id,
                              isPrint: true);
                    },
                    child: controller.isSubmitting.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Save & Print'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        endDrawer: const CustomDrawer(),
      ),
    );
  }
}
