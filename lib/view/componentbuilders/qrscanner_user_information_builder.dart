// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/view/componentbuilders/label_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildQrCodeUserInfo({
  required BuildContext context,
  required Map<String, String> info,
}) {
  List<TextSpan> widgets = [];
  info.forEach(
    (key, value) {
      widgets.add(
        // Title
        TextSpan(
          text: "$key\n",
          style: Theme.of(context).textTheme.subtitle1!.merge(
                const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
          children: [
            // Value
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.subtitle1!.merge(
                    const TextStyle(
                      color: white,
                    ),
                  ),
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
