import 'package:eit/controllers/reports_controllers/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class ReportsScreen extends GetView<ReportsController> {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Sales Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Sales Analysis'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/sales-analysis');
                },
              ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Customers Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Customer Ledger'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/customer-ledger');
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Customers Balances'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/customers-balances');
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.arrow_forward_ios),
              //   title: Text('Visits List'.tr),
              //   onTap: () {
              //     Get.back();
              //     Get.toNamed('/');
              //   },
              // ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Products Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Stock Management'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/stock-by-tree-list');
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.arrow_forward_ios),
              //   title: Text('Product History'.tr),
              //   onTap: () {
              //     Get.back();
              //     Get.toNamed('/');
              //   },
              // ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Cash Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Cash Balance'.tr),
                onTap: () async {
                  await controller
                      .getCashBalance()
                      .whenComplete(() => Get.bottomSheet(
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: Colors.white),
                              height: 150,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Cash Balance'.tr,
                                      style: const TextStyle(
                                          fontSize: 16, color: darkColor),
                                    ),
                                    Text(
                                      '${controller.cashBalance.roundToDouble().toStringAsFixed(2)} L.E',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                            barrierColor: Colors.black.withOpacity(0.5),
                            isScrollControlled: true,
                          ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Cash Flow'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/cash-flow');
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
