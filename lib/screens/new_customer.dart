import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/custom_widgets/custom_appBar.dart';
import 'package:eit/models/api/api_customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:place_picker/place_picker.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../custom_widgets/custom_drawer.dart';
import '../helpers/toast.dart';

class NewCustomer extends GetView<CustomerController> {
  NewCustomer({super.key});
  final GlobalKey<FormState> newCustomerForm = GlobalKey<FormState>();
  TextEditingController custCode = TextEditingController();
  TextEditingController custName = TextEditingController();
  TextEditingController custAddress = TextEditingController();
  TextEditingController custPhone = TextEditingController();
  TextEditingController custTaxNo = TextEditingController();
  var latLng = Rx<LatLng?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(text: 'New Customer'.tr),
      endDrawer: const CustomDrawer(),
      body: Form(
        key: newCustomerForm,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Customer Code'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: custCode,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),

                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.5)), // Change the bor
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(
                            0.5)), // Change the border color when not focused
                  ),
                ),
                // cursorColor: darkColor, // Change the cursor color
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Customer Name'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: custName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'mandatory field'.tr; // Validation message
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),

                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.5)), // Change the bor
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(
                            0.5)), // Change the border color when not focused
                  ),
                ),
                // cursorColor: darkColor, // Change the cursor color
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Address'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: custAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'mandatory field'.tr; // Validation message
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),

                          borderSide: BorderSide(
                              color: Colors.green
                                  .withOpacity(0.5)), // Change the bor
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                              color: Colors.green.withOpacity(
                                  0.5)), // Change the border color when not focused
                        ),
                      ),
                      // cursorColor: darkColor, // Change the cursor color
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        await dotenv.load(fileName: ".env");
                        LocationResult? result =
                            await Get.to(PlacePicker(dotenv.env['MAPAPI']!));
                        latLng.value = result?.latLng;
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => Icon(
                              Icons.location_on_outlined,
                              color: latLng.value == null
                                  ? darkColor
                                  : accentColor,
                            ),
                          ),
                          FittedBox(
                              child: Text(
                            'Location'.tr,
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Phone'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: custPhone,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'mandatory field'.tr; // Validation message
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),

                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.5)), // Change the bor
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(
                            0.5)), // Change the border color when not focused
                  ),
                ),
                // cursorColor: darkColor, // Change the cursor color
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tax Code'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: custTaxNo,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(0.5)), // Change the bor
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.green.withOpacity(
                            0.5)), // Change the border color when not focused
                  ),
                ),
                // cursorColor: darkColor, // Change the cursor color
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                    ),
                  ),
                  onPressed: () async {
                    if (latLng.value != null) {
                      final authController = Get.find<AuthController>();
                      if (newCustomerForm.currentState!.validate()) {
                        ApiCustomerModel customerModel = ApiCustomerModel(
                            custName: custName.text,
                            custCode:
                                custCode.text.isEmpty ? '-999' : custCode.text,
                            address: custAddress.text,
                            phoneNo: custPhone.text,
                            taxNo:
                                custTaxNo.text.isEmpty ? '0' : custTaxNo.text,
                            latitude: latLng.value!.latitude.toString(),
                            longitude: latLng.value!.longitude.toString(),
                            salesRepId: authController.userModel!.saleRepID);
                        await controller.saveCustomer(customerModel);
                      }
                    } else {
                      AppToasts.errorToast('Unrecognized Location'.tr);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Save'.tr,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
