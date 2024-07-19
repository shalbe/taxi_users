import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/add_complaint_controller.dart';
import 'package:cabme/themes/button_them.dart';
import 'package:cabme/themes/constant_colors.dart';
import 'package:cabme/themes/text_field_them.dart';
import 'package:cabme/widget/my_separator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddComplaintScreen extends StatelessWidget {
  AddComplaintScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX<AddComplaintController>(
      init: AddComplaintController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.primary,
          appBar: AppBar(
              backgroundColor: ConstantColors.primary,
              elevation: 0,
              centerTitle: true,
              title: Text("Add Complaint".tr,
                  style: const TextStyle(color: Colors.white)),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              )),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 42, bottom: 20),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 65),
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    controller.rideType.value.toString() ==
                                            "ride"
                                        ? "${controller.rideData.value.prenomConducteur} ${controller.rideData.value.nomConducteur}"
                                        : "${controller.parcelData.value.driverName}",
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                              ),
                              if (controller.rideType.value.toString() ==
                                  "ride")
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        controller.rideData.value.numberplate!
                                            .toUpperCase()
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          "${controller.rideData.value.brand!} ${controller.rideData.value.model!}",
                                          style: const TextStyle(
                                              color: Colors.black38,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: MySeparator(color: Colors.grey),
                          ),
                          if (controller.complaintStatus.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Status : '.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    controller.complaintStatus.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ConstantColors.subTitleTextColor,
                                        letterSpacing: 0.8),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              'How is your trip?'.tr,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Your complaint  will help us improve \n driving experience better'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ConstantColors.subTitleTextColor,
                                  letterSpacing: 0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'Complaint for'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ConstantColors.subTitleTextColor,
                                  letterSpacing: 0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              controller.rideType.value.toString() == "ride"
                                  ? "${controller.rideData.value.prenomConducteur.toString()} ${controller.rideData.value.nomConducteur.toString()}"
                                  : "${controller.parcelData.value.driverName}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 20, right: 20),
                                  child: TextFieldThem.boxBuildTextField(
                                    hintText: 'Type title....'.tr,
                                    controller:
                                        controller.complaintTitleController,
                                    textInputType: TextInputType.emailAddress,
                                    contentPadding: EdgeInsets.zero,
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Title is required'.tr;
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 20, right: 20),
                                  child: TextFieldThem.boxBuildTextField(
                                    hintText: 'Type discription....'.tr,
                                    controller: controller
                                        .complaintDiscriptionController,
                                    textInputType: TextInputType.emailAddress,
                                    maxLine: 5,
                                    contentPadding: EdgeInsets.zero,
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Discription is required'.tr;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20, bottom: 20),
                            child: ButtonThem.buildButton(context,
                                btnHeight: 45,
                                title: "Submit complaint".tr,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white, onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, String> bodyParams = {};
                                if (controller.rideType.value.toString() ==
                                    "ride") {
                                  bodyParams = {
                                    'id_user_app': controller
                                        .rideData.value.idUserApp
                                        .toString(),
                                    'id_conducteur': controller
                                        .rideData.value.idConducteur
                                        .toString(),
                                    'user_type': 'customer',
                                    'description': controller
                                        .complaintDiscriptionController.text
                                        .toString(),
                                    'title': controller
                                        .complaintTitleController.text
                                        .toString(),
                                    'order_id':
                                        controller.rideData.value.id.toString(),
                                  };
                                } else {
                                  bodyParams = {
                                    'id_user_app': controller
                                        .parcelData.value.idUserApp
                                        .toString(),
                                    'id_conducteur': controller
                                        .parcelData.value.idConducteur
                                        .toString(),
                                    'user_type': 'customer',
                                    'description': controller
                                        .complaintDiscriptionController.text
                                        .toString(),
                                    'title': controller
                                        .complaintTitleController.text
                                        .toString(),
                                    'order_id': controller.parcelData.value.id
                                        .toString(),
                                    'ride_type': 'parcel'
                                  };
                                }

                                await controller
                                    .addComplaint(bodyParams)
                                    .then((value) {
                                  if (value != null) {
                                    if (value == true) {
                                      ShowToastDialog.showToast(
                                          "Complaint added successfully!".tr);
                                      Get.back();
                                    } else {
                                      ShowToastDialog.showToast(
                                          "Something went wrong".tr);
                                    }
                                  }
                                });
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: controller.rideType.value.toString() == "ride"
                          ? controller.rideData.value.photoPath.toString()
                          : controller.parcelData.value.driverPhoto.toString(),
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Constant.loader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
