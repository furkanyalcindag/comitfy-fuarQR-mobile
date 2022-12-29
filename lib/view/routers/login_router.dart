import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/view/auth/login_page.dart';
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
    /*await readAuthManager.fetchUserLogin();
    if (readAuthManager.isLogin) {
      await Future.delayed(const Duration(seconds: 1));
      Get.off(() => RouterLogged());
    } else {
      Get.off(() => RouterPage());
    }*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.off(() => LoginPage());
    });
  }

  // Using getter to allow access those providers
  // ModuleManager get readModuleManager => context.read<ModuleManager>();

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
