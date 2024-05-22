import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/company_home_screen.dart';
import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import 'assistance.dart';

class RegisterAssistanceFormWidget extends StatefulWidget {
  const RegisterAssistanceFormWidget({
    super.key,
  });

  @override
  _RegisterAssistanceFormWidget createState() => _RegisterAssistanceFormWidget();
}

class _RegisterAssistanceFormWidget extends State<RegisterAssistanceFormWidget> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController assistanceNameController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressComplementController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController clientCpfController = TextEditingController();
  final TextEditingController hoursToFinishController = TextEditingController();
  final TextEditingController workersIdsController = TextEditingController();

  bool _isAddressFieldEnabled = true;

  @override
  void initState() {
    super.initState();
    clientCpfController.addListener(_onCpfChanged);
  }

  void _onCpfChanged() {
    String cpf = clientCpfController.text;
    if (cpf.replaceAll(RegExp(r'\D'), '').length == 11) {
      _fetchClientDataByCpf(cpf);
    }
  }

  Future<void> _fetchClientDataByCpf(String cpf) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/client/byCpf/$cpf'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}',
        },
      );

      if (response.statusCode == 200) {
        final clientData = jsonDecode(response.body);

        setState(() {
          cepController.text = clientData['address'].split(', ')[3];
          addressController.text = clientData['address'].split(', ')[0];
          numberController.text = clientData['address'].split(', ')[1].split(' - ')[0];
          neighborhoodController.text = clientData['address'].split(', ')[1].split(' - ')[1];
          cityController.text = clientData['address'].split(', ')[2].split(' - ')[0];
          stateController.text = clientData['address'].split(', ')[2].split(' - ')[1];
          addressComplementController.text = clientData['complement'];

          _isAddressFieldEnabled = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(errorDescription: 'Cliente não encontrado.');
          },
        );
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> registerWorker(VoidCallback onSuccess) async {
      String description = descriptionController.text;
      String assistanceName = assistanceNameController.text;
      String cep = cepController.text;
      String address = addressController.text;
      String number = numberController.text;
      String addressComplement = addressComplementController.text;
      String city = cityController.text;
      String state = stateController.text.toUpperCase();
      String neighborhood = neighborhoodController.text;
      String clientCpf = clientCpfController.text;
      String hoursToFinish = hoursToFinishController.text;
      String workersIds = workersIdsController.text;

      if (description.isEmpty ||
          assistanceName.isEmpty ||
          clientCpf.isEmpty ||
          cep.isEmpty ||
          address.isEmpty ||
          number.isEmpty ||
          city.isEmpty ||
          state.isEmpty ||
          neighborhood.isEmpty ||
          hoursToFinish.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome, descrição, clientCpf do cliente, cep, endereço, número, bairro, cidade e estado são obrigatórios.');
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

      if (clientCpfController.text.replaceAll(RegExp(r'\D'), '').length != 11) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número do clientCpf deve conter exatamente 11 dígitos.');
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

      AssistanceRequest assistanceRequest = AssistanceRequest(
          description: description,
          name: assistanceName,
          address: fullAddress,
          cpf: clientCpf,
          hoursToFinish: hoursToFinish,
          workersIds: workersIds
      );

      String requestBody = jsonEncode(assistanceRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/assistance'),
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
          // Registration failed
          print('Registration failed. Status code: ${response.statusCode}');

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertPopUp(
                    errorDescription: response.body);
              });
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
              controller: assistanceNameController,
              decoration: const InputDecoration(
                  label: Text(assistanceName),
                  prefixIcon: Icon(Icons.work)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  label: Text(description),
                  prefixIcon: Icon(Icons.email_outlined)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: clientCpfController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '###.###.###-##',),
              ],
              decoration: const InputDecoration(
                  label: Text(clientCpf),
                  prefixIcon: Icon(Icons.numbers)
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
            TextFormField(
              controller: hoursToFinishController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: const InputDecoration(
                  label: Text(hoursToFinish),
                  prefixIcon: Icon(Icons.access_time)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: workersIdsController,
              decoration: const InputDecoration(
                  label: Text(workersIds),
                  prefixIcon: Icon(Icons.group)
              ),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  registerWorker(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompanyHomeScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cadastro Realizado')),
                    );
                  });
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
