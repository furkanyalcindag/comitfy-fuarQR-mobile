import 'dart:async';
import 'dart:convert';
import 'package:fuar_qr/core/services/authentication/models/user_response_model.dart';
import 'package:fuar_qr/core/services/exception/models/exception_model.dart';
import 'package:fuar_qr/core/utility/cache_manager.dart';

import 'package:http/http.dart' as http;

class LoginService extends CacheManager {
  Future<UserResponseModel?> fetchLogin(
      String path, String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    String body = json.encode(data);
    var response = await http.post(
      Uri.parse(path),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );
    var responseJson = await json.decode(response.body);
    UserResponseModel user = UserResponseModel.fromJson(responseJson);
    ExceptionModel exception = ExceptionModel.fromJson(responseJson);
    if (response.statusCode == 200) {
      return user;
    } else {
      user.exception = exception;
      user.exception!.statusCode = response.statusCode;
      return user;
    }
  }
  
}
