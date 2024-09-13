import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/stock_controller.dart';
import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/custom_widgets/custom_drawer.dart';
import 'package:eit/helpers/loader.dart';
import 'package:eit/models/item_tree_model.dart';
import 'package:eit/services/items_trees_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../models/item_model.dart';

class StockByTreeList extends GetView<StockController> {
  const StockByTreeList({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsTreeListService = Get.find<ItemsTreesService>();
    return Scaffold(
      appBar: customAppBar(text: 'Stock Management'.tr),
      endDrawer: const CustomDrawer(),
      body: Obx(() => controller.stockItemList.isEmpty
          ? Center(
              child: Text('Stock Management Not Available'.tr),
            )
          : Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => DropdownSearch<ItemTreeModel>(
                            popupProps:
                                const PopupProps.menu(showSearchBox: true),
                            items: itemsTreeListService.itemTreeList,
                            itemAsString: (item) => item.name!,
                            onChanged: (itemTree) async {
                              ItemTreeModel itemTreeModel = itemTree!;
                              Loading.load();
                              await controller.getItemsByTreeList(
                                  treeID: itemTreeModel.id!);
                              Loading.dispose();
                            },
                            selectedItem:
                                itemsTreeListService.treeItemDropDown.value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: controller.itemsByTreeList.isEmpty
                        ? Center(
                            child: Text('Choose Items Tree'.tr),
                          )
                        : StockTable(
                            list: controller.itemsByTreeList,
                          )),
              ],
            )),
    );
  }
}

class StockTable extends StatelessWidget {
  final List<ItemModel> list;
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

    Widget customRowCell({required String text, required int index}) {
      return Container(
          alignment: Alignment.center,
          height: 70,
          color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
          child: Text(
            text,
            style: const TextStyle(color: darkColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ));
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
                children: list.asMap().entries.map((customerLedger) {
                  int index = customerLedger.key;
                  ItemModel item = customerLedger.value;
                  return TableRow(children: [
                    customRowCell(text: item.itemName ?? '', index: index),
                    customRowCell(
                        text: item.qtyBalance?.toStringAsFixed(2) ?? '0',
                        index: index),
                    customRowCell(text: item.mainUnit ?? '', index: index),
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
}
