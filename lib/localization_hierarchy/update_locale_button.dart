import 'package:eit/localization_hierarchy/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final locales = [
  {'name': 'English', 'locale': const Locale('en', 'US')},
  {'name': 'عربي', 'locale': const Locale('ar', 'EG')},
];
showLocaleDialog() {
  Get.dialog(AlertDialog(
    title: Text(
      'Choose Your Language'.tr,
    ),
    content: SizedBox(
      width: double.maxFinite,
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    locales[index]['name'].toString(),
                  ),
                ),
                onTap: () {
                  updateLocale(locales[index]['locale'] as Locale);
                },
              ),
          separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
          itemCount: 2),
    ),
  ));
}

updateLocale(Locale locale) {
  final localizationController = Get.find<LocalizationController>();
  Get.back();
  Get.updateLocale(locale);
  if (locale == const Locale('ar', 'EG')) {
    localizationController.saveLocale('ar');
    localizationController.textDirection.value = TextDirection.rtl;
  } else {
    localizationController.saveLocale('en');
    localizationController.textDirection.value = TextDirection.ltr;
  }
}

/**
    ----------- Under GetMaterialApp --------------
    locale: Get.deviceLocale,
    Pass this in onPressed to the button used to choose language
    showLocaleDialog(context);
    to translate text append .tr to string
    "button1".tr,
 **/
