import 'package:eit/controllers/reports_controllers/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../localization_hierarchy/update_locale_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Drawer(
      child: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                controller.navigateToTab(0);
                Get.back();
              },
              leading: Image.asset(
                'assets/images/drawer_home.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Home'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_sells.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Sales'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('View Invoices'.tr),
                  onTap: () {
                    controller.navigateToTab(1);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Add Invoice'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/new-invoice');
                  },
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_customers.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Customers'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('View Customers'.tr),
                  onTap: () {
                    controller.navigateToTab(2);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Add Customer'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/new-customer');
                  },
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_sells.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Receipt Vouchers'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('View Receipt Vouchers'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/receipt-screen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Add Receipt Voucher'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/new-receipt');
                  },
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_products.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Stock'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('View Items Stock'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/stock-screen');
                  },
                ),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_inquiries.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Reports'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
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
                  title: Text('Customers Balance'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/customers-balances');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Visits List'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/visits-screen');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Cash Balance'.tr),
                  onTap: () async {
                    final _reportsController = Get.find<ReportsController>();
                    Get.back();
                    await _reportsController
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
                                        '${_reportsController.cashBalance.roundToDouble().toStringAsFixed(2)} L.E',
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
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_settings.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Settings & Privacy'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text('Language'.tr),
                  onTap: () {
                    showLocaleDialog();
                  },
                ),
                ListTile(
                  onTap: () async {},
                  title: Text(
                    'Sell Price Included VAT'.tr,
                  ),
                  trailing: Obx(() => Checkbox(
                        value: controller.vatIncluded.value,
                        onChanged: (bool? value) {
                          controller.vatIncluded(value);
                          controller.setPayTypePref(
                              boolName: 'vatIncluded', isCash: value!);
                        },
                      )),
                ),
                // ListTile(
                //   onTap: () async {},
                //   title: Text(
                //     'Payment Gateway Is Cash'.tr,
                //   ),
                //   trailing: Obx(() => Checkbox(
                //         value: controller.isPayTypeCash.value,
                //         onChanged: (bool? value) {
                //           controller.isPayTypeCash(value);
                //           controller.setPayTypePref(
                //               boolName: 'isCash', isCash: value!);
                //         },
                //       )),
                // ),
                ListTile(
                  onTap: () async {},
                  title: Text(
                    'Enable Customer Limit'.tr,
                  ),
                  trailing: Obx(() => Checkbox(
                        value: controller.enableCustomerLimit.value,
                        onChanged: (bool? value) {
                          controller.enableCustomerLimit(value);
                          controller.setPayTypePref(
                              boolName: 'enableCustomerLimit', isCash: value!);
                        },
                      )),
                ),
                ListTile(
                  onTap: () async {},
                  title: Text(
                    'Add Taxable And Non Taxable Products In Sales'.tr,
                  ),
                  trailing: Obx(() => Checkbox(
                        value: controller
                            .addTaxableAndNonTaxableProductsInSales.value,
                        onChanged: (bool? value) {
                          controller
                              .addTaxableAndNonTaxableProductsInSales(value);
                          controller.setPayTypePref(
                              boolName:
                                  'addTaxableAndNonTaxableProductsInSales',
                              isCash: value!);
                        },
                      )),
                ),
                // ListTile(
                //   onTap: () async {},
                //   title: Text(
                //     'Following Up Invoices Payment'.tr,
                //   ),
                //   trailing: Obx(() => Checkbox(
                //         value: controller.followingUpInvoicesPayment.value,
                //         onChanged: (bool? value) {
                //           controller.followingUpInvoicesPayment(value);
                //           controller.setPayTypePref(
                //               boolName: 'followingUpInvoicesPayment',
                //               isCash: value!);
                //         },
                //       )),
                // ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              onTap: () async {
                final authController = Get.find<AuthController>();
                await authController.clearDataFromPrefs('userData');
                Get.offAllNamed('/login-screen');
              },
              leading: Image.asset(
                'assets/images/drawer_logout.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Log Out'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
