import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/reports_controllers/reports_controller.dart';
import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/custom_widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/customer_controller.dart';
import '../../custom_widgets/custom_table.dart';
import '../../custom_widgets/date_filters.dart';
import '../../helpers/loader.dart';
import '../../helpers/toast.dart';
import '../../models/customer_model.dart';

class CustomerLedgerScreen extends GetView<ReportsController> {
  const CustomerLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    return PopScope(
        canPop: true,
        onPopInvoked: (x) {
          controller.reportsScreenCustomerModel(
              CustomerModel(custName: 'Choose Customer'.tr));
        },
        child: Scaffold(
          appBar: customAppBar(text: 'Customer Ledger'.tr),
          endDrawer: const CustomDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: dateFromFilterMethod(
                              controller.dateFromFilter, context,
                              optionalFunction: () async {
                            controller.reportsScreenCustomerModel.value
                                        .custName ==
                                    'Choose Customer'.tr
                                ? AppToasts.errorToast(
                                    'Please choose a customer'.tr)
                                : await controller.getCustomerLedger(
                                    custID: controller
                                        .reportsScreenCustomerModel.value.id!);
                          }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: dateToFilterMethod(
                              controller.dateToFilter, context,
                              optionalFunction: () async {
                            controller.reportsScreenCustomerModel.value
                                        .custName ==
                                    'Choose Customer'.tr
                                ? AppToasts.errorToast('اختر عميل أولًا')
                                : await controller.getCustomerLedger(
                                    custID: controller
                                        .reportsScreenCustomerModel.value.id!);
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => customerController.customersList.isEmpty
                      ? Text('Choose A Customer'.tr)
                      : DropdownSearch<CustomerModel>(
                          popupProps:
                              const PopupProps.menu(showSearchBox: true),
                          items: customerController.customersList,
                          itemAsString: (customer) => customer.custName!,
                          onChanged: (customer) async {
                            CustomerModel customerModel = customer!;
                            Loading.load();
                            controller.reportsScreenCustomerModel.value =
                                customerModel;
                            await controller.getCustomerLedger(
                                custID: controller
                                    .reportsScreenCustomerModel.value.id!);
                            Loading.dispose();
                          },
                          selectedItem:
                              controller.reportsScreenCustomerModel.value,
                        ),
                ),
                Expanded(
                  child: Obx(
                    () => controller.customerLedgerList.isEmpty
                        ? Center(child: Text('No Transactions'.tr))
                        : CustomTable(list: controller.customerLedgerList),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
