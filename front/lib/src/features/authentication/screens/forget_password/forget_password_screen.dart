import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../../commom_widgets/authentication_appbar.dart';
import '../signup/central.dart';
import 'otp_screen.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  _ForgetPasswordMailScreenState createState() => _ForgetPasswordMailScreenState();

}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final TextEditingController emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> sendToken(VoidCallback onSuccess) async {
      String email = emailController.text;

      if (email.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'É necessário fornecer seu email cadastrado para a recuperação de senha');
          },
        );
        return;
      }

      if (!isValidEmail(email)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O formato do email inserido é inválido.');
          },
        );
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/login/sendToken?email=$email'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print("Email enviado");
        } else {
          print('Email failed. Status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle any error that occurred during the HTTP request
        print('Error occurred: $e');
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: const WelcomeAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              children: [
                const SizedBox(height: defaultSize * 4),
                FormHeaderWidget(
                  image: forgetPasswordImage,
                  title: forgetPassword.toUpperCase(),
                  subTitle: forgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: formHeight),
                Form(
                  key: _emailFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            label: Text(email),
                            hintText: email,
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_emailFormKey.currentState!.validate()) {
                                  sendToken(() {
                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const OTPScreen(email: email,)),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Token enviado com sucesso!')),
                                    );
                                  });
                                }
                              },
                              child: Text(next.toUpperCase()))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

