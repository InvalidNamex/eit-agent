import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/reports_controllers/reports_controller.dart';
import '../../models/api/api_invoice_model.dart';
import '../print_screen.dart';

Future<void> printPreview({required int transID, String? customerName}) async {
  final reportsController = Get.find<ReportsController>();
  final homeController = Get.find<HomeController>();
  await reportsController.getInvDetails(
      apiInv: ApiInvoiceModel(transID: transID, sysInvID: 0));
  await printPOpreview(
      poMaster: reportsController.poMaster,
      invoiceItems: reportsController.salesInvDetails,
      salesPODetails: reportsController.salesPODetails,
      vatIncluded: homeController.vatIncluded.value,
      customerName: customerName,
      isPO: true);
}
