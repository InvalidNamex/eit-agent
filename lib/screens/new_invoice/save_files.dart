import 'package:eit/screens/new_invoice/save_file.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../helpers/loader.dart';
import '../../helpers/location_comparison.dart';
import '../../helpers/toast.dart';
import '../../map_hierarchy/location_service.dart';
import '../../models/api/save_invoice/api_save_invoice_model.dart';

Future saveInvoice(
    {required int payType,
    required bool isPrint,
    required SalesController controller,
    int? custID}) async {
  // try {
  Loading.load();
  if (controller.isSubmitting.value) return;
  controller.isSubmitting.value = true;
  LocationData? locationData = await LocationService().getLocationData();
  controller.longitude(locationData?.longitude);
  controller.latitude(locationData?.latitude);
  Loading.dispose();
  if ((controller.latitude.value != 0.0) ||
      (controller.longitude.value != 0.0)) {
    final authController = Get.find<AuthController>();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    ApiSaveInvoiceModel apiInvoiceModel = ApiSaveInvoiceModel(
        invDate: formattedDate,
        custID: custID ?? controller.customerModel!.id!,
        salesRepID: authController.userModel!.saleRepID!,
        payType: payType,
        invNote: controller.invoiceNote.text,
        latitude: controller.latitude.toString(),
        longitude: controller.longitude.toString(),
        products: controller.apiInvoiceItemList
            .map((item) => item.toJson()) // Ensure correct conversion to JSON
            .toList());
    if (controller.invoiceItemsList.isNotEmpty) {
      if (await isWithinDistance(
          gpsLocation: controller.customerModel!.gpsLocation!)) {
        final homeController = Get.find<HomeController>();
        if (homeController.enableCustomerLimit()) {
          if (payType == 1) {
            if (controller.calculateCustLimit(
                custSign: controller.customerModel!.custCode!)) {
              await saveButtonFunctionality(
                  controller: controller,
                  isPrint: isPrint,
                  apiInvoiceModel: apiInvoiceModel,
                  planID: controller.customerModel?.planID);
            } else {
              AppToasts.errorToast('Invoice total exceeds customer limits'.tr);
            }
          } else {
            await saveButtonFunctionality(
                controller: controller,
                isPrint: isPrint,
                apiInvoiceModel: apiInvoiceModel,
                planID: controller.customerModel?.planID);
          }
        } else {
          await saveButtonFunctionality(
              controller: controller,
              isPrint: isPrint,
              apiInvoiceModel: apiInvoiceModel,
              planID: controller.customerModel?.planID);
        }
      }
    } else {
      AppToasts.errorToast('Please add items before saving'.tr);
    }
  } else {
    AppToasts.errorToast('Unrecognized Location'.tr);
  }
  // } catch (e) {
  //   if (controller.customerModel?.custName == null) {
  //     AppToasts.errorToast('Please choose a customer before proceeding'.tr);
  //   } else if (controller.invoiceItemsList.isEmpty) {
  //     AppToasts.errorToast('Please add items before saving'.tr);
  //   } else {
  //     AppToasts.errorToast('error occurred, please contact support'.tr);
  //   }
  //   Logger().e(e);
  // } finally {
  //   controller.isSubmitting.value = false;
  // }
}
