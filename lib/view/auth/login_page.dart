import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/core/utility/theme_choice.dart';
import 'package:fuar_qr/view/componentbuilders/textfield_builder.dart';
import 'package:fuar_qr/view/home/home.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailTextFieldController;

  @override
  void initState() {
    super.initState();
    emailTextFieldController = TextEditingController();
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(
                  height: 60,
                ),
                Column(
                  children: [
                    buildTextField(
                      labelText: AppLocalizations.of(context)!.email,
                      context: context,
                      controller: emailTextFieldController,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    buildTextField(
                      labelText: AppLocalizations.of(context)!.password,
                      context: context,
                      controller: emailTextFieldController,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        Get.off(() => Home()),
                      },
                      child: Text(AppLocalizations.of(context)!.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
