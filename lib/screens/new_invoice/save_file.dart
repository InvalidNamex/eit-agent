import 'package:eit/screens/new_invoice/print_preview.dart';
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
    await controller.postInvoice(invoice: apiInvoiceModel, planID: planID);
    isPrint
        ? await printPreview(transID: controller.transID)
        : Get.toNamed('/new-receipt', arguments: {
            'custName': controller.customerModel?.custName,
            'defaultAmount':
                double.parse(controller.grandTotal.toStringAsFixed(2)),
            'planID': planID
          });
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
