import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuar_qr/core/config/app_config.dart';
import 'package:fuar_qr/core/services/authentication/login_manager.dart';
import 'package:fuar_qr/core/utility/cache_manager.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/view/componentbuilders/textfield_builder.dart';
import 'package:fuar_qr/view/routers/login_router.dart';
import 'package:get/route_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with CacheManager {
  late final LoginService loginService;
  late final TextEditingController _emailTextFieldController;
  late final TextEditingController _passwordTextFieldController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isAbleToPushButton = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailTextFieldController = TextEditingController();
    _passwordTextFieldController = TextEditingController();
    loginService = LoginService();
  }

  Future<void> fetchUserLogin(String email, String password) async {
    setState(() {
      _isAbleToPushButton = false;
    });
    final _loginUrl =
        AppConfig.of(context)!.baseURL + AppConfig.of(context)!.loginPath;
    final response = await loginService.fetchLogin(_loginUrl, email, password);
    if (response!.exception == null) {
      saveToken(response.token ?? '');
      String successMsg = AppLocalizations.of(context)!.success;
      Fluttertoast.showToast(
          msg: successMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          textColor: Colors.green,
          fontSize: 16.0);
      Get.off(() => LoginRouter());
    } else {
      String errorMsg = AppLocalizations.of(context)!.errorLogin;
      Fluttertoast.showToast(
          msg: errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          textColor: Colors.red,
          fontSize: 16.0);
      setState(() {
        _isAbleToPushButton = true;
      });
    }
  }

  void changeButton() async {
    setState(() {
      _isAbleToPushButton = false;
    });
    await fetchUserLogin(
        _emailTextFieldController.text, _passwordTextFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
                stops: const [
                  0.5,
                  1,
                ]),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.login,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline4!.merge(
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                const Divider(
                  color: primary,
                  height: 10,
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        labelText: AppLocalizations.of(context)!.email,
                        context: context,
                        controller: _emailTextFieldController,
                        validator: (value) {
                          if (value!.isEmpty == true) {
                            return AppLocalizations.of(context)!
                                .errorEmailEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextField(
                        labelText: AppLocalizations.of(context)!.password,
                        context: context,
                        controller: _passwordTextFieldController,
                        isPassword: true,
                        showPassword: _isPasswordVisible,
                        suffixIcon: IconButton(
                          splashRadius: 1,
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of _isPasswordVisible variable
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value!.isEmpty == true) {
                            return AppLocalizations.of(context)!.errorPassEmpty;
                          }
                          if (value.length < 8) {
                            return AppLocalizations.of(context)!
                                .errorPassLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      _isAbleToPushButton
                          ? ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  return changeButton();
                                }
                              },
                              child: Text(AppLocalizations.of(context)!.login),
                            )
                          : Opacity(
                              opacity: 0.5,
                              child: ElevatedButton(
                                onPressed: () => {},
                                child:
                                    Text(AppLocalizations.of(context)!.loading),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.transparent,
            child: Text(
              "Comitfy",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .merge(TextStyle(color: primary)),
            ),
          ),
        ),
      ]),
    );
  }
}
