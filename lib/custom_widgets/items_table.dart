import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/constants.dart';
import '/controllers/sales_controller.dart';
import '/models/invoice_item_model.dart';
import '/models/item_model.dart';
import 'edit_item_dialog.dart';

Widget buildTable(BuildContext context) {
  final controller = Get.find<SalesController>();
  RxList<TableRow> tableRowByItem() {
    RxList<TableRow> tableRows = RxList();
    TableRow headers = TableRow(
      children: [
        Container(
          color: darkColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Item'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: darkColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Quantity'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: darkColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Total'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    tableRows.insert(0, headers);
    for (InvoiceItemModel x in controller.invoiceItemsList) {
      tableRows.add(TableRow(
        children: [
          InkWell(
            onTap: () {
              ItemModel _item = controller.customerItemsList
                  .firstWhere((element) => element.itemName == x.itemName);
              itemEditQtyPopUp(x, _item, controller, context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.customerItemsList
                        .firstWhere((element) => element.itemName == x.itemName)
                        .itemName ??
                    '',
                maxLines: 3,
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ItemModel _item = controller.customerItemsList
                  .firstWhere((element) => element.itemName == x.itemName);
              itemEditQtyPopUp(x, _item, controller, context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.quantity.toString(),
                maxLines: 3,
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ItemModel _item = controller.customerItemsList
                  .firstWhere((element) => element.itemName == x.itemName);
              itemEditQtyPopUp(x, _item, controller, context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (x.total ?? 0).toStringAsFixed(2),
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
          ),
        ],
      ));
    }

    return tableRows;
  }

  return Obx(
    () => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        columnWidths: const {
          0: FixedColumnWidth(250.0),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(100),
        },
        border: TableBorder.all(width: 1.0, color: accentColor),
        children: tableRowByItem(),
      ),
    ),
  );
}
