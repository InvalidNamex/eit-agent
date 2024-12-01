import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eit/helpers/toast.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  RxString connectionStatus = 'unknown'.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = "wifi";
        Phoenix.rebirth(Get.context!);
        Get.toNamed('/');
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = "data";
        Phoenix.rebirth(Get.context!);
        Get.toNamed('/');
        break;
      case ConnectivityResult.none:
        connectionStatus.value = "lost";
        Get.offAllNamed('/no-connection');
        break;
      default:
        connectionStatus.value = "unknown";
        AppToasts.errorToast('Internet status unknown');
        break;
    }
  }
}
// add this package to pubspec.yaml
// flutter pub add connectivity_plus
//https://pub.dev/packages/connectivity_plus
