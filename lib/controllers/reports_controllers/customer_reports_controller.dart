import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../helpers/toast.dart';
import '../../models/customer_balance_model.dart';
import '../../models/user_model.dart';

class CustomerReportsController extends GetxController {
  final authController = Get.find<AuthController>();
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;
  RxBool isLoading = false.obs;
  RxList<CustomerBalanceModel> customersBalancesList =
      RxList<CustomerBalanceModel>();
  Future<void> getCustomersBalances({
    String pageNo = '-1',
    String pageSize = '0',
  }) async {
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    List<String?>? newDateTo = dateTo.split('T');
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      //?https://mobiletest.itgenesis.app/GetCustBalances?ServiceKey=1357&SalesRepID=2&dateto=30/10/2024&PageNo=-1&PageSize=0
      final url = Uri.parse(
          'https://$apiURL/GetCustBalances?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&dateto=${newDateTo.first}&PageNo=$pageNo&PageSize=$pageSize');
      try {
        isLoading(true);
        customersBalancesList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            if (data['dataCount'] > 0) {
              final List _x = json.decode(data['data']);
              for (final x in _x) {
                if (!customersBalancesList.contains(x)) {
                  customersBalancesList.add(CustomerBalanceModel.fromJson(x));
                }
              }
            }
          }
        } else {
          Logger().e(response.body.toString());
          AppToasts.errorToast('Connection Error'.tr);
        }
        isLoading(false);
      } catch (e) {
        AppToasts.errorToast('Error occurred, contact support'.tr);
        Logger logger = Logger();
        logger.d(e.toString());
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }
  }
}
