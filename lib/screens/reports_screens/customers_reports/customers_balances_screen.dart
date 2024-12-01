import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/custom_widgets/custom_drawer.dart';
import 'package:eit/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/reports_controllers/customer_reports_controller.dart';

class CustomersBalancesScreen extends GetView<CustomerReportsController> {
  const CustomersBalancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getCustomersBalances();
    return Scaffold(
      appBar: customAppBar(
        text: 'Customers Balances'.tr,
      ),
      endDrawer: const CustomDrawer(),
      body: Obx(() {
        return controller.isLoading.value
            ? loader()
            : controller.customersBalancesList.isEmpty
                ? Center(
                    child: Text('No customers found'.tr),
                  )
                : SingleChildScrollView(
                    child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(accentColor),
                          border: TableBorder.all(color: darkColor),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Customer Name'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Balance'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows:
                              controller.customersBalancesList.map((customer) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  customer.custName ?? '',
                                  overflow: TextOverflow.fade,
                                )),
                                DataCell(Text(
                                    customer.custBalance?.toStringAsFixed(2) ??
                                        '')),
                              ],
                            );
                          }).toList(),
                        )),
                  );
      }),
    );
  }
}
