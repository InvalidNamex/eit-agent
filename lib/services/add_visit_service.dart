import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../helpers/toast.dart';
import '../models/user_model.dart';

class AddVisitService extends GetxService {
  RxBool isSubmitting = false.obs;
  Future saveVisit(
      {required int custID,
      required int visitType,
      String note = '',
      int planID = 0}) async {
    final authController = Get.find<AuthController>();
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    Position userLocation = await Geolocator.getCurrentPosition();
    RxBool isLoading = false.obs;
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      // https://mobiletest.itgenesis.app/AddVisit?ServiceKey=1357&SalesRepID=1&CustID=304&Latitude=24.00000&Longitude=46.00000&VisitType=1&VisitNote=test note&PlanID=1
      final url = Uri.parse(
          'https://$apiURL/AddVisit?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&CustID=$custID&Latitude=${userLocation.latitude}&Longitude=${userLocation.longitude}&VisitType=$visitType&VisitNote=$note&PlanID=$planID');
      try {
        isLoading(true);
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            if (data['MESSAGE'] == "Visit has been saved.") {
              Logger().d('visit has been saved'.tr);
              AppToasts.successToast('visit has been saved'.tr);
            }
          } else {
            AppToasts.errorToast('Visit was not saved, try again later'.tr);
            Logger()
                .e('Visit was not saved, try again later, reportsController');
          }
        }
        isLoading(false);
      } catch (e) {
        AppToasts.errorToast('Error occurred, contact support'.tr);
        Logger logger = Logger();
        logger.d(e.toString());
      } finally {
        isSubmitting.value = false; // Reset the button state
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }
  }
}
