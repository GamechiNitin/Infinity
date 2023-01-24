import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:infinity_box/model/product_model.dart';
import 'package:infinity_box/response/product_list_response.dart';
import 'package:infinity_box/utils/api_string.dart';

class ProductRepository {
  Future<List<String>?> getCategories() async {
    final response = await http.get(Uri.parse(ApiString.productCategoriesUrl));

    log(":::::: ${response.statusCode} ${response.request} \n ${response.body}");

    try {
      if (response.statusCode == 200) {
        List<String>? token = [];
        List<dynamic> parsedJson = jsonDecode(response.body);
        token.addAll(parsedJson.map((e) => e));
        return token;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<ProductModel>?> fetchDataList() async {
    List<ProductModel>? productList = [];

    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    log(":::::: ${response.statusCode} ${response.request} \n ${response.body}");
    if (response.statusCode == 200) {
      ProductListResponse productListResponse =
          ProductListResponse.fromJson(jsonDecode(response.body));

      if (productListResponse.productModel != null &&
          productListResponse.productModel!.isNotEmpty) {
        productList.addAll(productListResponse.productModel!);
        return productList;
      }
    } else {
      throw Exception('Failed to get product');
    }
    return null;
  }

  Future<List<ProductModel>?> filterProductCategoryListApi(
      String filter) async {
    List<ProductModel> productList = [];

    final response =
        await http.get(Uri.parse(ApiString.filterProductCategoriesUrl(filter)));

    log(":::::: ${response.statusCode} ${response.request} \n ${response.body}");

    if (response.statusCode == 200) {
      ProductListResponse productListResponse =
          ProductListResponse.fromJson(jsonDecode(response.body));

      if (productListResponse.productModel != null &&
          productListResponse.productModel!.isNotEmpty) {
        productList.addAll(productListResponse.productModel!);
        return productList;
      }
    } else {
      throw Exception('Failed to get product');
    }
    return null;
  }
}
