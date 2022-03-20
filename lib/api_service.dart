import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import '../../config.dart';
import 'modules/product_model.dart';

class APIService {
  static var client = http.Client();

  static Future<List<ProductModel>?> getProducts() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    developer.log('testing');
    var url = Uri.http(
      Config.apiURL,
      Config.productsAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    developer.log('testing2');
    developer.log(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return productsFromJson(data["data"]);

      //return true;
    } else {
      return null;
    }
  }

  static Future<bool> saveProduct(
    ProductModel model,
    bool isEditMode,
    bool isFileSelected,
  ) async {
    var productURL = Config.productsAPI;

    if (isEditMode) {
      productURL = productURL + "/" + model.id.toString();
    }

    var url = Uri.http(Config.apiURL, productURL);

    var requestMethod = isEditMode ? "PUT" : "POST";

    var request = http.MultipartRequest(requestMethod, url);
    request.fields["productName"] = model.productName!;
    request.fields["productDescription"] = model.productDescription!.toString();

    if (model.productImage != null && isFileSelected) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'productImage',
        model.productImage!,
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteProduct(productId) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.productsAPI + "/" + productId,
    );

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
