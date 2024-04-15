import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/colors.dart';

class AlertPopUp extends StatelessWidget {
  const AlertPopUp({super.key, required this.errorDescription});

  final String errorDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(Icons.warning_rounded, color: primaryColor),

      /*title: const Text(
        'Erro',
        style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold),
      ),*/
      content: Text(errorDescription),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'OK',
            style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}