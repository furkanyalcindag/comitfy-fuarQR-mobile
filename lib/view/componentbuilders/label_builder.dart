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
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        )
      : SizedBox();
}
