import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/company_home_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import 'package:http/http.dart' as http;
import 'central.dart';
import 'central_manager.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
  });

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();

}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController centralController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  bool isValidEmail(String email) {
    final emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordUppercase = false;
  bool _hasPasswordLowercase = false;
  bool _hasPasswordSpecialCharacters = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final upperRegex = RegExp(r'[A-Z]');
    final lowerRegex = RegExp(r'[a-z]');
    final specialRegex = RegExp(r'[@$!%*?&]');

    setState(() {
      _isPasswordEightCharacters = false;
      if(password.length >= 8)
        _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if(numericRegex.hasMatch(password))
        _hasPasswordOneNumber = true;

      _hasPasswordUppercase = false;
      if(upperRegex.hasMatch(password))
        _hasPasswordUppercase = true;

      _hasPasswordLowercase = false;
      if(lowerRegex.hasMatch(password))
        _hasPasswordLowercase = true;

      _hasPasswordSpecialCharacters = false;
      if(specialRegex.hasMatch(password))
        _hasPasswordSpecialCharacters = true;

    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> registerUser(VoidCallback onSuccess) async {
      String central = centralController.text;
      String cellphone = cellphoneController.text;
      String email = emailController.text;
      String cnpj = cnpjController.text;
      String password = passwordController.text;

      if (central.isEmpty ||
          cellphone.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      if (!isValidEmail(email)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O email inserido é inválido.');
          },
        );
        return;
      }

      if (cellphone.length > 12 || cellphone.length < 7 || !cellphone.contains(RegExp(r'^[0-9]*$'))) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número de telefone deve ser válido. Lembre-se de inserir o DDD.');
          },
        );
        return; 
      }

      CentralRequest centralRequest = CentralRequest(
          name: central,
          email: email,
          cnpj: cnpj,
          cellphone: cellphone,
          password: password
      );

      String requestBody = jsonEncode(centralRequest.toJson());

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        final jsonData = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registration successful
          final token = jsonData['token'];
          final central = CentralResponse.fromJson(jsonData['central']);

          CentralManager.instance.loggedUser =
              LoggedCentral(token, central);
          onSuccess.call();
          print('Registration successful!');
        } else {
          print('Registration failed. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: centralController,
              decoration: const InputDecoration(
                  label: Text(central),
                  prefixIcon: Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  label: Text(email), prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cnpjController,
              decoration: const InputDecoration(
                  label: Text(cnpj), prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cellphoneController,
              decoration: const InputDecoration(
                  label: Text(cellphone), prefixIcon: Icon(Icons.phone_android)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: passwordController,
              onChanged: (passwordController) => onPasswordChanged(passwordController),
              obscureText: !_isVisible,
              focusNode: _passwordFocusNode,
              onTap: () {
                setState(() {
                  _isPasswordEightCharacters = false;
                  _hasPasswordOneNumber = false;
                  _hasPasswordLowercase = false;
                  _hasPasswordUppercase = false;
                  _hasPasswordSpecialCharacters = false;
                });
              },
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
                  icon: _isVisible ? const Icon(Icons.visibility) :
                  const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: formHeight - 29),
            Visibility(
              visible: _passwordFocusNode.hasFocus, // Showing validations only when the password field is focused
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: formHeight - 20),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters ? Colors.green : Colors.transparent,
                            border: _isPasswordEightCharacters ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check, color: whiteColor, size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(numberOfCharacters, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber ? Colors.green : Colors.transparent,
                            border: _hasPasswordOneNumber ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                            child: Icon(
                              Icons.check,
                              color: whiteColor,
                              size: 10,
                            )
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(numberCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordLowercase ? Colors.green : Colors.transparent,
                            border: _hasPasswordLowercase ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(lowercaseCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordUppercase ? Colors.green : Colors.transparent,
                            border: _hasPasswordUppercase ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(uppercaseCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordSpecialCharacters ? Colors.green : Colors.transparent,
                            border: _hasPasswordSpecialCharacters ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(specialCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: confirmPasswordController,
              onChanged: (confirmPasswordController) => onPasswordChanged(confirmPasswordController),
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
                  icon: _isVisible ? const Icon(Icons.visibility) :
                  const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (password != confirmPassword) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertPopUp(
                            errorDescription: 'As senhas não coincidem ');
                      },
                    );
                  } else {
                    registerUser(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CompanyHomeScreen()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Realizado')),
                      );
                    });
                  }
                },
                child: Text(signUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
