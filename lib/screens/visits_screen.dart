import 'package:eit/controllers/visits_controller.dart';
import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/custom_widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sales_controller.dart';
import '../helpers/loader.dart';
import '../services/add_visit_service.dart';

class VisitsScreen extends GetView<VisitsController> {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: customAppBar(text: 'Routes'.tr),
        endDrawer: const CustomDrawer(),
        body: Obx(() => controller.isLoading.value
            ? Center(child: loader())
            : controller.customersListByRoute.isEmpty
                ? Center(
                    child: Text('No visits for the day'.tr),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) => Card(
                        child: ExpansionTile(
                      title: Text(controller
                          .customersListByRoute[index].custName
                          .toString()),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            customTile(
                                image: 'assets/images/colored_sells_card.png',
                                name: 'Sales'.tr,
                                onPress: () async {
                                  Loading.load();
                                  final salesController =
                                      Get.find<SalesController>();
                                  salesController.isCustomerChosen(true);
                                  await salesController
                                      .getFilteredItemsByCustomer(
                                          customerID: controller
                                              .customersListByRoute[index]
                                              .custCode!);
                                  Loading.dispose();
                                  salesController.isVisit(true);
                                  salesController.customerModel =
                                      controller.customersListByRoute[index];
                                  salesController.filterItemsByTreeList(0);
                                  Get.toNamed('/new-invoice');
                                }),
                            customTile(
                                image: 'assets/images/colored_payment_card.png',
                                name: 'Receipt Vouchers'.tr,
                                onPress: () {
                                  Get.toNamed('/new-receipt', arguments: {
                                    'custName': controller
                                        .customersListByRoute[index].custName
                                        .toString(),
                                    'planID': controller
                                        .customersListByRoute[index].planID
                                  });
                                }),
                            customTile(
                                image: 'assets/images/drawer_sells.png',
                                name: 'Returns'.tr,
                                onPress: () {
                                  Get.toNamed('/return-sales');
                                }),
                            customTile(
                                image: 'assets/images/visits_card.png',
                                name: 'Negative Visit'.tr,
                                onPress: () {
                                  Get.defaultDialog(
                                      title: 'Negative Visit'.tr,
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'This field cannot be empty'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                              controller: noteTextController,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0), // Adjust the radius for desired circularity
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState
                                                            ?.validate() ??
                                                        false) {
                                                      final AddVisitService
                                                          addVisitService =
                                                          Get.find<
                                                              AddVisitService>();
                                                      await addVisitService.saveVisit(
                                                          custID: controller
                                                              .customersListByRoute[
                                                                  index]
                                                              .id!,
                                                          visitType: 9,
                                                          note:
                                                              noteTextController
                                                                  .text,
                                                          planID: controller
                                                              .customersListByRoute[
                                                                  index]
                                                              .planID!);
                                                      Get.back();
                                                    }
                                                  },
                                                  child: Text('Submit'.tr)),
                                            )
                                          ],
                                        ),
                                      ));
                                }),
                          ],
                        )
                      ],
                    )),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 5,
                    ),
                    shrinkWrap: true,
                    itemCount: controller.customersListByRoute.length,
                  )));
  }
}

Widget customTile(
    {required String image, required String name, required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 25,
                width: 25,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(name.tr)
            ],
          ),
        )),
  );
}
