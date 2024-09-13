import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/stock_controller.dart';
import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/custom_widgets/custom_drawer.dart';
import 'package:eit/helpers/loader.dart';
import 'package:eit/models/api/api_stock_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class StockScreen extends GetView<StockController> {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RxList<StockItemModel> filteredList = RxList<StockItemModel>();
    return Scaffold(
        appBar: customAppBar(text: 'Stock'.tr),
        endDrawer: const CustomDrawer(),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getItemsStock();
          },
          child: Obx(() => controller.stockItemList.isEmpty
              ? Center(
                  child: Text('Stock Items Unavailable'.tr),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Card(
                            child: ListTile(
                              leading: IconButton(
                                onPressed: () async {
                                  controller.stockItemDropDown =
                                      StockItemModel(itemName: 'Choose Item'.tr)
                                          .obs;
                                  controller.getItemsStock();
                                  filteredList.clear();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                              title: Obx(
                                () => controller.stockItemList.isEmpty
                                    ? Text('Choose Item'.tr)
                                    : DropdownSearch<StockItemModel>(
                                        popupProps: const PopupProps.menu(
                                            showSearchBox: true),
                                        items: controller.stockItemList,
                                        itemAsString: (item) => item.itemName!,
                                        onChanged: (item) async {
                                          StockItemModel stockItemModel = item!;
                                          Loading.load();
                                          await controller.getItemsStock();
                                          filteredList.clear();
                                          if (stockItemModel.itemId == null) {
                                            for (var item
                                                in controller.stockItemList) {
                                              filteredList.add(item);
                                            }
                                          } else {
                                            filteredList.add(stockItemModel);
                                          }
                                          Loading.dispose();
                                        },
                                        selectedItem:
                                            controller.stockItemDropDown.value,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Obx(
                        () => StockTable(
                          list: filteredList.isEmpty
                              ? controller.stockItemList
                              : filteredList,
                        ),
                      ),
                    ),
                  ],
                )),
        ));
  }
}

class StockTable extends StatelessWidget {
  final List<StockItemModel> list;
  const StockTable({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    Widget customHeaderCell(String text) {
      return Container(
          height: 50,
          color: accentColor,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ));
    }

    Widget customRowCell(
        {required String text,
        required int index,
        required StockItemModel item}) {
      return GestureDetector(
        onTap: () => onPress(item),
        child: Container(
            alignment: Alignment.center,
            height: 70,
            color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
            child: Text(
              text,
              style: const TextStyle(color: darkColor),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Table(
            textDirection: TextDirection.rtl,
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            border: TableBorder.all(width: 1.0, color: darkColor),
            children: [
              TableRow(children: [
                customHeaderCell('Item Name'.tr),
                customHeaderCell('Quantity'.tr),
                customHeaderCell('Unit'.tr),
              ]),
            ],
            columnWidths: const {
              0: FixedColumnWidth(300),
              1: FixedColumnWidth(100),
              2: FixedColumnWidth(100),
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                textDirection: TextDirection.rtl,
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                border: TableBorder.all(width: 1.0, color: darkColor),
                children: list.asMap().entries.map((_item) {
                  int index = _item.key;
                  StockItemModel item = _item.value;
                  return TableRow(children: [
                    customRowCell(
                        text: item.itemName ?? '', index: index, item: item),
                    customRowCell(
                        item: item,
                        text: item.quantity?.toStringAsFixed(2) ?? '0',
                        index: index),
                    customRowCell(
                        item: item, text: item.mainUnit ?? '', index: index),
                  ]);
                }).toList(),
                columnWidths: const {
                  0: FixedColumnWidth(300),
                  1: FixedColumnWidth(100),
                  2: FixedColumnWidth(100),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPress(StockItemModel item) {
    double? mainQty = item.quantity;
    double? subQty = (mainQty! % 1) * item.mainUnitPack!;
    double? smallQty = (subQty % 1) * item.subUnitPack!;
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                item.itemName ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              leading: Text(
                'Unit'.tr,
                style: const TextStyle(color: accentColor),
              ),
              title: Text('Quantity'.tr,
                  style: const TextStyle(color: accentColor)),
              trailing:
                  Text('Stock'.tr, style: const TextStyle(color: accentColor)),
            ),
            ListTile(
              leading: Text(item.mainUnit ?? ''),
              trailing: Text((!item.subUnit.isBlank!
                      ? mainQty.toInt()
                      : mainQty.toStringAsFixed(2))
                  .toString()),
            ),
            !item.subUnit.isBlank!
                ? ListTile(
                    leading: Text(item.subUnit ?? ''),
                    title: Text((item.mainUnitPack ?? 0).toString()),
                    trailing: Text((!item.smallUnit.isBlank!
                            ? subQty.toInt()
                            : subQty.toStringAsFixed(2))
                        .toString()),
                  )
                : const SizedBox(),
            !item.smallUnit.isBlank!
                ? ListTile(
                    leading: Text(item.smallUnit ?? ''),
                    title: Text((item.subUnitPack ?? 0).toString()),
                    trailing: Text(smallQty.toStringAsFixed(2)),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
