import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/screens/new_invoice/treelist_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/sales_controller.dart';
import '../../custom_widgets/add_item_dialog.dart';
import '../../helpers/loader.dart';
import '../../models/item_model.dart';

Widget itemsDropDownWidget({required SalesController controller}) {
  return SingleChildScrollView(
    child: Container(
      width: Get.width * 0.9,
      child: Column(
        children: [
          Center(
            child: Text('Choose Item'.tr),
          ),
          const SizedBox(
            height: 10,
          ),
          const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              title: ItemDropdownSearch()),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Obx(
              () => controller.customerTreeItemsList.isEmpty
                  ? Text('No items in this tree'.tr)
                  : controller.isLoading.value
                      ? loader()
                      : DropdownSearch<ItemModel>(
                          popupProps: PopupProps.menu(
                              showSearchBox: true,
                              itemBuilder: (context, item, selected) {
                                return ListTile(
                                  title: Text(
                                    item.itemName ?? 'No Name'.tr,
                                    style: const TextStyle(
                                        color: darkColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          '${item.mainUnit}: ${item.mainUnitPack.toString()}'),
                                      SizedBox(
                                          height: 25,
                                          child: VerticalDivider(
                                            width: 20,
                                            color: darkColor.withOpacity(0.4),
                                            thickness: 2,
                                          )),
                                      Text(
                                          '${item.subUnit}: ${item.subUnitPack.toString()}'),
                                    ],
                                  ),
                                );
                              }),
                          items: controller.customerTreeItemsList,
                          itemAsString: (item) => item.itemName ?? 'No Name'.tr,
                          selectedItem: ItemModel(itemName: 'Choose Item'.tr),
                          onChanged: (item) {
                            Get.back();
                            itemQtyPopUp(item!, controller);
                          },
                        ),
            ),
          ),
        ],
      ),
    ),
  );
}
