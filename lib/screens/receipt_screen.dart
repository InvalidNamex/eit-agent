import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/custom_widgets/date_filters.dart';
import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/receipt_controller.dart';
import '../custom_widgets/custom_drawer.dart';

class ReceiptScreen extends GetView<ReceiptController> {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final authController = Get.find<AuthController>();
          bool isVisitsBased = authController.sysInfoModel?.custSys == '1';
          isVisitsBased
              ? Get.toNamed('/visits-screen')
              : Get.toNamed('/new-receipt');
        },
        icon: const Icon(Icons.add),
        label: Text('New Receipt'.tr),
        backgroundColor: darkColor,
      ),
      appBar: customAppBar(text: 'Receipt'.tr),
      endDrawer: const CustomDrawer(),
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: dateFromFilterMethod(
                          controller.dateFromFilter, context,
                          optionalFunction: () async =>
                              controller.getReceiptVouchers())),
                  Flexible(
                      child: dateToFilterMethod(
                          controller.dateToFilter, context,
                          optionalFunction: () async =>
                              controller.getReceiptVouchers()))
                ],
              ),
            ),
            controller.receiptModelList.isEmpty
                ? Center(child: Text('No Invoices Found.'.tr))
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.getReceiptVouchers();
                      },
                      color: accentColor,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: controller.receiptModelList.length,
                          itemBuilder: (context, index) {
                            String? date =
                                controller.receiptModelList[index].transDt ??
                                    '';
                            List<String?>? newDate = date.split('T');
                            return ExpansionTile(
                              textColor: accentColor,
                              iconColor: accentColor,
                              title: Text(
                                controller.receiptModelList[index].custName ??
                                    '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: Text(newDate[0] ?? ''),
                              children: [
                                controller.receiptModelList[index].docNo !=
                                            null &&
                                        controller.receiptModelList[index]
                                                .docNo !=
                                            ''
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Doc No: '.tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller
                                                .receiptModelList[index].docNo
                                                .toString()),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Amount: '.tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text((controller.receiptModelList[index]
                                                  .payValue ??
                                              0)
                                          .toString()),
                                    ],
                                  ),
                                ),
                                controller.receiptModelList[index].notes != ''
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Notes: '.tr,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(controller
                                                    .receiptModelList[index]
                                                    .notes ??
                                                ''),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'State: '.tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      controller.receiptModelList[index]
                                                  .transStateAcc ==
                                              0
                                          ? const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
