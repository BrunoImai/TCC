import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/features/authentication/screens/login/login_screen.dart';

import '../features/core/screens/client/client_list_screen.dart';

class AlertPopUp extends StatelessWidget {
  const AlertPopUp({super.key, required this.errorDescription});

  final String errorDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(Icons.warning_rounded, color: primaryColor, size: 30),

      content: Text(errorDescription),
      actions: [
        TextButton(
          onPressed: () {
            if (errorDescription == 'Email já cadastrado!' || errorDescription == 'CNPJ já cadastrado!') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            } else if (errorDescription == 'Email do cliente já cadastrado!' || errorDescription == 'CPF do cliente já cadastrado!') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientListScreen()));
            } else {Navigator.of(context).pop();}
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