import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<bool> isWithinDistance({required String gpsLocation}) async {
  try {
    final authController = Get.find<AuthController>();
    Position userLocation = await Geolocator.getCurrentPosition();
    List<String> coordinates = gpsLocation.split('-');
    double distanceInMeters = await Geolocator.distanceBetween(
      double.parse(coordinates[0]),
      double.parse(coordinates[1]),
      userLocation.latitude,
      userLocation.longitude,
    );

    //get the distance from api

    if (authController.sysInfoModel!.custLocAcu != '0') {
      if (distanceInMeters <=
          int.parse(authController.sysInfoModel!.custLocAcu!)) {
        return true;
      } else {
        AppToasts.errorToast(
            'You are not within the allowed range to make this transaction'.tr);
        return false;
      }
    } else {
      return true;
    }
  } on FormatException catch (e) {
    AppToasts.errorToast("Distance is not defined for comparison".tr);
    return false;
  }
}
