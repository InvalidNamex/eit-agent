import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/toast.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxBool isPayTypeCash = false.obs;
  RxBool vatIncluded = false.obs;
  RxBool enableCustomerLimit = false.obs;
  RxBool addTaxableAndNonTaxableProductsInSales = false.obs;
  RxBool followingUpInvoicesPayment = false.obs;
  RxBool transOnlyInLocation = false.obs;
  List<Map<String, String>> homeElements = [];

  buildHomeTiles({required bool isVisits}) {
    homeElements = [
      {'Sales': 'assets/images/colored_sells_card.png'},
      {'Customers': 'assets/images/colored_customers_card.png'},
      {'Stock': 'assets/images/colored_store_card.png'},
      {'Receipt Vouchers': 'assets/images/colored_payment_card.png'},
      {'Reports': 'assets/images/colored_reports_card.png'},
      isVisits
          ? {'Visits Plans': 'assets/images/colored_visits_card.png'}
          : {'Sales Returns': 'assets/images/sales-return.png'},
    ];
  }

  void navigateToTab(int index) {
    tabController.animateTo(index);
  }

  Future<void> setPayTypePref(
      {required String boolName, required bool isCash}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(boolName, isCash);
    } catch (e) {
      AppToasts.errorToast(e.toString());
    }
  }

  Future<bool> readPayTypePref({required String boolName}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isCash = prefs.getBool(boolName) ?? false;
      return isCash;
    } catch (e) {
      AppToasts.errorToast('Unknown Server'.tr);
      Logger().e(e.toString());
      return false;
    }
  }

  @override
  void onReady() async {
    isPayTypeCash(await readPayTypePref(boolName: 'isCash'));
    vatIncluded(await readPayTypePref(boolName: 'vatIncluded'));
    enableCustomerLimit(await readPayTypePref(boolName: 'enableCustomerLimit'));
    addTaxableAndNonTaxableProductsInSales(await readPayTypePref(
        boolName: 'addTaxableAndNonTaxableProductsInSales'));
    followingUpInvoicesPayment(
        await readPayTypePref(boolName: 'followingUpInvoicesPayment'));
    super.onReady();
  }

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }
}
