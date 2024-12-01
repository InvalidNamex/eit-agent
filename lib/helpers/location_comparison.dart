import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/controllers/sales_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<bool> isWithinDistance({required String gpsLocation}) async {
  final authController = Get.find<AuthController>();
  final salesController = Get.find<SalesController>();
  try {
    Position userLocation = await Geolocator.getCurrentPosition();
    List<String> coordinates = gpsLocation.split('-');
    double distanceInMeters = Geolocator.distanceBetween(
      double.parse(coordinates[0]),
      double.parse(coordinates[1]),
      userLocation.latitude,
      userLocation.longitude,
    );

    if (authController.sysInfoModel!.custLocAcu != '0') {
      if (distanceInMeters <=
          int.parse(authController.sysInfoModel!.custLocAcu!)) {
        return true;
      } else {
        if (authController.sysInfoModel!.transOnlyInLocation! == '0') {
          return true;
        } else {
          AppToasts.errorToast(
              'You are not within the allowed range to make this transaction'
                  .tr);
          salesController.isSubmitting(false);
          return false;
        }
      }
    } else {
      return true;
    }
  } on FormatException catch (e) {
    if (authController.sysInfoModel!.transOnlyInLocation! == '0') {
      return true;
    } else {
      AppToasts.errorToast('Distance is not defined for comparison');
      salesController.isSubmitting(false);
      return false;
    }
  }
}
