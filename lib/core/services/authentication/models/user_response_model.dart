import 'package:fuar_qr/core/services/exception/models/exception_model.dart';

class UserResponseModel {
  String? token;
  String? roles;
  String? gender;
  ExceptionModel? exception;

  UserResponseModel({this.token, this.exception});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['jwt-token'];
    roles = json['roles'];
    gender = json['gender'];
    exception = json['exception'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['jwt-token'] = token;
    data['roles'] = roles;
    data['gender'] = gender;
    data['exception'] = exception;
    return data;
  }
}
