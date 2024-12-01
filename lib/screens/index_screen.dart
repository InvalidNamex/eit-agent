import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/controllers/home_controller.dart';
import 'package:eit/screens/home_screen.dart';
import 'package:eit/screens/reports_screens/reports_screen.dart';
import 'package:eit/screens/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../custom_widgets/custom_drawer.dart';
import 'customers_screen.dart';

class IndexScreen extends GetView<HomeController> {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    authController.userModel = authController.userModel;
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'.tr),
              content: Text('Do you want to leave the app?'.tr),
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
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        },
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                  color: darkColor), // Setting the icon color
              title: Image.asset(
                'assets/images/icon.png',
                height: 30,
                width: 60,
              ),

              bottom: TabBar.secondary(
                controller: controller.tabController,
                indicatorColor: darkColor,
                labelColor: lightColor,
                isScrollable: false,
                labelStyle: const TextStyle(fontSize: 16),
                // tabAlignment: TabAlignment.center,
                tabs: [
                  tabTitle(image: 'assets/images/house.png', name: 'Home'.tr),
                  tabTitle(image: 'assets/images/carts.png', name: 'Sales'.tr),
                  tabTitle(
                      image: 'assets/images/customer.png',
                      name: 'Customers'.tr),
                  tabTitle(
                      image: 'assets/images/report.png', name: 'Reports'.tr),
                ],
              ),
              backgroundColor: lightColor,
            ),
            body: TabBarView(
              controller: controller.tabController,
              children: const [
                HomeScreen(),
                SalesScreen(),
                CustomersScreen(),
                ReportsScreen(),
              ],
            ),
            endDrawer: const CustomDrawer(),
          ),
        ));
  }
}

Widget tabTitle({required String image, required String name}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset(
        image,
        height: 25,
        width: 25,
      ),
      FittedBox(
        child: Text(
          name.tr,
          style: const TextStyle(color: Colors.black, fontFamily: 'Cairo'),
        ),
      )
    ],
  );
}
