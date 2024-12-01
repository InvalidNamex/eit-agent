import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sales_controller.dart';

Widget isCashDropDown(SalesController controller) {
  return Obx(() {
    return DropdownButton<String>(
      value: controller.payType.value == 0 ? 'Cash' : 'Credit',
      items: [
        DropdownMenuItem<String>(
          value: 'Cash',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text('Cash'.tr),
          ),
        ),
        DropdownMenuItem<String>(
            value: 'Credit',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('Credit'.tr),
            )),
      ],
      onChanged: (value) {
        if (value == 'Cash') {
          controller.payType.value = 0;
        } else {
          controller.payType.value = 1;
        }
      },
    );
  });
}
