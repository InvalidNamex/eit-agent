import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/models/customer_model.dart';
import 'package:eit/models/user_model.dart';
import 'package:eit/services/add_visit_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/toast.dart';
import '../models/api/api_invoice_item.dart';
import '../models/api/api_invoice_model.dart';
import '../models/api/save_invoice/api_save_invoice_model.dart';
import '../models/customer_limit_model.dart';
import '../models/invoice_item_model.dart';
import '../models/item_model.dart';

class SalesController extends GetxController {
  int transID = 0;
  RxInt payType = 1.obs; //0 = cash ,1 = credit
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;
  final itemQuantityFormKey = GlobalKey<FormState>();
  TextEditingController invoiceNote = TextEditingController();
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  TextEditingController mainQty = TextEditingController();
  TextEditingController subQty = TextEditingController();
  TextEditingController smallQty = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  //todo: غير دي عشان تعمل سند قبض بعد الفاتورة
  RxBool isReceiptVoucherAfterSales = false.obs;
  RxString customerNameFilter = ''.obs;
  RxList<ApiInvoiceModel> apiInvList = RxList<ApiInvoiceModel>();
  RxList<ApiInvoiceModel> apiRetInvList = RxList<ApiInvoiceModel>();
  RxList<InvoiceItemModel> invoiceItemsList = RxList<InvoiceItemModel>();
  RxList<CustomerLimitModel> customersLimitsList = RxList<CustomerLimitModel>();
  Rx<CustomerModel> salesScreenDropDownCustomer =
      CustomerModel(custName: 'Choose Customer'.tr).obs;
  Rx<CustomerModel> addItemDropDownCustomer =
      CustomerModel(custName: 'Choose Customer'.tr).obs;
  RxBool isVisit = false.obs;
  RxBool isFirstItemTaxed = false.obs;
  double get totalTax =>
      invoiceItemsList.fold(0, (sum, item) => sum + (item.tax ?? 0));
  double get totalDiscount =>
      invoiceItemsList.fold(0, (sum, item) => sum + (item.discount ?? 0));
  double get grandTotal =>
      invoiceItemsList.fold(0, (sum, item) => sum + (item.total ?? 0));
  void resetValues() {
    invoiceItemsList.forEach((item) {
      item.tax = 0;
      item.discount = 0;
      item.total = 0;
    });
  }

  RxList<ApiInvoiceItem> apiInvoiceItemList = RxList<ApiInvoiceItem>();
  RxList<ItemModel> customerItemsList = RxList<ItemModel>();
  RxList<ItemModel> customerTreeItemsList = RxList<ItemModel>();
  RxBool isCustomerChosen = false.obs;
  final priceFrom = TextEditingController(text: 0.toString());
  final priceTo = TextEditingController(text: 1000000.toString());
  final GlobalKey<FormState> filterFormKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  CustomerModel? customerModel;

  Future<bool> readIsReceiptVoucherAfterSalesFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isReceiptVoucherAfterSales =
        prefs.getBool('isReceiptVoucherAfterSales');
    if (isReceiptVoucherAfterSales != null) {
      return isReceiptVoucherAfterSales;
    }
    return false;
  }

  Future<void> getFilteredInvoices({
    String pageNo = '-1',
    String pageSize = '1',
    double amountFrom = 0,
    double amountTo = 1000000,
  }) async {
    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      final url = Uri.parse(
          //https://Mobiletest.itgenesis.app/GetInvList?ServiceKey=1357&SalesRepID=2&datefrom=01/01/2022&dateto=23/12/2023&PageNo=1&PageSize=1
          'https://$apiURL/GetInvList?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&datefrom=$dateFrom&dateto=$dateTo&PageNo=$pageNo&PageSize=$pageSize');

      try {
        isLoading(true);
        List<ApiInvoiceModel> unfilteredList = [];
        apiInvList.clear();
        unfilteredList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success'] && data['dataCount'] > 0) {
            final List _x = json.decode(data['data']);
            for (final x in _x) {
              if (!unfilteredList.contains(x)) {
                unfilteredList.add(ApiInvoiceModel.fromJson(x));
              }
            }
            if (unfilteredList.isNotEmpty) {
              for (ApiInvoiceModel x in unfilteredList) {
                if (x.invAmount! < amountTo && x.invAmount! >= amountFrom) {
                  if (customerNameFilter.value == '') {
                    apiInvList.add(x);
                  } else if (customerNameFilter.value != '' &&
                      customerNameFilter.value == x.custName) {
                    apiInvList.add(x);
                  }
                }
              }
            }
          } else if (data['Success'] &&
              data['dataCount'] == 0 &&
              customerModel?.id != null) {
            AppToasts.errorToast(
                'Please filter by date to display transactions'.tr);
          }
        } else {
          AppToasts.errorToast('Connection Error'.tr);
        }
        isLoading(false);
      } catch (e) {
        Logger().e('Empty Data');
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }
  }

  Future<void> getFilteredRetInvoices({
    String pageNo = '-1',
    String pageSize = '1',
    double amountFrom = 0,
    double amountTo = 1000000,
  }) async {
    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      final url = Uri.parse(
          //https://Mobiletest.itgenesis.app/GetInvList?ServiceKey=1357&SalesRepID=2&datefrom=01/01/2022&dateto=23/12/2023&PageNo=1&PageSize=1
          'https://$apiURL/GetRetInvList?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&datefrom=$dateFrom&dateto=$dateTo&PageNo=$pageNo&PageSize=$pageSize');

      try {
        isLoading(true);
        List<ApiInvoiceModel> unfilteredList = [];
        apiRetInvList.clear();
        unfilteredList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success'] && data['dataCount'] > 0) {
            final List _x = json.decode(data['data']);
            for (final x in _x) {
              if (!unfilteredList.contains(x)) {
                unfilteredList.add(ApiInvoiceModel.fromJson(x));
              }
            }
            if (unfilteredList.isNotEmpty) {
              for (ApiInvoiceModel x in unfilteredList) {
                if (x.invAmount! < amountTo && x.invAmount! >= amountFrom) {
                  if (customerNameFilter.value == '') {
                    apiRetInvList.add(x);
                  } else if (customerNameFilter.value != '' &&
                      customerNameFilter.value == x.custName) {
                    apiRetInvList.add(x);
                  }
                }
              }
            }
          } else if (data['Success'] &&
              data['dataCount'] == 0 &&
              customerModel?.id != null) {
            AppToasts.errorToast(
                'Please filter by date to display transactions'.tr);
          }
        } else {
          AppToasts.errorToast('Connection Error'.tr);
        }
        isLoading(false);
      } catch (e) {
        Logger().e('Empty Data');
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }
  }

  Future<void> getFilteredItemsByCustomer({required String customerID}) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    // https://Mobiletest.itgenesis.app/GetItemList?ServiceKey=1357&CustCode=304
    final url = Uri.parse(
        'https://$apiURL/GetItemList?ServiceKey=$secretKey&CustCode=$customerID');
    // try {
    isLoading(true);
    customerItemsList.clear();
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Success']) {
        if (data['dataCount'] > 0) {
          final List _x = json.decode(data['data']);
          for (final i in _x) {
            if (!customerItemsList.contains(i)) {
              ItemModel _item = (ItemModel.fromJson(i));
              customerItemsList.add(_item);
            }
          }
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
      }
    }
    isLoading(false);
    // } catch (e) {
    //   AppToasts.errorToast('Error occurred, please contact support'.tr);
    //   isLoading(true);
    //   var logger = Logger();
    //   logger.e(e.toString());
    // }
  }

  String formatDate(String? dateStr) {
    try {
      DateTime parsedDate = DateTime.parse(dateStr!);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      AppToasts.errorToast('Date Error'.tr);
      return '';
    }
  }

  Future<int> postInvoice(
      {required ApiSaveInvoiceModel invoice, int? planID}) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    final url = Uri.parse('https://$apiURL/SaveInvTrans?ServiceKey=$secretKey');
    try {
      isLoading(true);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(invoice.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final String dataString = '{${data['data']}}';
          final decodedData = json.decode(dataString);
          transID = decodedData['TransID'];
          AppToasts.successToast(
              '${'Saved Successfully'.tr}\n ${transID.toString()}');
          AddVisitService addVisitService = Get.find<AddVisitService>();
          addVisitService.saveVisit(
            custID: invoice.custID,
            visitType: 1,
            note: invoice.invNote,
            planID: planID ?? 0,
          );
          await getFilteredInvoices();
          isSubmitting(false);
          return transID;
        } else {
          AppToasts.errorToast('Error: ${data['Message']}');
          Logger().e(response.statusCode);
          Logger().e(response.body);
          isSubmitting(false);
          return 0;
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
        Logger().e(response.statusCode);
        Logger().e(response.body);
        isSubmitting(false);
        return 0;
      }
    } on TimeoutException catch (_) {
      AppToasts.errorToast('Request timed out. Please try again.'.tr);
      Logger().e('Request timed out');
      isSubmitting(false);
      return 0;
    } on SocketException catch (e) {
      AppToasts.errorToast('Request timed out. Please try again.'.tr);
      Logger().e('SocketException: $e');
      isSubmitting(false);
      return 0;
    } catch (e) {
      AppToasts.errorToast('Error occurred, contact support'.tr);
      Logger logger = Logger();
      logger.e(e.toString());
      isSubmitting(false);
      return 0;
    } finally {
      isSubmitting(false);
      isLoading(false);
    }
  }

  Future<int> postRetInvoice(
      {required ApiSaveInvoiceModel invoice, int? planID}) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    final url =
        Uri.parse('https://$apiURL/SaveRetInvTrans?ServiceKey=$secretKey');
    try {
      isLoading(true);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(invoice.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final String dataString = '{${data['data']}}';
          final decodedData = json.decode(dataString);
          transID = decodedData['TransID'];
          AppToasts.successToast(
              '${'Saved Successfully'.tr}\n ${transID.toString()}');
          AddVisitService addVisitService = Get.find<AddVisitService>();
          addVisitService.saveVisit(
            custID: invoice.custID,
            visitType: 1,
            note: invoice.invNote,
            planID: planID ?? 0,
          );
          await getFilteredInvoices();
          isSubmitting(false);
          return transID;
        } else {
          AppToasts.errorToast('Error: ${data['Message']}');
          Logger().e(response.statusCode);
          Logger().e(response.body);
          isSubmitting(false);
          return 0;
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
        Logger().e(response.statusCode);
        Logger().e(response.body);
        isSubmitting(false);
        return 0;
      }
    } on TimeoutException catch (_) {
      AppToasts.errorToast('Request timed out. Please try again.'.tr);
      Logger().e('Request timed out');
      isSubmitting(false);
      return 0;
    } on SocketException catch (e) {
      AppToasts.errorToast('Request timed out. Please try again.'.tr);
      Logger().e('SocketException: $e');
      isSubmitting(false);
      return 0;
    } catch (e) {
      AppToasts.errorToast('Error occurred, contact support'.tr);
      Logger logger = Logger();
      logger.e(e.toString());
      isSubmitting(false);
      return 0;
    } finally {
      isSubmitting(false);
      isLoading(false);
    }
  }

  Future<void> customerLimitCheck() async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    // https://raslanmob.itgenesis.app/GetCustBalances?ServiceKey=1357&SalesRepID=1&dateto=04/09/2024&pageNo=1
    final url = Uri.parse(
        'https://$apiURL/GetCustBalances?ServiceKey=$secretKey&SalesRepID=${authController.userModel!.saleRepID}&dateto=$dateTo&pageNo=-1');
    try {
      isLoading(true);
      customersLimitsList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          if (data['dataCount'] > 0) {
            final List _x = json.decode(data['data']);
            for (final i in _x) {
              if (!customersLimitsList.contains(i)) {
                customersLimitsList.add(CustomerLimitModel.fromJson(i));
              }
            }
          }
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
      }
      isLoading(false);
    } catch (e) {
      AppToasts.errorToast('Error occurred, please contact support'.tr);
      isLoading(true);
      var logger = Logger();
      logger.e(e.toString());
    }
  }

  bool calculateCustLimit({required String custSign}) {
    CustomerLimitModel customer = customersLimitsList
        .where((customer) => customer.custSign == custSign)
        .first;
    double allowedLimit = customer.crLimit - customer.custBalance;
    if (allowedLimit >= grandTotal) {
      return true;
    } else {
      return false;
    }
  }

  void filterItemsByTreeList(int id) {
    // If id == 0, display all items
    if (id == 0) {
      // Use a copy of customerItemsList, not the original list reference
      customerTreeItemsList.value = List<ItemModel>.from(customerItemsList);
    } else {
      // Filter items and assign the result to customerTreeItemsList
      final filteredItems =
          customerItemsList.where((item) => item.itemClassID == id).toList();
      if (filteredItems.isNotEmpty) {
        customerTreeItemsList.value = filteredItems;
      } else {
        customerTreeItemsList.clear();
      }
    }
  }

  @override
  void onReady() async {
    await getFilteredInvoices();
    await customerLimitCheck();
    isReceiptVoucherAfterSales.value =
        await readIsReceiptVoucherAfterSalesFromPrefs();
    super.onReady();
  }
}
