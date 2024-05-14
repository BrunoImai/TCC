import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import 'package:tcc_front/src/features/core/screens/worker/worker.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/company_home_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class UpdateWorkerScreen extends StatefulWidget {
  const UpdateWorkerScreen({super.key, required this.worker});
  final WorkersList worker;
  
  @override
  _UpdateWorkerScreenState createState() => _UpdateWorkerScreenState();
}

class _UpdateWorkerScreenState extends State<UpdateWorkerScreen> {
  final TextEditingController workerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    workerController.text = widget.worker.name;
    emailController.text = widget.worker.email;
    cpfController.text = widget.worker.cpf;
    cellphoneController.text = widget.worker.cellphone;

  }

  bool _clearFieldWorkerName = false;
  bool _clearFieldEmail = false;
  bool _clearFieldCpf = false;
  bool _clearFieldCellphone = false;

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
  

  @override
  Widget build(BuildContext context) {
    Future<void> updateWorker(VoidCallback onSuccess) async {
      String workerName = workerController.text;
      String cellphone = cellphoneController.text;
      String email = emailController.text;
      String cpf = cpfController.text;

      if (workerName.isEmpty ||
          cellphone.isEmpty ||
          email.isEmpty ||
          cpf.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      if (workerName.length == 1) {
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

      if (cpfController.text.replaceAll(RegExp(r'\D'), '').length != 11) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número do CPF deve conter exatamente 11 dígitos.');
          },
        );
        return;
      }

      if (cellphoneController.text.replaceAll(RegExp(r'\D'), '').length != 11) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número de celular deve conter 11 dígitos, incluindo o DDD.');
          },
        );
        return;
      }


      UpdateWorkerRequest updateWorkerRequest = UpdateWorkerRequest(
        name: workerName,
        email: email,
        cpf: cpf,
        cellphone: cellphone,
      );

      String requestBody = jsonEncode(updateWorkerRequest.toJson());

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/central/worker/${widget.worker.id}'),
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

    Future<void> deleteWorker() async {

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/central/worker/${widget.worker.id}'),
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
        title: Text(editWorker, style: Theme.of(context).textTheme.headline4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              const Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Icon(LineAwesomeIcons.user_edit, color: primaryColor, size: 100),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: workerController,
                      decoration: InputDecoration(
                        labelText: fullName,
                        prefixIcon: const Icon(LineAwesomeIcons.user),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldWorkerName = true;
                              if (_clearFieldWorkerName) {
                                workerController.clear();
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
                      controller: cpfController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: '###.###.###-##',),
                      ],
                      decoration: InputDecoration(
                        labelText: cpf,
                        prefixIcon: const Icon(Icons.numbers),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldCpf = true;
                              if (_clearFieldCpf) {
                                cpfController.clear();
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

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
                            updateWorker(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CompanyHomeScreen())
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
                                  text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.worker.entryDate)),
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
                                child: Text("Tem certeza que deseja excluir esse workere?"),
                              ),
                              confirm: Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteWorker();
                                    Get.to(const CompanyHomeScreen());
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
