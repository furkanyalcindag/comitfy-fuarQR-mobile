import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/cache_manager.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/view/auth/login_page.dart';
import 'package:fuar_qr/view/home/home.dart';
import 'package:fuar_qr/view/routers/authentication_manager.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LoginRouter extends StatefulWidget {
  @override
  _LoginRouterState createState() => _LoginRouterState();
}

class _LoginRouterState extends State<LoginRouter> {
  /// CONTROL THE APP LOCAL STORAGE
  Future<void> controlToApp() async {
    // LOGIN CHECK
    await readAuthManager.fetchUserLogin();
    if (readAuthManager.isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => Home());
      });
    } else {
      Get.off(() => LoginPage());
    }
  }

  // Using getter to allow access those providers
  AuthenticationManager get readAuthManager =>
      context.read<AuthenticationManager>();

  @override
  void initState() {
    super.initState();
    controlToApp();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: primary,
      )),
    );
  }
}
