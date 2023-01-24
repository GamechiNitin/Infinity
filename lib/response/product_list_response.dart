import 'package:infinity_box/model/product_model.dart';

class ProductListResponse {
  List<ProductModel>? productModel;
  ProductListResponse({this.productModel});

  factory ProductListResponse.fromJson(List<dynamic> parsedJson) {
    List<ProductModel>? data = <ProductModel>[];

    data = parsedJson.map((i) => ProductModel.fromJson(i)).toList();

    return ProductListResponse(productModel: data);
  }
}
