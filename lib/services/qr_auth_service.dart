import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class QrAuthService extends GetxService {
  Future<void> scanQRCode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        final Map<String, dynamic> loginData;
        try {
          loginData = json.decode(result.rawContent);
        } catch (e) {
          AppToasts.errorToast('Invalid QR code format.');
          Logger().e('Error decoding QR code data: $e');
          return; // Exit early if the QR code data is invalid
        }

        // Extract values from the JSON data
        String username = loginData['username'] ?? '';
        String password = loginData['password'] ?? '';
        String apiURL = loginData['apiURL'] ?? '';
        String secretKey = loginData['secretKey'] ?? '';
        bool isReceiptVoucherAfterSales =
            loginData['isReceiptVoucherAfterSales'];
        if (apiURL.isEmpty || secretKey.isEmpty) {
          AppToasts.errorToast('Incomplete QR code data.');
          return; // Exit early if any data is missing
        }
        // Use the parsed data for login
        try {
          final AuthController authController = Get.find<AuthController>();
          await authController.setApiConnectionToPrefs(
              apiURL: apiURL,
              secretKey: secretKey,
              isReceiptVoucherAfterSales: isReceiptVoucherAfterSales);
          await authController.fetchUserData(
            apiURL: apiURL,
            username: username,
            password: password,
            secretKey: secretKey,
          );
        } catch (e) {
          AppToasts.errorToast('Error during login process.');
          Logger().e('Login error: $e');
        }
      } else {
        AppToasts.errorToast('No QR code data found.');
      }
    } catch (e) {
      AppToasts.errorToast('Error scanning QR code.');
      Logger().e('QR scan error: $e');
    }
  }
}
