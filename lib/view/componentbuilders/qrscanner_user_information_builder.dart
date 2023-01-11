// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/view/componentbuilders/label_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildQrCodeUserInfo({
  required BuildContext context,
  required Map<String, String> info,
  Color? textColor,
}) {
  List<TextSpan> widgets = [];
  info.forEach(
    (key, value) {
      widgets.add(
        // Title
        TextSpan(
          text: "$key\n",
          style: Theme.of(context).textTheme.subtitle1!.merge(
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor ?? white,
                ),
              ),
          children: [
            // Value
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.subtitle1!.merge(
                    TextStyle(
                      color: textColor ?? white,
                    ),
                  ),
            ),
            WidgetSpan(
              child: Divider(),
            ),
          ],
        ),
      );
    },
  );

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(children: widgets),
  );
}
