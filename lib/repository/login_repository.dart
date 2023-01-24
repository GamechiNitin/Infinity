import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:infinity_box/utils/api_string.dart';

class LoginRepository {
  Future<String?> logIn({required String name, required String cred}) async {
    final response = await http.post(Uri.parse(ApiString.logInUrl), body: {
      "username": name,
      "password": cred,
    });

    log(response.request.toString());
    log(response.body.toString());
    log(response.statusCode.toString());
    try {
      if (response.statusCode == 200) {
        String? token;
        final res = jsonDecode(response.body);
        token = res['token'];
        return token;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<int?> createAccount({
    required String name,
    required String cred,
    required String email,
  }) async {
    final response =
        await http.post(Uri.parse(ApiString.createAccountUrl), body: {
      "username": name,
      "password": cred,
      "email": email,
    });

    log(response.request.toString());
    log(response.body.toString());
    log(response.statusCode.toString());
    try {
      if (response.statusCode == 200) {
        int? token;
        final res = jsonDecode(response.body);
        token = res['id'];
        return token;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
