// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fuar_qr/view/componentbuilders/label_builder.dart';

Widget buildTextField(
    {required BuildContext context,
    required TextEditingController controller,
    String? labelText,
    String? hintText}) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 600),
    child: Column(
      children: [
        buildLabel(context: context, text: labelText),
        Material(
          borderRadius: BorderRadius.circular(100),
          elevation: 20,
          shadowColor: Colors.black.withOpacity(0.5),
          child: TextField(
            controller: controller,
            autocorrect: false,
            style: Theme.of(context).textTheme.subtitle1!,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .merge(TextStyle(color: Colors.black.withOpacity(0.35))),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              icon: Container(
                  width: 15,
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(Icons.usb_rounded)),
            ),
          ),
        ),
      ],
    ),
  );
}
