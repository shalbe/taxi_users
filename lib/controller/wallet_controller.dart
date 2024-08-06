// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as devlo;
import 'dart:io';
import 'dart:math';

import 'package:cabme/constant/const.dart';
import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/add_amount_model.dart';
import 'package:cabme/model/first_token.dart';
import 'package:cabme/model/get_wallet.dart';
import 'package:cabme/model/order_id_model.dart';
import 'package:cabme/model/payStackURLModel.dart';
import 'package:cabme/model/payment_method_model.dart';
import 'package:cabme/model/payment_setting_model.dart';
import 'package:cabme/model/razorpay_gen_orderid_model.dart';
import 'package:cabme/model/transaction_model.dart';
import 'package:cabme/model/user_model.dart';
import 'package:cabme/page/parcel_service_screen/visascreen.dart';
import 'package:cabme/page/wallet/wallet_screen.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/share/dio_helper.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  RxString ref = "".obs;

  RxDouble walletAmount = 0.0.obs;
  var walletList = <TransactionData>[].obs;
  var paymentMethodList = <PaymentMethodData>[].obs;

  var isLoading = true.obs;

  RxString? selectedRadioTile;

  var paymentSettingModel = PaymentSettingModel().obs;

  RxBool stripe = false.obs;
  RxBool razorPay = false.obs;
  RxBool payTm = false.obs;
  RxBool paypal = false.obs;
  RxBool payStack = false.obs;
  RxBool flutterWave = false.obs;
  RxBool mercadoPago = false.obs;
  RxBool payFast = false.obs;
  RxBool paymob = false.obs;

  @override
  void onInit() {
    getAmount();
    getTransaction();
    setFlutterwaveRef();
    getPaymentMethod();
    selectedRadioTile = "".obs;
    paymentSettingModel.value = Constant.getPaymentSetting();
    getUsrData();
    super.onInit();
  }

  UserModel? userModel;

  getUsrData() {
    userModel = Constant.getUserData();
  }

  setFlutterwaveRef() {
    Random numRef = Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      ref.value = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      ref.value = "IOSRef$year$refNumber";
    }
  }

  Future<dynamic> getPaymentMethod() async {
    try {
      isLoading.value = true;
      final response =
          await http.get(Uri.parse(API.getPaymentMethod), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      devlo.log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        PaymentMethodModel model = PaymentMethodModel.fromJson(responseBody);
        paymentMethodList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
        paymentMethodList.clear();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        paymentMethodList.clear();
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
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getTransaction() async {
    try {
      isLoading.value = true;
      final response = await http.get(
          Uri.parse(
              "${API.transaction}?id_user_app=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);
      devlo.log(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        TransactionModel model = TransactionModel.fromJson(responseBody);
        walletList.value = model.data!;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getAmount() async {
    try {
      final response = await http.get(
          Uri.parse(
              "${API.wallet}?id_user=${Preferences.getInt(Preferences.userId)}&user_cat=user_app"),
          headers: API.header);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        walletAmount.value = responseBody['data']['amount'] != null
            ? double.parse(responseBody['data']['amount'].toString())
            : 0;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
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

  Future<dynamic> setAmount(String amount) async {
    try {
      ShowToastDialog.showLoader("please wait".tr);
      Map<String, dynamic> bodyParams = {
        'id_user': Preferences.getInt(Preferences.userId),
        'cat_user': "user_app",
        'amount': amount,
        'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
        'paymethod': selectedRadioTile!.value,
      };
      final response = await http.post(Uri.parse(API.amount),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "failed") {
        ShowToastDialog.closeLoader();
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
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  ///razorPay
  Future<CreateRazorPayOrderModel?> createOrderRazorPay(
      {required int amount, bool isTopup = false}) async {
    final String orderId =
        "${Preferences.getInt(Preferences.userId)}_${DateTime.now().microsecondsSinceEpoch}";

    const url = "${API.baseUrl}payments/razorpay/createorder";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'apikey': API.apiKey,
          'accesstoken': Preferences.getString(Preferences.accesstoken),
        },
        body: {
          "amount": (amount * 100).toString(),
          "receipt_id": orderId,
          "currency": "INR",
          "razorpaykey": paymentSettingModel.value.razorpay!.key,
          "razorPaySecret": paymentSettingModel.value.razorpay!.secretKey,
          "isSandBoxEnabled":
              paymentSettingModel.value.razorpay!.isSandboxEnabled,
        },
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['id'] != null) {
        isLoading.value = false;
        return CreateRazorPayOrderModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['id'] == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;

    //
    //
    // final response = await http.post(
    //   Uri.parse(url),
    //   body: {
    //     "amount": (amount * 100).toString(),
    //     "receipt_id": orderId,
    //     "currency": "INR",
    //     "razorpaykey": "rzp_test_0iHc1FA4UBP0H3",
    //     "razorPaySecret": "Y79h9H1l4qLTKvgXFDei9pA5",
    //     "isSandBoxEnabled": true,
    //   },
    // );
    //
    //
    // if (response.statusCode == 500) {
    //   return null;
    // } else {
    //   final data = jsonDecode(response.body);
    //
    //
    //   return CreateRazorPayOrderModel.fromJson(data);
    // }
    //
  }

  ///payStack
  Future<dynamic> payStackURLGen(
      {required String amount, required secretKey}) async {
    const url = "https://api.paystack.co/transaction/initialize";

    try {
      final response = await http.post(Uri.parse(url), body: {
        "email": "demo@email.com",
        "amount": (double.parse(amount) * 100).toString(),
        "currency": "NGN",
      }, headers: {
        "Authorization": "Bearer $secretKey",
      });

      final responseBody = json.decode(response.body);
      log(responseBody);

      if (response.statusCode == 200 && responseBody['status'] == true) {
        isLoading.value = false;
        return PayStackUrlModel.fromJson(responseBody);
      } else if (response.statusCode == 200 && responseBody['status'] == null) {
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }

    final response = await http.post(Uri.parse(url), body: {
      "email": "demo@email.com",
      "amount": (double.parse(amount) * 100).toString(),
      "currency": "NGN",
    }, headers: {
      "Authorization": "Bearer $secretKey",
    });

    final data = jsonDecode(response.body);

    if (!data["status"]) {
      return null;
    }
    return PayStackUrlModel.fromJson(data);
  }

  Future<bool> payStackVerifyTransaction({
    required String reference,
    required String secretKey,
    required String amount,
  }) async {
    final url = "https://api.paystack.co/transaction/verify/$reference";
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $secretKey",
    });

    final data = jsonDecode(response.body);
    if (data["status"] == true) {
      if (data["message"] == "Verification successful") {}
    }

    return data["status"];

    //PayPalClientSettleModel.fromJson(data);
  }

  ///Stripe
  createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "${Preferences.getInt(Preferences.userId)} Wallet Topup",
        "shipping[name]":
            "${Preferences.getInt(Preferences.userId)} ${Preferences.getInt(Preferences.userId)}",
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      var stripeSecret = paymentSettingModel.value.strip!.secretKey;
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {}
  }

  ///paytm
  Future verifyCheckSum(
      {required String checkSum,
      required double amount,
      required orderId}) async {
    String getChecksum = "${API.baseUrl}payments/validatechecksum";
    final response = await http.post(
        Uri.parse(
          getChecksum,
        ),
        body: {
          "mid": paymentSettingModel.value.paytm!.merchantId,
          "order_id": orderId,
          "key_secret": paymentSettingModel.value.paytm!.merchantKey,
          "checksum_value": checkSum,
        });
    final data = jsonDecode(response.body);
    log(data);

    return data['status'];
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
