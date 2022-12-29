import 'package:flutter/material.dart';
import 'package:fuar_qr/core/services/user/models/user.dart';
import 'package:fuar_qr/core/utility/cache_manager.dart';

class AuthenticationManager extends CacheManager {
  BuildContext context;

  AuthenticationManager({
    required this.context,
  }) {
    fetchUserLogin();
  }

  bool isLogin = false;
  User? model;

  void removeAllData() {}

  Future<void> fetchUserLogin() async {
    final token = await getToken();
    if (token != null) {
      isLogin = true;
    }
  }
}
