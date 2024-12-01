import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/models/api/api_invoice_item.dart';
import '/models/invoice_item_model.dart';
import '../constants.dart';
import '../controllers/sales_controller.dart';
import '../helpers/max_value_formatter.dart';
import '../models/item_model.dart';

void itemEditQtyPopUp(InvoiceItemModel invoiceItemModel, ItemModel item,
    SalesController controller, BuildContext context) {
  RxDouble itemTotalPrice = 0.0.obs;
  RxDouble itemTotalDiscount = 0.0.obs;
  RxDouble itemTotalTax = 0.0.obs;
  String getProcessedValue(String value) {
    // Remove leading zeros
    return value.replaceFirst(RegExp(r'^0+'), '');
  }

  controller.mainQty.text = invoiceItemModel.mainQty != null
      ? invoiceItemModel.mainQty.toString()
      : '0';
  controller.subQty.text = invoiceItemModel.subQty != null
      ? invoiceItemModel.subQty.toString()
      : '0';
  controller.smallQty.text = invoiceItemModel.smallQty != null
      ? invoiceItemModel.smallQty.toString()
      : '0';
  calculatePrice() {
    double mainQty = double.parse(
        controller.mainQty.text.isEmpty ? '0' : controller.mainQty.text);
    double subQty = double.parse(
            controller.subQty.text.isEmpty ? '0' : controller.subQty.text) /
        (item.mainUnitPack ?? 0);
    double smallQty = double.parse(
            controller.smallQty.text.isEmpty ? '0' : controller.smallQty.text) /
        (item.subUnitPack ?? 0) /
        (item.mainUnitPack ?? 0);
    double totalQty = mainQty + subQty + smallQty;
    itemTotalPrice(totalQty * (item.price ?? 0));
    itemTotalDiscount(
        itemTotalPrice.value * (item.disc != null ? (item.disc! / 100) : 0));
    itemTotalTax((itemTotalPrice.value - itemTotalDiscount.value) *
        (item.vat != null ? (item.vat! / 100) : 0));
  }

  calculatePrice();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: SingleChildScrollView(
            child: Form(
              key: controller.itemQuantityFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Quantity'.tr),
                  Card(
                    child: ListTile(
                      leading: Text(
                        item.mainUnit ?? 'Main Unit'.tr,
                      ),
                      title: TextFormField(
                        onTap: () {
                          controller.mainQty.clear();
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final _x = getProcessedValue(value);
                            controller.mainQty.text = _x;
                          } else {
                            controller.mainQty.text = 0.toString();
                          }
                          calculatePrice();
                        },
                        textAlign: TextAlign.center,
                        controller: controller.mainQty,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        autofocus: true,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .transparent), // Change the border color when focused
                          ),
                        ),
                      ),
                    ),
                  ),
                  item.subUnit.isBlank!
                      ? const SizedBox()
                      : Card(
                          child: ListTile(
                            leading: Text(
                              item.subUnit ?? 'Sub Unit'.tr,
                            ),
                            title: TextFormField(
                              onTap: () {
                                controller.subQty.clear();
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  final _x = getProcessedValue(value);
                                  controller.subQty.text = _x;
                                } else {
                                  controller.subQty.text = 0.toString();
                                }
                                calculatePrice();
                              },
                              textAlign: TextAlign.center,
                              controller: controller.subQty,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              autofocus: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d*\.?\d*')), // Allows only numbers and decimal points
                                MaxValueInputFormatter(item.mainUnitPack ??
                                    1), // Custom formatter to limit the value
                              ],
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Change the border color when focused
                                ),
                              ),
                            ),
                            trailing: Text(item.mainUnitPack.toString()),
                          ),
                        ),
                  item.smallUnit.isBlank!
                      ? const SizedBox()
                      : Card(
                          child: ListTile(
                            leading: Text(
                              item.smallUnit ?? 'Small Unit'.tr,
                            ),
                            title: TextFormField(
                              onTap: () {
                                controller.smallQty.clear();
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  final _x = getProcessedValue(value);
                                  controller.smallQty.text = _x;
                                } else {
                                  controller.smallQty.text = 0.toString();
                                }
                                calculatePrice();
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d*\.?\d*')), // Allows only numbers and decimal points
                                MaxValueInputFormatter(item.subUnitPack ??
                                    1), // Custom formatter to limit the value
                              ],
                              textAlign: TextAlign.center,
                              controller: controller.smallQty,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              autofocus: true,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Change the border color when focused
                                ),
                              ),
                            ),
                            trailing: Text(item.subUnitPack.toString()),
                          ),
                        ),
                  Row(
                    children: [
                      Text(
                        'Price: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          (itemTotalPrice).toStringAsFixed(2),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Discount: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          (itemTotalDiscount).toStringAsFixed(2),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tax: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          (itemTotalTax).toStringAsFixed(2),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.invoiceItemsList.remove(invoiceItemModel);
                        controller.apiInvoiceItemList
                            .removeWhere((x) => x.itemId == item.id);
                        InvoiceItemModel invItemModel = InvoiceItemModel(
                          mainQty: double.tryParse(controller.mainQty.text),
                          subQty: double.tryParse(controller.subQty.text),
                          smallQty: double.tryParse(controller.smallQty.text),
                          itemName: item.itemName,
                          quantity:
                              '${controller.mainQty.text.isEmpty ? '' : '${item.mainUnit}: ${controller.mainQty.text}'}${controller.subQty.text.isEmpty ? '' : '\n${item.subUnit}: ${controller.subQty.text}'}${controller.smallQty.text.isEmpty ? '' : '\n${item.smallUnit}: ${controller.smallQty.text}'}',
                          price: (item.price ?? 0),
                          discount: itemTotalDiscount.value,
                          tax: itemTotalTax.value,
                          total: ((itemTotalPrice.value -
                                  itemTotalDiscount.value) +
                              itemTotalTax.value),
                        );
                        controller.invoiceItemsList.add(invItemModel);
                        ApiInvoiceItem apiInvoiceItem = ApiInvoiceItem(
                            itemId: item.id!,
                            price: (itemTotalPrice.value),
                            quantity: ((controller.mainQty.text != '0' &&
                                        controller.mainQty.text.isNotEmpty
                                    ? double.parse(controller.mainQty.text)
                                    : 0.0) +
                                (controller.subQty.text != '0' &&
                                        controller.subQty.text.isNotEmpty
                                    ? (double.parse(controller.subQty.text) /
                                        item.mainUnitPack!)
                                    : 0.0) +
                                (controller.smallQty.text != '0' &&
                                        controller.smallQty.text.isNotEmpty
                                    ? ((double.parse(controller.smallQty.text) /
                                            item.subUnitPack!) /
                                        item.mainUnitPack!)
                                    : 0.0)),
                            discountPercentage: (item.disc ?? 0),
                            vatPercentage: (item.vat ?? 0));
                        controller.apiInvoiceItemList.add(apiInvoiceItem);
                        Get.back();
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: darkColor),
                      child: Text(
                        'Edit'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: lightColor),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.invoiceItemsList.remove(invoiceItemModel);
                        controller.apiInvoiceItemList
                            .removeWhere((x) => x.itemId == item.id);
                        Get.back();
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        'Delete'.tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: lightColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )));
}
