import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme/constant/const.dart';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/CoupanCodeModel.dart';
import 'package:cabme/model/add_amount_model.dart';
import 'package:cabme/model/first_token.dart';
import 'package:cabme/model/get_wallet.dart';
import 'package:cabme/model/order_id_model.dart';
import 'package:cabme/model/parcel_details_model.dart';
import 'package:cabme/model/parcel_model.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/model/tax_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/parcel_service_screen/visascreen.dart';
import 'package:cabme/page/wallet/wallet_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/share/dio_helper.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ParcelPaymentController extends GetxController {
  var paymentSettingModel = PaymentSettingModel().obs;
  var walletAmount = "0.0".obs;

  TextEditingController couponCodeController = TextEditingController();
  TextEditingController tripAmountTextFieldController = TextEditingController();

  RxBool cash = false.obs;
  RxBool wallet = false.obs;
  RxBool stripe = false.obs;
  RxBool razorPay = false.obs;
  RxBool payTm = false.obs;
  RxBool paypal = false.obs;
  RxBool payStack = false.obs;
  RxBool flutterWave = false.obs;
  RxBool mercadoPago = false.obs;
  RxBool payFast = false.obs;
  RxBool paymob = false.obs;

  RxString selectedPromoCode = "".obs;
  RxString selectedPromoValue = "".obs;

  @override
  void onInit() {
    getArgument();
    getCoupanCodeData();
    getUsrData();
    paymentSettingModel.value = Constant.getPaymentSetting();

    super.onInit();
  }

  RxDouble subTotalAmount = 0.0.obs;
  RxDouble tipAmount = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble adminCommission = 0.0.obs;

  var data = ParcelData().obs;
  var coupanCodeList = <CoupanCodeData>[].obs;

  Future<dynamic> getCoupanCodeData() async {
    try {
      final response = await http.get(
          Uri.parse("${API.discountList}?ride_type=parcel"),
          headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        CoupanCodeModel model = CoupanCodeModel.fromJson(responseBody);
        coupanCodeList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        coupanCodeList.clear();
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  getArgument() async {
    subTotalAmount.value = 0.0;
    tipAmount.value = 0.0;
    discountAmount.value = 0.0;
    taxAmount.value = 0.0;
    adminCommission.value = 0.0;
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      data.value = argumentData["parcelData"];
      selectedRadioTile.value = data.value.libelle.toString();
      subTotalAmount.value = double.parse(data.value.amount.toString());
      // taxAmount.value = double.parse(Constant.taxValue ?? "0.0");

      if (selectedRadioTile.value == "Wallet") {
        wallet.value = true;
      } else if (selectedRadioTile.value == "Cash") {
        cash.value = true;
      } else if (selectedRadioTile.value == "Stripe") {
        stripe.value = true;
      } else if (selectedRadioTile.value == "PayStack") {
        payStack.value = true;
      } else if (selectedRadioTile.value == "FlutterWave") {
        flutterWave.value = true;
      } else if (selectedRadioTile.value == "RazorPay") {
        razorPay.value = true;
      } else if (selectedRadioTile.value == "PayFast") {
        payFast.value = true;
      } else if (selectedRadioTile.value == "PayTm") {
        payTm.value = true;
      } else if (selectedRadioTile.value == "MercadoPago") {
        mercadoPago.value = true;
      } else if (selectedRadioTile.value == "PayPal") {
        paypal.value = true;
      }
    }
    getAmount();
    if (data.value.paymentStatus == "yes") {
      getParcelDetailsData(data.value.id.toString());
    } else {
      for (var i = 0; i < Constant.taxList.length; i++) {
        if (Constant.taxList[i].statut == 'yes') {
          if (Constant.taxList[i].type == "Fixed") {
            taxAmount.value +=
                double.parse(Constant.taxList[i].value.toString());
          } else {
            taxAmount.value += ((subTotalAmount.value - discountAmount.value) *
                    double.parse(Constant.taxList[i].value!.toString())) /
                100;
          }
        }
      }
    }
    update();
  }

  Future<dynamic> getAmount() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app"),
          headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        walletAmount.value = responseBody['data']['amount'].toString();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getParcelDetailsData(String id) async {
    try {
      final response = await http.get(
          Uri.parse("${API.getParcelDetails}?parcel_id=$id"),
          headers: API.header);
      log("Parcel Details:  ${response.body}");

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ParcelDetailsModel parcelDetailsModel =
            ParcelDetailsModel.fromJson(responseBody);

        subTotalAmount.value =
            double.parse(parcelDetailsModel.rideDetailsdata!.amount.toString());
        tipAmount.value =
            double.parse(parcelDetailsModel.rideDetailsdata!.tip.toString());
        discountAmount.value = double.parse(
            parcelDetailsModel.rideDetailsdata!.discount.toString());
        for (var i = 0;
            i < parcelDetailsModel.rideDetailsdata!.taxModel!.length;
            i++) {
          if (parcelDetailsModel.rideDetailsdata!.taxModel![i].statut! ==
              'yes') {
            if (parcelDetailsModel.rideDetailsdata!.taxModel![i].type ==
                "Fixed") {
              taxAmount.value += double.parse(parcelDetailsModel
                  .rideDetailsdata!.taxModel![i].value
                  .toString());
            } else {
              taxAmount.value +=
                  ((subTotalAmount.value - discountAmount.value) *
                          double.parse(parcelDetailsModel
                              .rideDetailsdata!.taxModel![i].value!
                              .toString())) /
                      100;
            }
          }
        }
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
    }
    return null;
  }

  double calculateTax({TaxModel? taxModel}) {
    double tax = 0.0;
    if (taxModel != null && taxModel.statut == 'yes') {
      if (taxModel.type.toString() == "Fixed") {
        tax = double.parse(taxModel.value.toString());
      } else {
        tax = ((subTotalAmount.value - discountAmount.value) *
                double.parse(taxModel.value!.toString())) /
            100;
      }
    }
    return tax;
  }

  double getTotalAmount() {
    // if (Constant.taxType == "Percentage") {
    //   taxAmount.value = Constant.taxValue != 0
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(Constant.taxValue.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = Constant.taxValue != 0
    //       ? double.parse(Constant.taxValue.toString())
    //       : 0.0;
    // }
    // if (paymentSettingModel.value.tax!.taxType == "percentage") {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(
    //               paymentSettingModel.value.tax!.taxAmount.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? double.parse(paymentSettingModel.value.tax!.taxAmount.toString())
    //       : 0.0;
    // }

    return (subTotalAmount.value - discountAmount.value) +
        tipAmount.value +
        taxAmount.value;
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  var isLoading = true.obs;
  RxString selectedRadioTile = "".obs;
  RxString paymentMethodId = "".obs;

  Future<dynamic> walletDebitAmountRequest(
      Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("please wait".tr);

      final response = await http.post(Uri.parse(API.parcelPayByWallet),
          headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> cashPaymentRequest(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("please wait".tr);
      final response = await http.post(Uri.parse(API.parcelPayByCase),
          headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseBody['success'].toString().toLowerCase() ==
              "Success".toString().toLowerCase()) {
        // transactionAmountRequest();
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> transactionAmountRequest() async {
    List taxList = [];

    Constant.taxList.forEach((v) {
      taxList.add(v.toJson());
    });
    Map<String, dynamic> bodyParams = {
      'id_parcel': data.value.id.toString(),
      'id_driver': data.value.idConducteur.toString(),
      'amount': subTotalAmount.value.toString(),
      'paymethod': selectedRadioTile.value,
      'discount': discountAmount.value.toString(),
      'tax': taxList,
      'tip': tipAmount.value.toString(),
    };

    try {
      ShowToastDialog.showLoader("please wait".tr);
      final response = await http.post(Uri.parse(API.parcelPaymentRequest),
          headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    ShowToastDialog.closeLoader();
    return null;
  }
 FirstTokenModel? firsttoken;
  OrderIdModel? orderid;

// payment
  Future PaymentWithCard({
    required String firstname,
    required String lastName,
    required String email,
    required String phone,
    required int price,
    String? integrationmethod,
  }) async {
    DioHelper.postData(
        url: authenticationrequesturl,
        data: {"api_key": paymentApiKey}).then((value) {
      paymentFirstToken = value?.data['token'];
      print('first token is :$paymentFirstToken');
      getOrderId(firstname, lastName, email, phone, price, integrationmethod!);

      // emit(PaymentSuccess());
    }).catchError((error) {
      print('error is :' + error.toString());
      // emit(PaymentError(error.toString()));
    });
  }

// OrdeId
  Future getOrderId(
    String firstname,
    String lastName,
    String email,
    String phone,
    int price,
    String integrationmethod,
  ) async {
    DioHelper.postData(url: orderidurl, data: {
      'auth_token': paymentFirstToken,
      'delivery_needed': false,
      'amount_cents': "${price * 100}",
      // 'amount_cents': "10000",
      "currency": "EGP",
      // 'merchant_order_id': orderIdCard,
      'items': [],
    }).then((value) {
      paymentOrderId = value!.data['id'].toString();
      print('orderid is :$paymentOrderId');
      getPaymentkeyToken(
          lastName: lastName,
          firstname: firstname,
          email: email,
          price: price,
          phone: phone,
          integrationmethod: integrationmethod);

      // emit(PaymentGetOrderIdSuccess());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentGetOrderIdError(error.toString()));
    });
  }

// PaymentkeyToken
  Future getPaymentkeyToken({
    required String firstname,
    required String lastName,
    required String email,
    required String phone,
    required int price,
    required String integrationmethod,
  }) async {
    DioHelper.postData(url: paymentkeytokenurl, data: {
      "auth_token": paymentFirstToken,
      "amount_cents": "${price * 100}",
      "expiration": 3600,
      "order_id": paymentOrderId,
      "billing_data": {
        "apartment": "NA",
        "email": email,
        "floor": "NA",
        "first_name": firstname,
        "street": "NA",
        "building": "NA",
        "phone_number": phone,
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "last_name": lastName,
        "state": "NA"
      },
      "currency": "EGP",
      "integration_id": integrationmethod,
      "lock_order_when_paid": "false"
    }).then((value) {
      finalToken = value!.data['token'].toString();
      print('final token is :$finalToken');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VisaScreen();
      }));
      // emit(PaymentkeyTokenSuccess());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentkeyTokenError(error.toString()));
    });
  }

  Future PaymentWithValu({
    required String firstname,
    required String lastName,
    required String email,
    required String phone,
    required int price,
    String? integrationmethod,
  }) async {
    DioHelper.postData(
        url: authenticationrequesturl,
        data: {"api_key": paymentApiKey}).then((value) {
      paymentFirstToken = value?.data['token'];
      print('first token is :$paymentFirstToken');
      getOrderIdValu(
          firstname, lastName, email, phone, price, integrationmethod!);

      // emit(PaymentSuccessValu());
    }).catchError((error) {
      print('error is :' + error.toString());
      // emit(PaymentErrorValu(error.toString()));
    });
  }

// OrdeId
  Future getOrderIdValu(
    String firstname,
    String lastName,
    String email,
    String phone,
    int price,
    String integrationmethod,
  ) async {
    DioHelper.postData(url: orderidurl, data: {
      'auth_token': paymentFirstToken,
      'delivery_needed': false,
      'amount_cents': "${price * 100}",
      "currency": "EGP",
      'merchant_order_id': orderIdCard,
      'items': [],
    }).then((value) {
      paymentOrderId = value!.data['id'].toString();
      print('orderid is :$paymentOrderId');
      getPaymentkeyTokenValu(
          firstname: firstname,
          lastName: lastName,
          email: email,
          price: price,
          phone: phone,
          integrationmethod: integrationmethod);

      // emit(PaymentGetOrderIdSuccessValu());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentGetOrderIdErrorValu(error.toString()));
    });
  }

// PaymentkeyToken
  Future getPaymentkeyTokenValu({
    required String firstname,
    required String lastName,
    required String email,
    required String phone,
    required int price,
    required String integrationmethod,
  }) async {
    DioHelper.postData(url: paymentkeytokenurl, data: {
      "auth_token": paymentFirstToken,
      "amount_cents": "${price * 100}",
      "expiration": 3600,
      "order_id": paymentOrderId,
      "billing_data": {
        "apartment": "NA",
        "email": email,
        "floor": "NA",
        "first_name": firstname,
        "street": "NA",
        "building": "NA",
        "phone_number": phone,
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "last_name": lastName,
        "state": "NA"
      },
      "currency": "EGP",
      "integration_id": integrationIDValu,
      "lock_order_when_paid": "false"
    }).then((value) {
      finalToken = value!.data['token'].toString();
      print('final token is :$finalToken');

      // emit(PaymentkeyTokenSuccessValu());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentkeyTokenErrorValu(error.toString()));
    });
  }

  Future PaymentWithWallet({
    required String firstname,
    required String email,
    required String lastName,
    required String phone,
    required int price,
    String? integrationmethod,
  }) async {
    DioHelper.postData(
        url: authenticationrequesturl,
        data: {"api_key": paymentApiKey}).then((value) {
      paymentFirstToken = value?.data['token'];
      print('first token is :$paymentFirstToken');
      getOrderIdWallet(
          firstname, lastName, email, phone, price, integrationmethod!);

      // emit(PaymentSuccessWallet());
    }).catchError((error) {
      print('error is :' + error.toString());
      // emit(PaymentErrorWallet(error.toString()));
    });
  }

// OrdeId
  Future getOrderIdWallet(
    String firstname,
    String lastName,
    String email,
    String phone,
    int price,
    String integrationmethod,
  ) async {
    DioHelper.postData(url: orderidurl, data: {
      'auth_token': paymentFirstToken,
      'delivery_needed': false,
      'amount_cents': "${price * 100}",
      "currency": "EGP",
      'merchant_order_id': orderIdCard,
      'items': [],
    }).then((value) {
      paymentOrderId = value!.data['id'].toString();
      print('orderid is :$paymentOrderId');
      getPaymentkeyTokenWallet(
          firstname: firstname,
          lastName: lastName,
          email: email,
          price: price,
          phone: phone,
          integrationmethod: integrationmethod);
      // emit(PaymentGetOrderIdSuccessWallet());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentGetOrderIdErrorWallet(error.toString()));
    });
  }

// PaymentkeyToken
  Future getPaymentkeyTokenWallet({
    required String firstname,
    required String lastName,
    required String email,
    required String phone,
    required int price,
    required String integrationmethod,
  }) async {
    DioHelper.postData(url: paymentkeytokenurl, data: {
      "auth_token": paymentFirstToken,
      "amount_cents": "${price * 100}",
      "expiration": 3600,
      "order_id": paymentOrderId,
      "billing_data": {
        "apartment": "NA",
        "email": email,
        "floor": "NA",
        "first_name": firstname,
        "street": "NA",
        "building": "NA",
        "phone_number": phone,
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "last_name": lastName,
        "state": "NA"
      },
      "currency": "EGP",
      "integration_id": integrationmethod,
      "lock_order_when_paid": "false"
    }).then((value) {
      finalToken = value!.data['token'].toString();
      print('final token is :$finalToken');
      getVodafoneCash(phone);

      // emit(PaymentkeyTokenSuccessWallet());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentkeyTokenErrorWallet(error.toString()));
    });
  }

//get ref code
  GetWalletModel? getWalletModel;
  Future getVodafoneCash(String phone) async {
    DioHelper.postData(url: paymentReferencecodeurl, data: {
      "source": {"identifier": phone, "subtype": "WALLET"},
      "payment_token": finalToken
    }).then((value) {
      print(value);
      refcode = value!.data['id'].toString();
      iframeRedirectionUrl = value.data['iframe_redirection_url'].toString();
      // getWalletModel = GetWalletModel.fromJson(value.data);
      // iframeRedirectionUrl = getWalletModel!.iframeRedirectionUrl;
      print('referance code is :$iframeRedirectionUrl');

      // emit(PaymentkReferencecodeSuccess());
    }).catchError((error) {
      print(error.toString());
      // emit(PaymentReferencecodeError(error.toString()));
    });
  }

//paymentKiosk
  Future paymentKiosk({
    required String firstname,
    required String lastName,
    required String lastname,
    required String email,
    required String phone,
    required int price,
  }) async {
    DioHelper.postData(
        url: authenticationrequesturl,
        data: {"api_key": paymentApiKey}).then((value) {
      paymentFirstToken = value?.data['token'];
      print('first token is :$paymentFirstToken');
      // getOrderId();
      getPaymentkeyToken(
          firstname: firstname,
          lastName: lastName,
          email: email,
          price: price,
          phone: phone,
          integrationmethod: integrationIDKiosk);
      // getRefererencCodeKiosk();

      // emit(PaymentSuccess());
    }).catchError((error) {
      print('error is :' + error.toString());
      // emit(PaymentError(error.toString()));
    });
  }

  // GetApiKeyModel? getApiKeyModel;
  // void getApiKeyValue({
  //   String? firstname,
  //   String? lastName,
  //   String? email,
  //   String? phone,
  //   int? price,
  //   String? integrationmethod,
  // }) {
  //   DioHelper.getData(url: '${API.baseUrl}payment/paymob/credentials')
  //       .then((value) {
  //     getApiKeyModel = GetApiKeyModel.fromJson(value!.data);
  //     paymentApiKey = getApiKeyModel!.data!.apiKey;
  //     integrationIDCard = getApiKeyModel!.data!.integrationId;
  //     integrationIDValu = getApiKeyModel!.data!.valueIntegrationId;
  //     integrationIDWallet = getApiKeyModel!.data!.walletIntegrationId;
  //     iframeIdCard = getApiKeyModel!.data!.iframeId;
  //     iframeIdValu = getApiKeyModel!.data!.valueIframeId;
  //     print(integrationIDValu);
  //     print(iframeIdValu);
  //     addAmount('${price! * 100}');
  //     Timer(Duration(seconds: 2), () {
  //       PaymentWithValu(
  //           firstname: firstname!,
  //           lastName: lastName!,
  //           email: email!,
  //           phone: phone!,
  //           price: price,
  //           integrationmethod: integrationIDValu);
  //     });
  //     // emit(GetApiSuccess());
  //   }).catchError((er) {
  //     print(er.toString());
  //     // emit(GetApiError(er.toString()));
  //   });
  // }

  // void getApiKeyCard({
  //   String? firstname,
  //   String? lastName,
  //   String? email,
  //   String? phone,
  //   int? price,
  //   String? integrationmethod,
  // }) {
  //   DioHelper.getData(url: '${API.baseUrl}payment/paymob/credentials')
  //       .then((value) {
  //     getApiKeyModel = GetApiKeyModel.fromJson(value!.data);
  //     paymentApiKey = getApiKeyModel!.data!.apiKey;
  //     integrationIDCard = getApiKeyModel!.data!.integrationId;
  //     integrationIDValu = getApiKeyModel!.data!.valueIntegrationId;
  //     integrationIDWallet = getApiKeyModel!.data!.walletIntegrationId;
  //     iframeIdCard = getApiKeyModel!.data!.iframeId;
  //     iframeIdValu = getApiKeyModel!.data!.valueIframeId;
  //     print(integrationIDValu);
  //     print(integrationIDCard);
  //     addAmount('${price! * 100}');
  //     Timer(Duration(seconds: 2), () {
  //       PaymentWithCard(
  //           firstname: firstname!,
  //           lastName: lastName!,
  //           email: email!,
  //           phone: phone!,
  //           price: price,
  //           integrationmethod: integrationIDCard);
  //     });
  //     // emit(GetApiSuccess());
  //   }).catchError((er) {
  //     print(er.toString());
  //     // emit(GetApiError(er.toString()));
  //   });
  // }

  // void getApiKeyValueWallet({
  //   String? firstname,
  //   String? lastName,
  //   String? email,
  //   String? phone,
  //   int? price,
  //   String? integrationmethod,
  // }) {
  //   DioHelper.getData(url: '${API.baseUrl}payment/paymob/credentials')
  //       .then((value) {
  //     getApiKeyModel = GetApiKeyModel.fromJson(value!.data);
  //     paymentApiKey = getApiKeyModel!.data!.apiKey;
  //     integrationIDCard = getApiKeyModel!.data!.integrationId;
  //     integrationIDValu = getApiKeyModel!.data!.valueIntegrationId;
  //     integrationIDWallet = getApiKeyModel!.data!.walletIntegrationId;
  //     iframeIdCard = getApiKeyModel!.data!.iframeId;
  //     iframeIdValu = getApiKeyModel!.data!.valueIframeId;
  //     print(integrationIDValu);
  //     addAmount('${price! * 100}');
  //     Timer(Duration(seconds: 2), () {
  //       PaymentWithWallet(
  //           firstname: firstname!,
  //           email: email!,
  //           lastName: lastName!,
  //           phone: phone!,
  //           price: price,
  //           integrationmethod: integrationIDWallet);
  //     });
  //     // emit(GetApiSuccess());
  //   }).catchError((er) {
  //     print(er.toString());
  //     // emit(GetApiError(er.toString()));
  //   });
  // }

  AddAmountModel? addAmountModel;
  void addAmount(amount) {
    FormData formData = FormData({'amount': amount});
    DioHelper.postDataa(
            url: '${API.baseUrl}/payment/paymob/checkout', data: formData)
        .then((value) {
      addAmountModel = AddAmountModel.fromJson(value!.data);
      orderIdCard = addAmountModel!.data!.orderId.toString();
      print('order id ===========${orderIdCard}');
      // emit(AddAmountSuccess());
    }).catchError((er) {
      print(er.toString());
      // emit(AddAmountError(er.toString()));
    });
  }
}
