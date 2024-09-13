import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:eit/models/item_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/api/api_stock_item_model.dart';

class StockController extends GetxController {
  //!GetItemsStock?ServiceKey=1357&StoreID=1&ItemID=16
  RxList<StockItemModel> stockItemList = RxList<StockItemModel>();
  RxList<StockItemModel> filteredStockItemList = RxList<StockItemModel>();
  RxList<ItemModel> itemsByTreeList = RxList<ItemModel>();

  Rx<StockItemModel> stockItemDropDown =
      StockItemModel(itemName: 'Choose Item'.tr).obs;
  final authController = Get.find<AuthController>();
  Future<void> getItemsStock() async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    final url = Uri.parse(
        'https://$apiURL/GetItemsStock?ServiceKey=$secretKey&StoreID=${authController.userModel!.storeID}');

    try {
      stockItemList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success'] && data['data'] != 'Empty Data.') {
          final List _x = json.decode(data['data']);
          for (final i in _x) {
            if (!stockItemList.contains(i)) {
              stockItemList.add(StockItemModel.fromJson(i));
            }
          }
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
      }
    } catch (e) {
      AppToasts.errorToast('Error occurred, please contact support'.tr);
      var logger = Logger();
      logger.d(e.toString());
    }
  }

  Future<void> getItemsByTreeList({required int treeID}) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    // https://Mobiletest.itgenesis.app/GetItemList?ServiceKey=1357&CustCode=304
    final url = Uri.parse('https://$apiURL/GetItemList?ServiceKey=$secretKey');
    try {
      itemsByTreeList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          if (data['dataCount'] > 0) {
            final List _x = json.decode(data['data']);
            for (final i in _x) {
              if (!itemsByTreeList.contains(i)) {
                ItemModel _item = (ItemModel.fromJson(i));
                if (_item.itemClassID == treeID) {
                  itemsByTreeList.add(_item);
                }
              }
            }
          }
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
      }
    } catch (e) {
      AppToasts.errorToast('Error occurred, please contact support'.tr);
      var logger = Logger();
      logger.e(e.toString());
    }
  }

  @override
  void onInit() async {
    await getItemsStock();
    super.onInit();
  }
}
