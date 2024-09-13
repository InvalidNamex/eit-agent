import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../helpers/toast.dart';
import '../../models/cash_flow_model.dart';
import '../../models/user_model.dart';

class CashFlowController extends GetxController {
  final authController = Get.find<AuthController>();
  RxList<CashFlowModel> cashFlowList = RxList<CashFlowModel>();
  var isLoading = false.obs;
  var pageNo = 1.obs;
  var pageSize = 10.obs;
  var hasMoreData = true.obs;
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;

  Future<void> getCashFlow({bool isLoadMore = false}) async {
    if (isLoading.value) return;

    isLoading(true);

    if (!isLoadMore) {
      pageNo.value = 1;
      cashFlowList.clear();
    }

    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;

    if (user != null) {
      final url = Uri.parse(
          'https://$apiURL/GetAccMove?ServiceKey=$secretKey&CashAccID=${user.cashAccID}&datefrom=$dateFrom&dateto=$dateTo&PageNo=${pageNo.value}&PageSize=${pageSize.value}');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            if (data['dataCount'] > 0) {
              final List _x = json.decode(data['data']);
              if (_x.isNotEmpty) {
                for (final x in _x) {
                  cashFlowList.add(CashFlowModel.fromJson(x));
                }
                pageNo.value++;
              } else {
                hasMoreData(false);
              }
            }
          }
        } else {
          AppToasts.errorToast('Connection Error'.tr);
        }
      } catch (e) {
        AppToasts.errorToast('Error occurred, contact support'.tr);
        Logger logger = Logger();
        logger.d(e.toString());
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }

    isLoading(false);
  }
}
