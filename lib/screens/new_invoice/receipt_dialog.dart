import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '/constants.dart';
import '../../controllers/customer_controller.dart';
import '../../controllers/receipt_controller.dart';
import '../../helpers/loader.dart';
import '../../helpers/toast.dart';
import '../../models/customer_model.dart';

class ReceiptDialog extends GetView<ReceiptController> {
  String? customerNameArgument;
  bool? isPrint;
  ReceiptDialog({this.customerNameArgument, this.isPrint, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'mandatory field'.tr; // Validation message
              }
              return null; // Return null if the input is valid
            },
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.attach_money,
                color: accentColor,
              ),
              contentPadding: const EdgeInsets.all(5),
              labelText: 'Amount'.tr,
              labelStyle: const TextStyle(color: darkColor, fontSize: 14),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: accentColor.withOpacity(0.5)), // Change the bor
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                    color: accentColor.withOpacity(
                        0.5)), // Change the border color when not focused
              ),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: controller.receiptAmount,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.note_alt,
                color: accentColor,
              ),
              contentPadding: const EdgeInsets.all(5),
              labelText: 'Notes'.tr,
              labelStyle: const TextStyle(color: darkColor, fontSize: 14),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),

                borderSide: BorderSide(
                    color: accentColor.withOpacity(0.5)), // Change the bor
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),

                borderSide: BorderSide(
                    color: accentColor.withOpacity(
                        0.5)), // Change the border color when not focused
              ),
            ),
            maxLines: 3,
            textAlign: TextAlign.start,
            controller: controller.notes,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Rounded corners
                ),
              ),
              onPressed: () async {
                try {
                  Loading.load();
                  if (customerNameArgument != null &&
                      customerNameArgument != '') {
                    final customerController = Get.find<CustomerController>();
                    CustomerModel _customer = customerController.customersList
                        .where((CustomerModel customer) =>
                            customer.custName == customerNameArgument)
                        .first;
                    controller.newReceiptDropDownCustomer.value = _customer;
                  }
                  controller.isSubmitting.value
                      ? null
                      : await controller.saveReceipt(planID: 0);
                  controller.newReceiptDropDownCustomer =
                      CustomerModel(custName: 'Choose Customer'.tr).obs;
                  Loading.dispose();
                  controller.notes.clear();
                  controller.receiptAmount.clear();
                  Get.offNamed('/index-screen');
                } catch (e) {
                  if (e is TypeError) {
                    Get.back();
                    AppToasts.errorToast(
                        'Customer must be chosen before saving'.tr);
                  } else {
                    AppToasts.errorToast(e.toString());
                    Logger().e(e.toString());
                  }
                }
              },
              child: controller.isSubmitting.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Save Receipt'.tr,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
