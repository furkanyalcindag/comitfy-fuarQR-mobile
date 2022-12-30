// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fuar_qr/view/componentbuilders/label_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildTextField({
  required BuildContext context,
  required TextEditingController controller,
  String? labelText,
  String? hintText,
  bool isPassword = false,
  required String? Function(String? value)? validator,
  Widget? suffixIcon,
  bool showPassword = false,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 600),
    child: Column(
      children: [
        buildLabel(context: context, text: labelText),
        Material(
          elevation: 20,
          color: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.2),
          child: TextFormField(
            obscureText: isPassword ? !showPassword : false,
            enableSuggestions: isPassword ? false : true,
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            controller: controller,
            style: Theme.of(context).textTheme.subtitle1!,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.circular(100),
              ),
              hintText: hintText,
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              hintStyle: Theme.of(context).textTheme.subtitle1!,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
              prefixIcon: Container(
                padding: EdgeInsets.only(left: 5),
                child: Icon(Icons.usb_rounded),
              ),
              suffixIcon: suffixIcon,
              /* enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(100),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(100),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(100),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(100),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(100),
              ), */
            ),
          ),
        ),
      ],
    ),
  );
}
