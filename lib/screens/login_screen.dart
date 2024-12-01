import 'package:eit/services/qr_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../helpers/toast.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: controller.loginFormKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.jpeg',
                    height: 120,
                    width: 280,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 2,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () async {
                      final qrAuthService = Get.find<QrAuthService>();
                      await qrAuthService.scanQRCode();
                    },
                    icon: const Icon(Icons.qr_code),
                    color: darkColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'mandatory field'.tr; // Validation message
                    }
                    return null; // Return null if the input is valid
                  },
                  decoration: InputDecoration(
                    suffixIcon: const SizedBox(),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: accentColor,
                    ),
                    contentPadding: const EdgeInsets.all(5),
                    labelText: 'username'.tr,
                    labelStyle: const TextStyle(color: darkColor, fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),

                      borderSide: BorderSide(
                          color:
                              Colors.green.withOpacity(0.5)), // Change the bor
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                          color: Colors.green.withOpacity(
                              0.5)), // Change the border color when not focused
                    ),
                  ),
                  // cursorColor: darkColor, // Change the cursor color
                  autofocus: true,
                  textAlign: TextAlign.center,

                  controller: controller.usernameTextController,
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'mandatory field'.tr; // Validation message
                      }
                      return null; // Return null if the input is valid
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline_sharp,
                        color: accentColor,
                      ),
                      suffixIcon: IconButton(
                        icon: controller.passwordVisibility.value
                            ? const Icon(
                                Icons.visibility,
                                color: accentColor,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: darkColor,
                              ),
                        onPressed: () {
                          //toggle visibility
                          controller.passwordVisibility.value =
                              !controller.passwordVisibility.value;
                        },
                      ),
                      contentPadding: const EdgeInsets.all(5),
                      labelText: 'password'.tr,
                      labelStyle:
                          const TextStyle(color: darkColor, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),

                        borderSide: BorderSide(
                            color:
                                accentColor.withOpacity(0.5)), // Change the bor
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),

                        borderSide: BorderSide(
                            color: accentColor.withOpacity(
                                0.5)), // Change the border color when not focused
                      ),
                    ),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    controller: controller.passwordTextController,
                    obscureText: !controller.passwordVisibility.value,
                    obscuringCharacter: '*',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded corners
                        ),
                      ),
                      onPressed: () async {
                        if (controller.loginFormKey.currentState!.validate()) {
                          String _userName =
                              controller.usernameTextController.text;
                          String _password =
                              controller.passwordTextController.text;
                          Map serverCredentials =
                              await controller.readApiConnectionFromPrefs();
                          try {
                            controller.loginButtonPressed(true);
                            await controller.fetchUserData(
                              apiURL: serverCredentials.keys.first,
                              secretKey: serverCredentials.values.first,
                              username: _userName.trim(),
                              password: _password.trim(),
                            );
                            controller.usernameTextController.clear();
                            controller.passwordTextController.clear();
                            controller.apiURLTextController.clear();
                            controller.secretKeyTextController.clear();
                          } catch (e) {
                            AppToasts.errorToast(
                                'No host was found or network error'.tr);
                            Logger logger = Logger();
                            logger.d(e);
                          }
                        }
                      },
                      child: controller.loginButtonPressed.value
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          : Text(
                              'Sign In'.tr,
                            ),
                    ),
                  ),
                ),
                Text(
                  "Need to configure your connection?".tr,
                  style: const TextStyle(color: darkColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () async {
                    await serverConfig(controller);
                  },
                  child: Text(
                    "App Configuration".tr,
                    style: const TextStyle(color: accentColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> serverConfig(AuthController controller) async {
  Map _x = await controller.readApiConnectionFromPrefs();
  if (_x != {'': ''}) {
    controller.apiURLTextController.text = _x.keys.first;
    controller.secretKeyTextController.text = _x.values.first;
  }
  Get.defaultDialog(
      title: 'Edit App Connection Settings'.tr,
      content: Form(
        key: controller.serverFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: controller.apiURLTextController,
              decoration: InputDecoration(labelText: 'API ADDRESS'.tr),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'mandatory field'.tr; // Validation message
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: '*',
              controller: controller.secretKeyTextController,
              decoration: InputDecoration(labelText: 'Service Key'.tr),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'mandatory field'.tr; // Validation message
                }
                return null; // Return null if the input is valid
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Rounded corners
                  ),
                ),
                onPressed: () async {
                  if (controller.serverFormKey.currentState!.validate()) {
                    String _secretKey = controller.secretKeyTextController.text;
                    String _apiURL = controller.apiURLTextController.text;
                    await controller.setApiConnectionToPrefs(
                        apiURL: _apiURL.trim(), secretKey: _secretKey.trim());
                  }
                  Get.back();
                },
                child: Text(
                  'Save'.tr,
                ),
              ),
            ),
          ],
        ),
      ));
}
