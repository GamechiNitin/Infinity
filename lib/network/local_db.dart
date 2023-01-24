import 'dart:convert';
import 'dart:developer';

import 'package:infinity_box/model/product_model.dart';
import 'package:infinity_box/response/product_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  Future<bool> saveUser(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool val = await sharedPreferences.setString('key', token);
    log("Token $val");

    return val;
  }

  Future<String?> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('key');
    log("Token ${token.toString()}");
    return token;
  }

  // Add to Cart
  Future<bool> addToCart(List<ProductModel> data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool val = await sharedPreferences.setString('cart', jsonEncode(data));
    log("Cart Add $val");

    return val;
  }

  Future<List<ProductModel>> getCart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString('cart');
    log("Cart ${data.toString()}");
    List<ProductModel> rawList = [];
    if (data != null) {
      try {
        ProductListResponse productListResponse =
            ProductListResponse.fromJson(jsonDecode(data));
        rawList.addAll(productListResponse.productModel!);
      } catch (e) {
        log(e.toString());
      }
    }
    return rawList;
  }
}
