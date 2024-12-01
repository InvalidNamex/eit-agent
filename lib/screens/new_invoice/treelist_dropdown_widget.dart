import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/sales_controller.dart';
import 'package:eit/services/items_trees_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/item_tree_model.dart';

class ItemDropdownSearch extends GetView<ItemsTreesService> {
  const ItemDropdownSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final salesController = Get.find<SalesController>();
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Obx(
            () => DropdownSearch<ItemTreeModel>(
              popupProps: const PopupProps.menu(showSearchBox: true),
              items: controller.itemTreeList,
              itemAsString: (item) => item.name!,
              onChanged: (itemTree) async {
                ItemTreeModel itemTreeModel = itemTree!;
                salesController.filterItemsByTreeList(itemTreeModel.id!);
              },
              selectedItem: controller.treeItemDropDown.value,
            ),
          ),
        ),
      ],
    );
  }
}
