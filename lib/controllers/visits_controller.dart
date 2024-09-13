import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../helpers/toast.dart';
import '../models/customer_model.dart';
import '../models/user_model.dart';

class VisitsController extends GetxController {
  //here are the main options for the app
  /*
    MobileCustSys = 17
    MobileVersion = 18
    MobileDownloadPath = 19;
    MobileMandatoryUpdate = 20;
   */
  RxBool isLoading = false.obs;
  final authController = Get.find<AuthController>();
  RxList<CustomerModel> customersListByRoute = RxList<CustomerModel>();
  Future<void> fetchCustomersByRoute(
      {String pageNo = '-1', String pageSize = '1'}) async {
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    String dateFrom = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String dateTo = DateFormat('dd/MM/yyyy').format(DateTime.now());
    List<String?>? newDateFrom = dateFrom.split('T');
    List<String?>? newDateTo = dateTo.split('T');
    //! hint: backend has wronged salesRepID for userID.
    final url = Uri.parse(
        //https://Mobiletest.itgenesis.app/GetVisitPlan?ServiceKey=1357&SalesRepID=1&datefrom=10/05/2024&dateto=11/05/2024&PageNo=0
        'https://$apiURL/GetVisitPlan?ServiceKey=$secretKey&SalesRepID=${user!.userID}&datefrom=${newDateFrom[0]}&dateto=${newDateTo[0]}&PageNo=$pageNo');
    try {
      isLoading(true);
      customersListByRoute.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          if (data['data'] != "Empty Data.") {
            final List _x = json.decode(data['data']);
            for (final x in _x) {
              if (!customersListByRoute.contains(x)) {
                customersListByRoute.add(CustomerModel.fromJson(x));
              }
            }
          }
        } else {
          Logger().e(response.statusCode.toString());
          AppToasts.errorToast('Server Response Error'.tr);
        }
      } else {
        AppToasts.errorToast(response.statusCode.toString());
        Logger().e(response.statusCode.toString());
      }
      isLoading(false);
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchCustomersByRoute();
  }
}
