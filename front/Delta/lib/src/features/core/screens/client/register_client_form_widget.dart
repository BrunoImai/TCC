import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/features/core/screens/client/client_list_screen.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../central_home_screen/central_home_screen.dart';
import 'client.dart';

class RegisterClientFormWidget extends StatefulWidget {
  const RegisterClientFormWidget({
    super.key, required this.whoAreYouTag
  });
  final num whoAreYouTag;

  @override
  _RegisterClientFormWidget createState() => _RegisterClientFormWidget();

}

class _RegisterClientFormWidget extends State<RegisterClientFormWidget> {
  final TextEditingController clientController = TextEditingController();
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

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> fetchAddress(String cep) async {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertPopUp(errorDescription: 'O CEP deve conter 8 dígitos');
        },
      );
      return;
    }

    // Construindo a URL usando a Google Geocoding API
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$cep+Brazil&key=AIzaSyC7W_sMVL07McvWJcHGyVD9L0OydVx7rxY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final result = data['results'][0];
        Map<String, dynamic> components = {};
        for (var component in result['address_components']) {
          String type = component['types'][0];
          components[type] = component['short_name'];
        }

        setState(() {
          addressController.text = components['route'] ?? '';
          neighborhoodController.text = components['political'] ?? components['sublocality'] ?? components['sublocality_level_1'] ??'';
          cityController.text = components['administrative_area_level_2'] ?? '';
          stateController.text = components['administrative_area_level_1'] ?? '';
          countryController.text = 'Brazil';
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

  /*Future<void> fetchAddress(String cep) async {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertPopUp(errorDescription: 'O CEP deve conter 8 dígitos');
        },
      );
      return;
    }

    String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$cep+Brazil&key=AIzaSyC7W_sMVL07McvWJcHGyVD9L0OydVx7rxY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        final result = data['results'][0]['formatted_address'];

        // Removendo espaços extras e separando por vírgulas
        List<String> parts = result.trim().split(',');

        if (parts.length >= 4) {
          // Logradouro e número, ajustando para não depender de encontrar '1'
          String street = parts[0];
          int firstNumberIndex = street.indexOf(RegExp(r'\d'));
          if (firstNumberIndex != -1) {
            street = street.substring(0, firstNumberIndex).trim();
          }

          // Bairro, verificando se existe hífen e ajustando o acesso
          String neighborhood = parts.length > 1 ? parts[1].split('-').last.trim() : '';

          // Cidade, evitando erro de índice
          String city = parts.length > 2 ? parts[2].split('-').first.trim() : '';

          // Estado (UF) e CEP, ajustando o acesso ao estado
          String state = parts.length > 2 ? parts[2].split('-').last.trim().split(' ')[0].trim() : '';

          // País, verificando o índice
          String country =  'Brazil';

          // Definindo valores nos controladores
          setState(() {
            addressController.text = street;
            neighborhoodController.text = neighborhood;
            cityController.text = city;
            stateController.text = state;
            countryController.text = country;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertPopUp(errorDescription: 'Formato de endereço não reconhecido.');
            },
          );
        }
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
  }*/

  // Future<void> fetchAddress(String cep) async {
  //   if (cep.replaceAll(RegExp(r'\D'), '').length != 8) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return const AlertPopUp(errorDescription: 'O CEP deve conter 8 dígitos');
  //       },
  //     );
  //     return;
  //   }
  //
  //   final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //
  //     print(data);
  //
  //     if (data['erro'] == null) {
  //       setState(() {
  //         addressController.text = data['logradouro'] ?? '';
  //         neighborhoodController.text = data['bairro'] ?? '';
  //         cityController.text = data['localidade'] ?? '';
  //         stateController.text = data['uf'] ?? '';
  //         countryController.text = 'Brazil';
  //       });
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const AlertPopUp(errorDescription: 'CEP não encontrado.');
  //         },
  //       );
  //     }
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return const AlertPopUp(errorDescription: 'Erro ao buscar endereço.');
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future<void> registerClient(VoidCallback onSuccess) async {
      String client = clientController.text;
      String cellphone = cellphoneController.text;
      String email = emailController.text;
      String cpf = cpfController.text;
      String cep = cepController.text;
      String address = addressController.text;
      String number = numberController.text;
      String addressComplement = addressComplementController.text;
      String city = cityController.text;
      String state = stateController.text.toUpperCase();
      String neighborhood = neighborhoodController.text;
      String country = countryController.text;

      if (client.isEmpty ||
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

      if (client.length == 1) {
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

      ClientRequest clientRequest = ClientRequest(
          name: client,
          email: email,
          cpf: cpf,
          cellphone: cellphone,
          address: fullAddress,
          complement: addressComplement,
      );

      String requestBody = jsonEncode(clientRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/client'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registration successful!');
        }  else {
          // Registration failed
          print('Login failed. Status code: ${response.statusCode}');

          if (response.body == 'Email do cliente já cadastrado!' || response.body == 'CPF do cliente já cadastrado!') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertPopUp(
                    errorDescription: response.body,
                    onConfirmed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientListScreen(whoAreYouTag: widget.whoAreYouTag,),
                        ),
                      );
                    },
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertPopUp(
                    errorDescription: response.body,
                  );
                });
          }

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
              controller: clientController,
              decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(Icons.email_outlined)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cpfController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '###.###.###-##',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCpf),
                  prefixIcon: Icon(Icons.numbers)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cellphoneController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '(##) #####-####',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCellphone),
                  prefixIcon: Icon(Icons.phone_android)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cepController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '#####-###',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCep),
                  prefixIcon: Icon(Icons.local_post_office)
              ),
              onChanged: (value) {
                final cleanCep = value.replaceAll(RegExp(r'\D'), '');
                if (cleanCep.length == 8) {
                  fetchAddress(cleanCep);
                }
              },
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                  label: Text(tAddress),
                  prefixIcon: Icon(Icons.location_on)
              ),
              enabled: false
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: numberController,
              decoration: const InputDecoration(
                  label: Text(tNumber),
                  prefixIcon: Icon(Icons.numbers)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: addressComplementController,
              decoration: const InputDecoration(
                  label: Text(tAddressComplement),
                  prefixIcon: Icon(Icons.home_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: neighborhoodController,
              decoration: const InputDecoration(
                  label: Text(tNeighborhood),
                  prefixIcon: Icon(Icons.holiday_village_rounded)
              ),
              enabled: false
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                  label: Text(tCity),
                  prefixIcon: Icon(Icons.location_on)
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
                  label: Text(tState),
                  prefixIcon: Icon(Icons.location_on)
              ),
              enabled: false
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: countryController,
              decoration: const InputDecoration(
                label: Text('País'),
                prefixIcon: Icon(Icons.public),
              ),
              enabled: false,
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  registerClient(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CentralHomeScreen(whoAreYouTag: widget.whoAreYouTag,)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cadastro Realizado')),
                    );
                  });
                },
                child: Text(tSignUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}