import 'package:eit/services/add_visit_service.dart';
import 'package:eit/services/items_trees_service.dart';
import 'package:eit/services/qr_auth_service.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/customer_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/receipt_controller.dart';
import 'controllers/reports_controllers/cashflow_controller.dart';
import 'controllers/reports_controllers/customer_reports_controller.dart';
import 'controllers/reports_controllers/reports_controller.dart';
import 'controllers/sales_controller.dart';
import 'controllers/stock_controller.dart';
import 'controllers/visits_controller.dart';
import 'helpers/connectivity_controller.dart';
import 'localization_hierarchy/localization_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(AddVisitService());
    Get.put(ItemsTreesService());
    Get.put(SalesController());
    Get.put(CustomerController());
    Get.put(ReceiptController());
    Get.put(StockController());
    Get.put(ReportsController());
    Get.lazyPut(() => VisitsController());
    Get.put(CashFlowController());
    Get.put(CustomerReportsController());
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LocalizationController());
    Get.put(AuthController());
    Get.put(QrAuthService());
    Get.put(ConnectivityController());
  }
}
