import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:tcc_front/src/features/authentication/screens/forget_password/forget_password_screen.dart';
import 'package:tcc_front/src/features/authentication/screens/signup/central_manager.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/company_home_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../signup/central.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool _isVisible = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    Future<void> centralLogin(VoidCallback onSuccess) async {
      String email = emailController.text;
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      CentralLoginRequest centralLoginRequest =
          CentralLoginRequest(email: email, password: password);
      String requestBody = jsonEncode(centralLoginRequest.toJson());
      try {
        print("Fiz o post");
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final jsonData = json.decode(response.body);
          final token = jsonData['token'];

          final central = CentralResponse.fromJson(jsonData['central']);

          CentralManager.instance.loggedUser = LoggedCentral(token, central);
          onSuccess.call();
        } else {
          // Registration failed
          print('Login failed. Status code: ${response.statusCode}');

          error = response.body;
          print(error);
        }
      } catch (e) {
        // Handle any error that occurred during the HTTP request
        print('Error occurred: $e');
      }
    }

    return Form(
      key: _loginFormKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: email,
                  hintText: email,
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: passwordController,
              obscureText: !_isVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: password,
                hintText: password,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: formHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () =>
                      Get.to(() => const ForgetPasswordMailScreen()),
                  child: const Text(forgetPassword)),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    centralLogin(() {
                      if (!mounted) {
                        print("mounted");
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompanyHomeScreen()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Realizado')),
                      );
                    });
                  } else {
                    print("Popup");
                    AlertPopUp(
                        errorDescription: error);
                  }
                },
                child: Text(login.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
