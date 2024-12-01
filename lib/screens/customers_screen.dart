import 'package:eit/constants.dart';
import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../custom_widgets/download_customers.dart';
import '../helpers/toast.dart';
import '../map_hierarchy/location_service.dart';

class CustomersScreen extends GetView<CustomerController> {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxList<TableRow> tableRowByCustomer() {
      RxList<TableRow> tableRows = RxList();
      for (final x in controller.customersList) {
        tableRows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.custName ?? '',
                maxLines: 3,
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.phone ?? '',
                maxLines: 3,
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.address ?? '',
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () async {
                    if (x.gpsLocation != null) {
                      try {
                        List<String> parts = x.gpsLocation!.split("-");
                        double lat = double.parse(parts[0]);
                        double long = double.parse(parts[1]);
                        await LocationService.launchMapsUrl(
                            lat: lat, long: long);
                      } catch (e) {
                        AppToasts.errorToast('Could not find address'.tr);
                        Logger logger = Logger();
                        logger.d(e);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.edit_location_alt_outlined,
                    color: accentColor,
                  ),
                )),
          ],
        ));
      }
      return tableRows;
    }

    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: darkColor,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
              child: const Icon(
                Icons.download,
                color: lightColor,
              ),
              backgroundColor: accentColor,
              onTap: () async {
                Loading.load();
                await generateCustomersReportPdf(controller);
                Loading.dispose();
              }),
          SpeedDialChild(
              child: const Icon(
                Icons.add_reaction_outlined,
                color: lightColor,
              ),
              backgroundColor: accentColor,
              onTap: () {
                Get.toNamed('/new-customer');
              }),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? loader()
            : RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchCustomers();
                },
                child: controller.customersList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('No Customers Found'.tr),
                            IconButton(
                                onPressed: () async {
                                  await controller.fetchCustomers();
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: accentColor,
                                ))
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                      color: accentColor,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Name'.tr,
                                        style: const TextStyle(
                                            color: lightColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      color: accentColor,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Phone'.tr,
                                        style: const TextStyle(
                                            color: lightColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      color: accentColor,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Address'.tr,
                                        style: const TextStyle(
                                            color: lightColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      color: accentColor,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Edit'.tr,
                                        style: const TextStyle(
                                            color: lightColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              columnWidths: const {
                                0: FixedColumnWidth(200),
                                1: FixedColumnWidth(200),
                                2: FixedColumnWidth(250),
                                3: FixedColumnWidth(100),
                              },
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FixedColumnWidth(200),
                                    1: FixedColumnWidth(200),
                                    2: FixedColumnWidth(250),
                                    3: FixedColumnWidth(100),
                                  },
                                  border: TableBorder.all(
                                      width: 1.0, color: darkColor),
                                  children: tableRowByCustomer(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
