// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme/constant/constant.dart';
import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/controller/dash_board_controller.dart';
import 'package:cabme/model/driver_location_update.dart';
import 'package:cabme/model/driver_model.dart';
import 'package:cabme/model/payment_method_model.dart';
import 'package:cabme/model/sub_category_model.dart';
import 'package:cabme/model/vehicle_category_model.dart';
import 'package:cabme/service/api.dart';
import 'package:cabme/service/ride_service.dart';
import 'package:cabme/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../model/categories_model.dart';
import '../model/payment_setting_model.dart';
import '../themes/custom_dialog_box.dart';

class HomeController extends GetxController {
  //for Choose your Rider

  LatLng center = const LatLng(41.4219057, -102.0840772);

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  RxString selectPaymentMode = "Payment Method".obs;
  List<AddChildModel> addChildList = [
    AddChildModel(editingController: TextEditingController())
  ];
  List<AddStopModel> multiStopList = [];
  List<AddStopModel> multiStopListNew = [];

  RxString selectedVehicle = "".obs;
  late VehicleData? vehicleData;
  late PaymentMethodData? paymentMethodData;

  RxString tripOptionCategory = "General".obs;
  RxString paymentMethodType = "Select Method".tr.obs;
  RxString paymentMethodId = "".obs;
  RxDouble distance = 0.0.obs;
  RxString duration = "".obs;

  var paymentSettingModel = PaymentSettingModel().obs;
  Rx<DriverData> driverSelected = DriverData().obs;
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
  TextEditingController passengerController = TextEditingController(
      text: "1"); // for choosing destination and user location

  RxInt selectedUserLocationTileIndex = (-1).obs;
  RxInt selectedUserDestinationTileIndex = (-1).obs;

  List<CategoryModel> categories = [];
  late CategoryModel selectedCategory;
  PageController rideLocationsPageController = PageController();
  ScrollController locationScrollController = ScrollController();
  ScrollController destinationScrollController = ScrollController();
  List<SubCategoryModel> subCategoriesRequestTo = [];
  List<SubCategoryModel> subCategoriesRequestFrom = [];
  RxBool twoWayCondition = false.obs;
  RxString currentPrice = "".obs;
  RxBool confirmWidgetVisible = false.obs;
  RxDouble tripPrice = (0.0).obs;
  bool subCategoriesIsLoading = false;
  WebViewController? webViewcontroller;
  int paymentType = 0; //for door to door and 1 for city to city;
  final DashBoardController dashBoardController =
      Get.find<DashBoardController>();
  @override
  void onInit() async {
    dashBoardController.getPaymentSettingData();
    paymentSettingModel.value = Constant.getPaymentSetting();
    getCategories();
    setIcons();
    getTaxiData();

    super.onInit();
  }

  esnurePaymentSettings() {
    paymentSettingModel.value = Constant.getPaymentSetting();
  }

  Map<String, dynamic> getBodyParams() {
    return {
      'user_id': Preferences.getInt(Preferences.userId).toString(),
      //from
      'lat1': subCategoriesRequestFrom[selectedUserLocationTileIndex.value]
          .name
          .toString(),
      //to
      'lng1': subCategoriesRequestTo[selectedUserDestinationTileIndex.value]
          .name
          .toString(),
      'lat2': paymentType,
      'lng2': "0",
      //price
      'cout': tripPrice.value,
      'distance': "0",
      'distance_unit': Constant.distanceUnit.toString(),
      'duree': duration.toString(),
      'id_conducteur': driverSelected.value.id!,
      'id_payment': paymentMethodId.value,
      'depart_name':
          subCategoriesRequestFrom[selectedUserLocationTileIndex.value]
              .name
              .toString(),
      'destination_name':
          subCategoriesRequestTo[selectedUserDestinationTileIndex.value]
              .name
              .toString(),
      'stops': [],
      'place': twoWayCondition.value ? "Two Way" : "One Way",
      'number_poeple': passengerController.text,
      'image': '0',
      'image_name': "0",
      'statut_round': '1',
      'trip_objective': "0",
      'age_children1': "0",
      'age_children2': "0",
      'age_children3': "0",
    };
  }

// functions of Dealing with Location Api
  void getCategories() async {
    categories = await RideService.getCategories();
    update();
  }

  void selectUserLocationTile(int index) {
    selectedUserLocationTileIndex.value = index;
    update();
    getCurrentPrice();
  }

  void selectUserDestinationTile(int index) {
    selectedUserDestinationTileIndex.value = index;
    confirmWidgetVisible.value = true;
    update();
  }

  void disposeUserLocationSelection() {
    selectedUserLocationTileIndex.value = -1;
    update();
  }

  void disposeTwoWaySelection() {
    twoWayCondition.value = false;
  }

  void disposeUserDestinationSelection() {
    selectedUserDestinationTileIndex.value = -1;
    update();
  }

  void disposeSelections() {
    selectedUserLocationTileIndex.value = -1;
    twoWayCondition.value = false;
    selectedUserDestinationTileIndex.value = -1;
    update();
  }

  void disposeSubCategories() {
    subCategoriesRequestTo = [];
    subCategoriesRequestFrom = [];
  }

  void getSubCategoriesListTo() async {
    subCategoriesIsLoading = true;
    update();
    subCategoriesRequestTo =
        await RideService.getSubCategory(selectedCategory.id!, RequestType.to);
    subCategoriesIsLoading = false;
    update();
  }

  void getSubCategoriesListFrom() async {
    subCategoriesIsLoading = true;
    update();

    subCategoriesRequestFrom = await RideService.getSubCategory(
        selectedCategory.id!, RequestType.from);
    subCategoriesIsLoading = false;
    update();
  }

  void toggleSwitch(bool value) {
    twoWayCondition.value = value;
    getCurrentPrice();
  }

  void getCurrentPrice() {
    if (selectedUserDestinationTileIndex.value == -1) {
      currentPrice.value = "0";
    } else {
      SubCategoryModel subCategoryModel =
          subCategoriesRequestTo[selectedUserDestinationTileIndex.value];
      currentPrice.value = twoWayCondition.value
          ? subCategoryModel.price2 ?? 0.toDouble().toInt().toString()
          : subCategoryModel.price ?? 0.toDouble().toInt().toString();
    }
    print(currentPrice.value);
  }

  void rideCreation(Map<String, String> bodyParams) {}

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? taxiIcon;
  BitmapDescriptor? stopIcon;

  final Map<String, Marker> markers = {};

  setIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/pickup.png")
        .then((value) {
      departureIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/dropoff.png")
        .then((value) {
      destinationIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/ic_taxi.png")
        .then((value) {
      taxiIcon = value;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(10, 10)),
            "assets/icons/location.png")
        .then((value) {
      stopIcon = value;
    });
  }

  addStops() async {
    ShowToastDialog.showLoader("please wait".tr);
    multiStopList.add(AddStopModel(
        editingController: TextEditingController(),
        latitude: "",
        longitude: ""));
    multiStopListNew = List<AddStopModel>.generate(
      multiStopList.length,
      (int index) => AddStopModel(
          editingController: multiStopList[index].editingController,
          latitude: multiStopList[index].latitude,
          longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  removeStops(int index) {
    ShowToastDialog.showLoader("please wait".tr);
    multiStopList.removeAt(index);
    multiStopListNew = List<AddStopModel>.generate(
      multiStopList.length,
      (int index) => AddStopModel(
          editingController: multiStopList[index].editingController,
          latitude: multiStopList[index].latitude,
          longitude: multiStopList[index].longitude),
    );
    ShowToastDialog.closeLoader();
    update();
  }

  clearData() {
    selectedVehicle.value = "";
    selectPaymentMode.value = "Payment Method";
    tripOptionCategory = "General".obs;
    paymentMethodType = "Select Method".obs;
    paymentMethodId = "".obs;
    distance = 0.0.obs;
    duration = "".obs;
    multiStopList.clear();
    multiStopListNew.clear();
  }

  RxList<DriverLocationUpdate> driverLocationList =
      <DriverLocationUpdate>[].obs;

  Future getTaxiData() async {
    Constant.driverLocationUpdateCollection
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        DriverLocationUpdate driverLocationUpdate =
            DriverLocationUpdate.fromJson(
                element.data() as Map<String, dynamic>);
        driverLocationList.add(driverLocationUpdate);
        driverLocationList.forEach((element) {
          markers[element.driverId.toString()] = Marker(
            markerId: MarkerId(element.driverId.toString()),
            rotation: double.parse(element.rotation.toString()),
            // infoWindow: InfoWindow(title: element.prenom.toString(), snippet: "${element.brand},${element.model},${element.numberplate}"),
            position: LatLng(
                double.parse(element.driverLatitude.toString().isNotEmpty
                    ? element.driverLatitude.toString()
                    : "0.0"),
                double.parse(element.driverLongitude.toString().isNotEmpty
                    ? element.driverLongitude.toString()
                    : "0.0")),
            icon: taxiIcon!,
          );
        });
      }
    });
  }

  Future<dynamic> getDurationDistance(
      LatLng departureLatLong, LatLng destinationLatLong) async {
    ShowToastDialog.showLoader("please wait".tr);
    double originLat, originLong, destLat, destLong;
    originLat = departureLatLong.latitude;
    originLong = departureLatLong.longitude;
    destLat = destinationLatLong.latitude;
    destLong = destinationLatLong.longitude;

    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    http.Response restaurantToCustomerTime = await http.get(Uri.parse(
        '$url?units=metric&origins=$originLat,'
        '$originLong&destinations=$destLat,$destLong&key=${Constant.kGoogleApiKey}'));

    var decodedResponse = jsonDecode(restaurantToCustomerTime.body);

    if (decodedResponse['status'] == 'OK' &&
        decodedResponse['rows'].first['elements'].first['status'] == 'OK') {
      ShowToastDialog.closeLoader();
      return decodedResponse;
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<PlacesDetailsResponse?> placeSelectAPI(BuildContext context) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Constant.kGoogleApiKey,
      mode: Mode.overlay,
      onError: (response) {
        log("-->${response.status}");
      },
      language: 'fr',
      resultTextStyle: Theme.of(context).textTheme.titleMedium,
      types: [],
      strictbounds: false,
      components: [],
    );

    return displayPrediction(p!);
  }

  Future<PlacesDetailsResponse?> displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces? places = GoogleMapsPlaces(
        apiKey: Constant.kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse? detail =
          await places.getDetailsByPlaceId(p.placeId.toString());

      return detail;
    }
    return null;
  }

  Future<dynamic> getUserPendingPayment() async {
    try {
      ShowToastDialog.showLoader("please wait".tr);

      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId)
      };
      final response = await http.post(Uri.parse(API.userPendingPayment),
          headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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

  Future<VehicleCategoryModel?> getVehicleCategory() async {
    try {
      ShowToastDialog.showLoader("please wait".tr);
      final response = await http.get(
        Uri.parse(API.getVehicleCategory),
        headers: API.header,
      );
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        update();
        ShowToastDialog.closeLoader();
        return VehicleCategoryModel.fromJson(responseBody);
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

  Future<DriverModel?> getDriverDetails(
      String typeVehicle, String? lat1, String? lng1) async {
    lat1 ??= "0.0";
    lng1 ??= "0.0";
    try {
      ShowToastDialog.showLoader("please wait".tr);
      final response = await http.get(
          Uri.parse(
              "${API.driverDetails}?type_vehicle=$typeVehicle&lat1=$lat1&lng1=$lng1"),
          headers: API.header);
      log(response.request.toString());

      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return DriverModel.fromJson(responseBody);
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

  Future<dynamic> setFavouriteRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("please wait".tr);
      final response = await http.post(Uri.parse(API.setFavouriteRide),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
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
  }

  Future<dynamic> bookRide(
    Map<String, dynamic> bodyParams,
  ) async {
    try {
      ShowToastDialog.showLoader("please wait".tr);
      final response = await http.post(Uri.parse(API.bookRides),
          headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log("responseBody : $responseBody");
      if (response.statusCode == 200) {
        // SendNotification.sendMessageNotification(token: , payload: )
        log("book ride : $responseBody");
        ShowToastDialog.closeLoader();
        if (paymentType == 1) {
          final getFatooraUrl = await http.get(
              Uri.parse(
                  "${API.getFatoora}?oid=${responseBody["data"][0]["id"]}"),
              headers: API.header);
          log("getFatoora Url : ${jsonDecode(getFatooraUrl.body)["url"]}");
          webViewcontroller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) async {
                  log(url);
                  if (url.contains("callback")) {
                    final callBackResponse = await http.get(Uri.parse(url));
                    final responseBody = jsonDecode(callBackResponse.body);
                    if (responseBody["IsSuccess"] == false) {
                      clearData();
                      Get.close(2);
                      Get.dialog(CustomDialogBox(
                        title: "",
                        descriptions:
                            "Your booking has not been sent please try again"
                                .tr,
                        onPress: () {
                          Get.back();
                        },
                      ));
                    } else {
                      Get.close(2);
                      departureController.clear();
                      destinationController.clear();
                      clearData();
                      tripPrice.value = 0.0;

                      Get.dialog(CustomDialogBox(
                        title: "",
                        descriptions: "Your booking has been sent successfully",
                        onPress: () {
                          Get.back();
                        },
                        img: Image.asset('assets/images/green_checked.png'),
                      ));
                    }
                  }
                },
                onHttpError: (HttpResponseError error) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(jsonDecode(getFatooraUrl.body)["url"]));
        }
        return responseBody;
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
      log(e.toString());

      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log(e.toString());
      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  double calculateTripPrice(
      {required double destinationPrice, required double deliveryCharges}) {
    double cout = 0.0;

    cout = destinationPrice + deliveryCharges;
    return cout;
  }
}

double getSelectedVeichleTripPrice(
    {required double destinationPrice, required double deliveryCharges}) {
  double cout = destinationPrice + deliveryCharges;
  return cout;
}

class AddChildModel {
  TextEditingController editingController = TextEditingController();

  AddChildModel({required this.editingController});
}

class AddStopModel {
  String latitude = "";
  String longitude = "";
  TextEditingController editingController = TextEditingController();

  AddStopModel({
    required this.editingController,
    required this.latitude,
    required this.longitude,
  });
}
