// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fuar_qr/core/config/app_config.dart';
import 'package:fuar_qr/core/utility/theme_notifier.dart';
import 'package:fuar_qr/view/routers/authentication_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mainCommon.dart';

void main() {
  var configuredApp = AppConfig(
    appDisplayName: "Fuar Denetleyicisi",
    appInternalId: 1,
    baseURL: 'http://89.252.140.57:8081',
    loginPath: '/auth/login',
    participantValidatePath: '/fair-participant/validate-participant/',
    child: MyApp(),
  );
  // Provides firebase and internet connection
  mainCommon();

  SharedPreferences.getInstance().then((prefs) {
    var themeMode = prefs.getInt('themeMode') ?? 0;
    /* 0 = ThemeMode.system
       1 = ThemeMode.light
       2 = ThemeMode.dark
    */

    runApp(MultiProvider(
      providers: [
        Provider<AuthenticationManager>(
          create: (context) => AuthenticationManager(context: context),
        ),
        ChangeNotifierProvider<ThemeModeNotifier>(
          create: (_) => ThemeModeNotifier(ThemeMode.values[themeMode]),
        ),
      ],
      child: configuredApp,
    ));
  });
}
