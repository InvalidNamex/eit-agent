import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../constants.dart';

Widget loader() => const SpinKitChasingDots(
      color: accentColor,
    );

class Loading {
  static load() => Get.dialog(
        const SpinKitChasingDots(
          color: accentColor,
        ),
        barrierDismissible: false,
      );
  static dispose() => Get.back();
}
