import 'package:flutter/material.dart';

//Environment flavor config
class AppConfig extends InheritedWidget {
  const AppConfig({
    Key? key,
    required this.appDisplayName,
    required this.appInternalId,
    required this.baseURL,
    required this.loginPath,
    required Widget child,
  }) : super(key: key, child: child);

  final String appDisplayName;
  final int appInternalId;
  final String baseURL;
  final String loginPath;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
