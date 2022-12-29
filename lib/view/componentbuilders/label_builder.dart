import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildLabel({required BuildContext context, required text}) {
  return text != null
      ? Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text ?? "",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .color!
                        .withOpacity(0.35),
                  ),
                ),
          ),
        )
      : SizedBox();
}
