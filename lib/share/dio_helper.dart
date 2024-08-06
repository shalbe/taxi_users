import 'package:cabme/constant/const.dart';
import 'package:cabme/service/api.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
//initial state
  static init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseurl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 70),
      receiveTimeout: Duration(seconds: 70),
    );
    dio = Dio(options);
  }

//getdata from api
  static Future<Response?> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      // "Authorization": 'Bearer  ${bearerToken[0].token}'
    };
    try {
      Response response = await dio.get(
        url,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //post data to api
  static Future<Response?> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      //  "Authorization": 'Bearer  ${bearerToken[0].token}'
    };
    try {
      Response response = await dio.post(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Response?> getDataa({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      // "Authorization": 'Bearer  ${bearerToken[0].token}'
    };
    try {
      Response response = await dio.get(
        url,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //post data to api
  static Future<Response?> postDataa({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      // "Authorization": 'Bearer  ${bearerToken[0].token}'
    };
    try {
      Response response = await dio.post(
        url,
        data: data,
        queryParameters: query,
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
