import 'package:eit/controllers/receipt_controller.dart';
import 'package:eit/screens/new_invoice/print_preview.dart';
import 'package:eit/screens/new_invoice/receipt_dialog.dart';
import 'package:get/get.dart';

import '../../controllers/sales_controller.dart';
import '../../models/api/save_invoice/api_save_invoice_model.dart';
import '../../models/customer_model.dart';

Future<void> saveButtonFunctionality(
    {required SalesController controller,
    required ApiSaveInvoiceModel apiInvoiceModel,
    required bool isPrint,
    int? planID = 0}) async {
  if (controller.payType.value == 1) {
    await controller.postInvoice(invoice: apiInvoiceModel, planID: planID);
    isPrint
        ? await printPreview(transID: controller.transID)
        : Get.offNamed('/index-screen');
  } else {
    if (controller.isReceiptVoucherAfterSales.value) {
      await controller.postInvoice(invoice: apiInvoiceModel, planID: planID);
      final receiptController = Get.find<ReceiptController>();
      receiptController.receiptAmount.text =
          controller.grandTotal.toStringAsFixed(2);
      isPrint
          ? await printPreview(
              transID: controller.transID,
              customerName: controller.customerModel?.custName)
          //todo: receipt voucher after sales
          : Get.defaultDialog(
              title: 'Receipt Voucher'.tr,
              content: ReceiptDialog(
                customerNameArgument: controller.customerModel?.custName,
              ),
            );
    } else {
      await controller.postInvoice(invoice: apiInvoiceModel, planID: planID);
      isPrint
          ? await printPreview(transID: controller.transID)
          : Get.offNamed('/index-screen');
    }
  }
  controller.invoiceItemsList.clear();
  controller.apiInvoiceItemList.clear();
  controller.invoiceNote.clear();
  controller.resetValues();
  controller.payType(1);
  controller.transID = 0;
  controller
      .addItemDropDownCustomer(CustomerModel(custName: 'Choose Customer'.tr));
  controller.isCustomerChosen(false);
}
