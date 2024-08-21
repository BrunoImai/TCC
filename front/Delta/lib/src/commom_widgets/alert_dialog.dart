import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/colors.dart';

class AlertPopUp extends StatelessWidget {
  const AlertPopUp({
    super.key,
    required this.errorDescription,
    this.onConfirmed,
  });

  final String errorDescription;
  final VoidCallback? onConfirmed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(Icons.warning_rounded, color: primaryColor, size: 30),
      content: Text(errorDescription),
      actions: [
        TextButton(
          onPressed: () {
            if (onConfirmed != null) {
              onConfirmed!();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'OK',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}