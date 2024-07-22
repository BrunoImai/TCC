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
import 'package:tcc_front/src/features/core/screens/client/client.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../central_home_screen/central_home_screen.dart';

class UpdateClientScreen extends StatefulWidget {
  const UpdateClientScreen({super.key, required this.client});
  final ClientResponse client;
  
  @override
  _UpdateClientScreenState createState() => _UpdateClientScreenState();
}

class _UpdateClientScreenState extends State<UpdateClientScreen> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressComplementController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String error = "";

  @override
  void initState() {
    super.initState();
    clientNameController.text = widget.client.name;
    emailController.text = widget.client.email;
    cpfController.text = widget.client.cpf;
    cellphoneController.text = widget.client.cellphone;
    addressComplementController.text = widget.client.complement;

    List<String> addressParts = widget.client.address.split(', ');
    addressController.text = addressParts[0];
    String numberNeighborhood = addressParts[1];
    String cityState = addressParts[2];
    cepController.text = addressParts[3];
    countryController.text = addressParts[4];

    List<String> numberNeighborhoodList = numberNeighborhood.split(' - ');
    numberController.text = numberNeighborhoodList[0];
    neighborhoodController.text = numberNeighborhoodList[1];

    List<String> cityStateList = cityState.split(' - ');
    cityController.text = cityStateList[0];
    stateController.text = cityStateList[1];

    cepController.addListener(() {
      String cep = cepController.text.replaceAll(RegExp(r'\D'), '');
      if (cep.length == 8) {
        fetchAddress(cep);
      } else if (cep.isEmpty) {
        setState(() {
          addressController.clear();
          numberController.clear();
          addressComplementController.clear();
          cityController.clear();
          stateController.clear();
          neighborhoodController.clear();
          countryController.clear();
        });
      }
    });
  }

  bool _clearFieldClientName = false;
  bool _clearFieldEmail = false;
  bool _clearFieldCpf = false;
  bool _clearFieldCellphone = false;

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> fetchAddress(String cep) async {
    if (cep.replaceAll(RegExp(r'\D'), '').length != 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertPopUp(errorDescription: 'O CEP deve conter 8 dígitos');
        },
      );
      return;
    }

    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['erro'] == null) {
        setState(() {
          addressController.text = data['logradouro'] ?? '';
          neighborhoodController.text = data['bairro'] ?? '';
          cityController.text = data['localidade'] ?? '';
          stateController.text = data['uf'] ?? '';
          countryController.text = 'Brasil';
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(errorDescription: 'CEP não encontrado.');
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertPopUp(errorDescription: 'Erro ao buscar endereço.');
        },
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    Future<void> updateClient(VoidCallback onSuccess) async {
      String clientName = clientNameController.text;
      String cellphone = cellphoneController.text;
      String email = emailController.text;
      String cpf = cpfController.text;
      String cep = cepController.text;
      String address = addressController.text;
      String number = numberController.text;
      String addressComplement = addressComplementController.text;
      String city = cityController.text;
      String state = stateController.text;
      String neighborhood = neighborhoodController.text;
      String country = countryController.text;


      if (clientName.isEmpty ||
          cellphone.isEmpty ||
          email.isEmpty ||
          cpf.isEmpty ||
          cep.isEmpty ||
          address.isEmpty ||
          number.isEmpty ||
          city.isEmpty ||
          state.isEmpty ||
          neighborhood.isEmpty ||
          country.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome completo, celular, email, cpf, cep, endereço, número, bairro, cidade e estado são obrigatórios.');
          },
        );
        return;
      }

      if (clientName.length == 1) {
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

      String fullAddress = "$address, $number - $neighborhood, $city - $state, $cep, $country";

      UpdateClientRequest updateClientRequest = UpdateClientRequest(
        name: clientName,
        email: email,
        cpf: cpf,
        cellphone: cellphone,
        address: fullAddress,
        complement: addressComplement,
      );

      String requestBody = jsonEncode(updateClientRequest.toJson());

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/central/client/${widget.client.id}'),
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

    Future<void> deleteClient() async {

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/central/client/${widget.client.id}'),
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
        title: Text(editClient, style: Theme.of(context).textTheme.headline4),
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
                      controller: clientNameController,
                      decoration: InputDecoration(
                        labelText: fullName,
                        prefixIcon: const Icon(LineAwesomeIcons.user),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              _clearFieldClientName = true;
                              if (_clearFieldClientName) {
                                clientNameController.clear();
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
                    TextFormField(
                      controller: cepController,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: '#####-###',),
                      ],
                      decoration: InputDecoration(
                        labelText: cep,
                        prefixIcon: const Icon(Icons.local_post_office),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            cepController.clear();
                            addressController.clear();
                            numberController.clear();
                            addressComplementController.clear();
                            cityController.clear();
                            stateController.clear();
                            neighborhoodController.clear();
                            countryController.clear();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: address,
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      enabled: false
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: numberController,
                      decoration: const InputDecoration(
                        labelText: number,
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: addressComplementController,
                      decoration: const InputDecoration(
                        labelText: addressComplement,
                        prefixIcon: Icon(Icons.home_rounded),
                      ),
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: neighborhoodController,
                      decoration: const InputDecoration(
                        labelText: neighborhood,
                        prefixIcon: Icon(Icons.holiday_village_rounded),
                      ),
                      enabled: false
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: city,
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      enabled: false
                    ),
                    const SizedBox(height: formHeight - 20),
                    TextFormField(
                      controller: stateController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: const InputDecoration(
                        labelText: state,
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      enabled: false
                    ),
                    const SizedBox(height: formHeight - 10),
                    TextFormField(
                      controller: countryController,
                      decoration: const InputDecoration(
                        label: Text('País'),
                        prefixIcon: Icon(Icons.public),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: formHeight),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          if (cellphone.isEmpty ||
                              email.isEmpty ||
                              cpf.isEmpty ||
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
                            updateClient(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CentralHomeScreen())
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
                                  text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.client.entryDate)),
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
                                child: Text("Tem certeza que deseja excluir esse cliente?"),
                              ),
                              confirm: Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteClient();
                                    Get.to(const CentralHomeScreen());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cliente excluído com sucesso!')),
                                    );
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
