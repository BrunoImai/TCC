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

import 'package:tcc_front/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:tcc_front/src/features/core/screens/assistance/assistance.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/company_home_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/login/login_screen.dart';
import '../../../authentication/screens/signup/central.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../worker/worker.dart';

class UpdateAssistanceScreen extends StatefulWidget {
  const UpdateAssistanceScreen({super.key, required this.assistance});
  final AssistanceResponse assistance;
  
  @override
  _UpdateAssistanceScreenState createState() => _UpdateAssistanceScreenState();
}

class _UpdateAssistanceScreenState extends State<UpdateAssistanceScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController assistanceNameController = TextEditingController();
  final TextEditingController clientCpfController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressComplementController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();



  bool _isAddressFieldEnabled = true;
  bool _isWorkerExpanded = false;
  bool _isPeriodExpanded = false;
  List<WorkersList> workers = [];
  List<WorkersList> selectedWorkers = [];
  String? selectedPeriod;
  String error = "";

  @override
  void initState() {
    super.initState();
    assistanceNameController.text = widget.assistance.name;
    clientCpfController.text = widget.assistance.cpf;
    //addressComplementController.text = widget.assistance.complement;

    List<String> addressParts = widget.assistance.address.split(', ');
    addressController.text = addressParts[0];
    String numberNeighborhood = addressParts[1];
    String cityState = addressParts[2];
    cepController.text = addressParts[3];

    List<String> numberNeighborhoodList = numberNeighborhood.split(' - ');
    numberController.text = numberNeighborhoodList[0];
    neighborhoodController.text = numberNeighborhoodList[1];

    List<String> cityStateList = cityState.split(' - ');
    cityController.text = cityStateList[0];
    stateController.text = cityStateList[1];
  }

  bool _clearFieldassistanceName = false;
  bool _clearFieldCpf = false;

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
  

  @override
  Widget build(BuildContext context) {
    Future<void> updateassistance(VoidCallback onSuccess) async {
      String assistanceName = assistanceNameController.text;
      String clientCpf = clientCpfController.text;
      String cep = cepController.text;
      String address = addressController.text;
      String number = numberController.text;
      String addressComplement = addressComplementController.text;
      String city = cityController.text;
      String state = stateController.text.toUpperCase();
      String neighborhood = neighborhoodController.text;
      List<num> workersIds = selectedWorkers.map((worker) => worker.id).toList();


      if (assistanceName.isEmpty ||
          description.isEmpty ||
          clientCpf.isEmpty ||
          cep.isEmpty ||
          address.isEmpty ||
          number.isEmpty ||
          city.isEmpty ||
          state.isEmpty ||
          neighborhood.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome completo, celular, email, cpf, cep, endereço, número, bairro, cidade e estado são obrigatórios.');
          },
        );
        return;
      }

      if (assistanceName.length == 1) {
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

      if (clientCpfController.text.replaceAll(RegExp(r'\D'), '').length != 11) {
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


      if (cepController.text.replaceAll(RegExp(r'\D'), '').length != 8) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O CEP deve conter 8 dígitos');
          },
        );
        return;
      }

      if (state.length != 2 || !RegExp(r'^[a-zA-Z]{2}$').hasMatch(state)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
              errorDescription: 'Insira a sigla do seu estado, com duas letras.',
            );
          },
        );
        return;
      }


      String fullAddress = "$address, $number - $neighborhood, $city - $state, $cep";

      UpdateAssistanceRequest updateAssistanceRequest = UpdateAssistanceRequest(
        description: description,
        name: assistanceName,
        address: fullAddress,
        cpf: clientCpf,
        //complement: addressComplement,
        period: period, 
        workersIds: workersIds
      );

      String requestBody = jsonEncode(updateAssistanceRequest.toJson());

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/central/assistance/${widget.assistance.id}'),
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

          error = response.body;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertPopUp(
                  errorDescription: error);
            },
          );
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    }

    Future<void> deleteassistance() async {

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/central/assistance/${widget.assistance.id}'),
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
        title: Text(editAssistance, style: Theme.of(context).textTheme.headline4),
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
                      controller: assistanceNameController,
                      decoration: InputDecoration(
                        labelText: fullName,
                        prefixIcon: const Icon(LineAwesomeIcons.user),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldassistanceName = true;
                              if (_clearFieldassistanceName) {
                                assistanceNameController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: clientCpfController,
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
                                clientCpfController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: cepController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: '#####-###',),
                      ],
                      decoration: const InputDecoration(
                          label: Text(cep),
                          prefixIcon: Icon(Icons.local_post_office)
                      ),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                          label: Text(address),
                          prefixIcon: Icon(Icons.location_on)
                      ),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: numberController,
                      decoration: const InputDecoration(
                          label: Text(number),
                          prefixIcon: Icon(Icons.numbers)
                      ),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: addressComplementController,
                      decoration: const InputDecoration(
                          label: Text(addressComplement),
                          prefixIcon: Icon(Icons.home_rounded)
                      ),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: neighborhoodController,
                      decoration: const InputDecoration(
                          label: Text(neighborhood),
                          prefixIcon: Icon(Icons.holiday_village_rounded)
                      ),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                          label: Text(city),
                          prefixIcon: Icon(Icons.location_on)),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: stateController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                          label: Text(state),
                          prefixIcon: Icon(Icons.location_on)
                      ),
                      enabled: _isAddressFieldEnabled,
                    ),
                    const SizedBox(height: formHeight - 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPeriodExpanded = !_isPeriodExpanded;
                        });
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Período',
                          prefixIcon: Icon(Icons.access_time),
                          suffixIcon: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Icon(
                              _isPeriodExpanded ? LineAwesomeIcons.angle_up : LineAwesomeIcons.angle_down, // Changed the icon based on _isPeriodExpanded
                            ),
                          ),
                        ),
                        child: Text(selectedPeriod ?? ''), // Show selected period
                      ),
                    ),

                    // Show the menu options if expanded
                    if (_isPeriodExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text('Matutino', style: Theme.of(context).textTheme.bodyText2),
                            onTap: () {
                              setState(() {
                                selectedPeriod = 'Matutino';
                                _isPeriodExpanded = false; // Close the menu after selection
                              });
                            },
                          ),
                          ListTile(
                            title: Text('Vespertino', style: Theme.of(context).textTheme.bodyText2),
                            onTap: () {
                              setState(() {
                                selectedPeriod = 'Vespertino';
                                _isPeriodExpanded = false; // Close the menu after selection
                              });
                            },
                          ),
                          ListTile(
                            title: Text('Noturno', style: Theme.of(context).textTheme.bodyText2),
                            onTap: () {
                              setState(() {
                                selectedPeriod = 'Noturno';
                                _isPeriodExpanded = false; // Close the menu after selection
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: formHeight - 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isWorkerExpanded = !_isWorkerExpanded;
                        });
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          label: const Text('Funcionários'),
                          prefixIcon: const Icon(Icons.person_search),
                          suffixIcon: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: IconButton(
                              icon: Icon(
                                _isWorkerExpanded ? LineAwesomeIcons.angle_up : LineAwesomeIcons.angle_down,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isWorkerExpanded = !_isWorkerExpanded;
                                });
                              },
                            ),
                          ),
                        ),
                        child: Text(
                          selectedWorkers.isEmpty
                              ? ''
                              : selectedWorkers.map((worker) => worker.name).join(', '),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (_isWorkerExpanded)
                      Column(
                        children: workers.map((worker) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedWorkers.contains(worker)) {
                                  selectedWorkers.remove(worker);
                                } else {
                                  selectedWorkers.add(worker);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                      color: selectedWorkers.contains(worker) ? Colors.green : Colors.transparent,
                                      border: Border.all(color: selectedWorkers.contains(worker) ? Colors.transparent : primaryColor),
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: selectedWorkers.contains(worker)
                                      ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: whiteColor,
                                        size: 10,
                                      )
                                  )
                                      : null,
                                ),
                                const SizedBox(width: formHeight - 25),
                                Text(worker.name, style: Theme.of(context).textTheme.bodyText2),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: formHeight),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          if (cellphone.isEmpty ||
                              email.isEmpty ||
                              clientCpf.isEmpty ||
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
                            updateassistance(() {
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
                                  text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.assistance.orderDate)),
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
                                child: Text("Tem certeza que deseja excluir esse assistancee?"),
                              ),
                              confirm: Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteassistance();
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