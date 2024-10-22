import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tcc_front/src/features/authentication/screens/signup/central.dart';
import 'package:tcc_front/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/features/authentication/screens/welcome/who_are_you_screen.dart';
import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../../commom_widgets/authentication_appbar.dart';
import '../login/login_screen.dart';


class UpdatePasswordScreen extends StatefulWidget {
  final String code;
  const UpdatePasswordScreen({super.key, required this.code});

  @override
  _UpdatePasswordScreen createState() => _UpdatePasswordScreen();

}


class _UpdatePasswordScreen extends State<UpdatePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  bool _isVisiblePassword = false;
  bool _isVisibleConfirmPassword = false;
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
    String newPassword = passwordController.text;
    if (kDebugMode) {
      print(widget.code);
    }


    Future<void> resetPassword(VoidCallback onSuccess) async {
      if (newPassword.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      ResetCentralPassword resetCentralPassword = ResetCentralPassword(password: newPassword, token: widget.code);

      String requestBody = jsonEncode(resetCentralPassword.toJson());

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/login/resetPassword'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print("Token validated");
        } else {
          print('Update failed. Status code: ${response.statusCode}');
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
                  title: tUpdatePasswordTitle.toUpperCase(),
                  subTitle: tUpdatePasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: formHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: passwordController,
                        onChanged: (passwordController) => onPasswordChanged(passwordController),
                        obscureText: !_isVisiblePassword,
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
                          labelText: tPassword,
                          hintText: tPassword,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisiblePassword = !_isVisiblePassword;
                              });
                            },
                            icon: _isVisiblePassword ? const Icon(Icons.visibility) :
                            const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: formHeight - 29),
                      Visibility(
                        visible: _passwordFocusNode.hasFocus,
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
                                Text(tNumberOfCharacters, style: Theme.of(context).textTheme.overline)
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
                                Text(tNumberCharacter, style: Theme.of(context).textTheme.overline)
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
                                Text(tLowerCaseCharacter, style: Theme.of(context).textTheme.overline)
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
                                Text(tUppercaseCharacter, style: Theme.of(context).textTheme.overline)
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
                                Text(tSpecialCharacter, style: Theme.of(context).textTheme.overline)
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: formHeight - 20),
                      TextFormField(
                        controller: confirmPasswordController,
                        onChanged: (confirmPasswordController) => onPasswordChanged(confirmPasswordController),
                        obscureText: !_isVisibleConfirmPassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.fingerprint),
                          labelText: tConfirmPassword,
                          hintText: tConfirmPassword,
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisibleConfirmPassword = !_isVisibleConfirmPassword;
                              });
                            },
                            icon: _isVisibleConfirmPassword ? const Icon(Icons.visibility) :
                            const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                String password = passwordController.text;
                                String confirmPassword = confirmPasswordController.text;

                                if (password.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertPopUp(
                                          errorDescription: 'Todos os campos são obrigatórios.');
                                    },
                                  );
                                  return;
                                }

                                if (password != confirmPassword) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertPopUp(
                                          errorDescription: 'As senhas não coincidem ');
                                    },
                                  );
                                } else {
                                  resetPassword(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const WhoAreYouScreen()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Senha alterada')),
                                    );
                                  });
                                }
                              },
                              child: Text(tNext.toUpperCase())
                          )
                      ),
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

