import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import 'package:tcc_front/src/features/authentication/screens/welcome/welcome_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController centralController = TextEditingController(text: CentralManager.instance.loggedUser!.central.name);
  final TextEditingController emailController = TextEditingController(text: CentralManager.instance.loggedUser!.central.email);
  final TextEditingController cnpjController = TextEditingController(text: CentralManager.instance.loggedUser!.central.cnpj);
  final TextEditingController cellphoneController = TextEditingController(text: CentralManager.instance.loggedUser!.central.cellphone);
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _clearFieldCentral = false;
  bool _clearFieldEmail = false;
  bool _clearFieldCnpj = false;
  bool _clearFieldCellphone = false;
  bool _clearFieldCurrentPassword = false;
  bool _showNewPassword = false;

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  final FocusNode _passwordFocusNode = FocusNode();
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
    Future<void> updateCentral(VoidCallback onSuccess) async {
      String central = centralController.text;
      String cellphone = cellphoneController.text;
      String email = emailController.text;
      String cnpj = cnpjController.text;
      String currentPassword = currentPasswordController.text;
      String? newPassword = newPasswordController.text;
      num id = CentralManager.instance.loggedUser!.central.id;

      if (central.isEmpty ||
          cellphone.isEmpty ||
          email.isEmpty ||
          currentPassword.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      if (central.length == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O nome deve conter mais que um carácter');
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

      if (cnpjController.text.replaceAll(RegExp(r'\D'), '').length != 14) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número do CNPJ deve conter exatamente 14 dígitos.');
          },
        );
        return;
      }

      if (cellphoneController.text.replaceAll(RegExp(r'\D'), '').length < 10) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número de telefone deve conter no mínimo 10 dígitos, incluindo o DDD.');
          },
        );
        return;
      }

      if (newPassword == "") {
        newPassword = null;
      }

      UpdateCentralRequest updateCentralRequest = UpdateCentralRequest(
          name: central,
          email: email,
          cnpj: cnpj,
          cellphone: cellphone,
          oldPassword: currentPassword,
          newPassword : newPassword
      );

      String requestBody = jsonEncode(updateCentralRequest.toJson());
      print(requestBody);
      print("\n" + id.toString());
      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/central/update/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registration successful!');
        } else {
          print('Registration failed. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    }

    Future<void> deleteCentral() async {
      num id = CentralManager.instance.loggedUser!.central.id;

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/central/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          Navigator.pop(context, true);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(editProfile, style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(userProfileImage))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: primaryColor),
                        child: const Icon(LineAwesomeIcons.camera, color: Colors.black, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: centralController,
                      decoration: InputDecoration(
                        labelText: central,
                        prefixIcon: const Icon(LineAwesomeIcons.user),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldCentral = true;
                              if (_clearFieldCentral) {
                                centralController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: email,
                        prefixIcon: const Icon(LineAwesomeIcons.envelope_1),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldEmail = true;
                              if (_clearFieldEmail) {
                                emailController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: cnpjController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: '##.###.###/####-##',),
                      ],
                      decoration: InputDecoration(
                        labelText: cnpj,
                        prefixIcon: const Icon(Icons.numbers),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldCnpj = true;
                              if (_clearFieldCnpj) {
                                cnpjController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: cellphoneController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: '(##) #####-####',),
                      ],
                      decoration: InputDecoration(
                        labelText: cellphone,
                        prefixIcon: const Icon(LineAwesomeIcons.phone),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldCellphone = true;
                              if (_clearFieldCellphone) {
                                cellphoneController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: currentPassword,
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _showNewPassword = true;
                              _clearFieldCurrentPassword = true;
                              currentPasswordController.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    Visibility(
                      visible: _showNewPassword,
                      child: TextFormField(
                        controller: newPasswordController,
                        onChanged: (newPasswordController) => onPasswordChanged(newPasswordController),
                        obscureText: true,
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
                          labelText: newPassword,
                          prefixIcon: const Icon(Icons.fingerprint),
                          suffixIcon: IconButton(
                            icon: const Icon(LineAwesomeIcons.angle_up),
                            onPressed: () {
                              setState(() {
                                _showNewPassword = false;
                                newPasswordController.clear();
                              });
                            },
                          ),
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
                          const SizedBox(height: formHeight - 29)
                        ],
                      ),
                    ),
                    const SizedBox(height: formHeight),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String currentPassword = currentPasswordController.text;
                          String newPassword = newPasswordController.text;

                          if (central.isEmpty ||
                              cellphone.isEmpty ||
                              email.isEmpty ||
                              currentPassword.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertPopUp(
                                    errorDescription: 'Todos os campos são obrigatórios.');
                              },
                            );
                            return;
                          }


                          if (newPassword.isNotEmpty &&
                              currentPassword == newPassword) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertPopUp(
                                    errorDescription: 'A nova senha não pode ser igual a antiga');
                              },
                            );
                          } else {
                            updateCentral(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WelcomeScreen())
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Atualização Realizada')),
                              );
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: Text(editProfile.toUpperCase(),style: const TextStyle(color: darkColor)),
                      ),
                    ),
                    const SizedBox(height: formHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: joined,
                            style: const TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: DateFormat('dd/MM/yyyy').format(DateTime.parse(CentralManager.instance.loggedUser!.central.creationDate)),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: delete.toUpperCase(),
                              titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              content: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Text("Tem certeza que deseja excluir o seu perfil?"),
                              ),
                              confirm: Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteCentral();
                                    Get.to(const WelcomeScreen());
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                                  child: const Text("Sim"),
                                ),
                              ),
                              cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("Não")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text(delete),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
