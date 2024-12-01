import 'dart:convert';

import 'package:eit/map_hierarchy/location_service.dart';
import 'package:eit/models/customer_model.dart';
import 'package:eit/services/add_visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

import '/helpers/toast.dart';
import '/models/user_model.dart';
import '../custom_widgets/date_filters.dart';
import '../models/api/api_receipt_model.dart';
import '../models/api/save_api_receipt_model.dart';
import '../screens/print_receipt.dart';
import 'auth_controller.dart';

class ReceiptController extends GetxController {
  final authController = Get.find<AuthController>();
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;
  RxBool isSubmitting = false.obs;
  final receiptFormKey = GlobalKey<FormState>();
  TextEditingController receiptAmount = TextEditingController();
  TextEditingController notes = TextEditingController();
  Rx<CustomerModel> newReceiptDropDownCustomer =
      CustomerModel(custName: 'Choose Customer'.tr).obs;
  RxBool isLoading = false.obs;
  RxList<ApiReceiptModel> receiptModelList = RxList<ApiReceiptModel>();

  Future<void> getReceiptVouchers({
    String pageNo = '-1',
    String pageSize = '1',
  }) async {
    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    List<String?>? newDateFrom = dateFrom.split('T');
    List<String?>? newDateTo = dateTo.split('T');
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      final url = Uri.parse(
          'https://$apiURL/GetPaymentList?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&datefrom=${newDateFrom[0]}&dateto=${newDateTo[0]}&PageNo=$pageNo&PageSize=$pageSize');
      try {
        isLoading(true);
        List<ApiReceiptModel> unfilteredList = [];
        receiptModelList.clear();
        unfilteredList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            if (data['data'] != 'Empty Data.') {
              final List _x = json.decode(data['data']);
              for (final x in _x) {
                if (!unfilteredList.contains(x)) {
                  unfilteredList.add(ApiReceiptModel.fromJson(x));
                }
              }
              if (unfilteredList.isNotEmpty) {
                for (ApiReceiptModel x in unfilteredList) {
                  receiptModelList.add(x);
                }
              }
            }
          } else {
            Logger().i('getReceiptVouchers, failed');
          }
        } else {
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

  Future<void> saveReceipt({required int planID}) async {
    LocationData? locationData = await LocationService().getLocationData();
    UserModel? user = authController.userModel;
    String date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    SaveReceiptModel saveReceiptModel = SaveReceiptModel(
      payDate: date,
      custId: newReceiptDropDownCustomer.value.id!,
      salesRepId: user!.saleRepID,
      payNote: notes.text,
      latitude: locationData?.latitude.toString(),
      longitude: locationData?.longitude.toString(),
      amount: double.tryParse(receiptAmount.text) ?? 0,
    );
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    final queryString =
        Uri.encodeComponent(jsonEncode(saveReceiptModel.toJson()));
    //!https://Mobiletest.itgenesis.app/SavePayTrans?ServiceKey=1357&PayInfo={"PayDate":"01/01/2022","CustID":304,"SalesRepID":2,"PayNote":"Noooootes xx","Latitude":"24.655305","Longitude":"46.707436","Amount":1000.5}
    final url = Uri.parse(
        'https://$apiURL/SavePayTrans?ServiceKey=$secretKey&PayInfo=$queryString');
    try {
      isLoading(true);
      if (isSubmitting.value) return;
      isSubmitting.value = true;
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          Get.offAllNamed('/index-screen');
          AddVisitService addVisitService = Get.find<AddVisitService>();
          await addVisitService.saveVisit(
            custID: saveReceiptModel.custId!,
            visitType: 2,
            note: saveReceiptModel.payNote ?? 'سند قبض',
            planID: planID,
          );
          final String dataString = '{${data['data']}}';
          final decodedData = json.decode(dataString);
          int receiptCode = decodedData['TransID'];
          await getReceiptVouchers();
          Get.offAllNamed('/index-screen');
          await generateReceiptPdf(
              agent: user.userName ?? 'agent'.tr,
              customerName:
                  newReceiptDropDownCustomer.value.custName ?? 'Customer'.tr,
              amount: saveReceiptModel.amount ?? 0);
          AppToasts.successToast(
              '${'Saved Successfully'.tr}\n ${'Receipt Code: '.tr}${receiptCode.toString()}');
        } else {
          AppToasts.errorToast('Error: ${data['Message']}');
        }
      } else {
        final data = json.decode(response.body);
        AppToasts.errorToast('Error: ${data['Message']}');
      }
    } catch (e) {
      AppToasts.errorToast('Error occurred, contact support'.tr);
      Logger logger = Logger();
      logger.d(e);
    } finally {
      isSubmitting.value = false;
      isLoading(false);
    }
  }

  @override
  void onReady() async {
    await getReceiptVouchers();
    super.onReady();
  }

  @override
  void onInit() {
    dateFromFilter.value = firstOfJanuaryLastYear();
    super.onInit();
  }
}
