import 'dart:developer';

import 'package:cabme/constant/show_toast_dialog.dart';
import 'package:cabme/model/sub_category_model.dart';
import 'package:cabme/service/api.dart';
import 'package:dio/dio.dart';

import '../model/categories_model.dart';

enum RequestType { from, to }

class RideService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: API.baseUrl,
      // headers: API.header,
    ),
  );
  static Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = [];
    try {
      var response = await _dio.get(
        'categories/',
      );
      for (var category in response.data["data"]) {
        categories.add(CategoryModel.fromJson(category));
      }
      return categories;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<SubCategoryModel>> getSubCategory(
      int id, RequestType type) async {
    log("id of category : $id");
    ShowToastDialog.showLoader("");
    List<SubCategoryModel> subCategories = [];
    try {
      String requestType =
          type == RequestType.to ? "requestTo/" : "requestFrom/";

      var response = await _dio.post(requestType, data: {"id": id});
      for (var subCategory in response.data["data"]) {
        subCategories.add(SubCategoryModel.fromJson(subCategory));
      }
      ShowToastDialog.closeLoader();

      return subCategories;
    } on DioException catch (e) {
      ShowToastDialog.closeLoader();

      return subCategories;
    }
  }
}
