import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../helpers/toast.dart';
import '../models/item_tree_model.dart';

class ItemsTreesService extends GetxService {
  final authController = Get.find<AuthController>();
  Rx<ItemTreeModel> treeItemDropDown = ItemTreeModel(name: 'Items Tree'.tr).obs;
  RxList<ItemTreeModel> itemTreeList = RxList<ItemTreeModel>();
  Future<void> getItemsTrees() async {
    RxBool isLoading = false.obs;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    //?https://mobiletest.itgenesis.app/GetItemTreeList?ServiceKey=1357
    try {
      final url =
          Uri.parse('https://$apiURL/GetItemTreeList?ServiceKey=$secretKey');
      isLoading(true);
      itemTreeList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          if (data['data']['dataCount'] > 0) {
            final List _x = json.decode(data['data']['dataStr']);
            for (final x in _x) {
              if (!itemTreeList.contains(x)) {
                itemTreeList.add(ItemTreeModel.fromJson(x));
              }
            }
            itemTreeList.insert(0, ItemTreeModel(id: 0, name: 'Items Tree'.tr));
          }
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
  }

  @override
  void onInit() async {
    await getItemsTrees();
    super.onInit();
  }
}
