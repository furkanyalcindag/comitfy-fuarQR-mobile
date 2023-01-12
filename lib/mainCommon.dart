import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fuar_qr/core/config/app_config.dart';
import 'package:fuar_qr/core/utility/theme_notifier.dart';
import 'package:fuar_qr/core/utility/themes.dart';
import 'package:fuar_qr/view/routers/login_router.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Initialize things like firebase, AD service, google services
void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Disable landcape
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  // final NotificationListenerProvider _notificationListenerProvider =
  //     NotificationListenerProvider();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    return GetMaterialApp(
      routes: {},
      debugShowCheckedModeBanner: false,
      title: AppConfig.of(context)!.appDisplayName,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: themeNotifier.getThemeMode(),
      supportedLocales: const [Locale('tr', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LoginRouter(),
    );
  }
}
