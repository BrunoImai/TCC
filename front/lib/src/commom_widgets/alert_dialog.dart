import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/features/authentication/screens/login/login_screen.dart';
import 'package:tcc_front/src/features/authentication/screens/welcome/who_are_you_screen.dart';
import 'package:tcc_front/src/features/core/screens/client/register_client_screen.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker_list_screen.dart';

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
                      builder: (context) => const WhoAreYouScreen()));
            } else if (errorDescription == 'Email do cliente já cadastrado!' || errorDescription == 'CPF do cliente já cadastrado!') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientListScreen()));
            } else if (errorDescription == 'Cliente não encontrado.') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterClientScreen()));
            }else if (errorDescription == 'Email já cadastrado!' || errorDescription ==  "CPF do funcionário já cadastrado!"){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkerListScreen()));
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