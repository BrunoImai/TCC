import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc_front/src/features/core/screens/category/category.dart';
import 'package:tcc_front/src/features/core/screens/client/register_client_screen.dart';
import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../central_home_screen/central_home_screen.dart';
import '../worker/worker.dart';
import 'assistance.dart';

class RegisterAssistanceFormWidget extends StatefulWidget {
  const RegisterAssistanceFormWidget({
    super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

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
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();


  bool _isWorkerExpanded = false;
  bool _isCategoryExpanded = false;
  bool _isPeriodExpanded = false;
  List<WorkersList> workers = [];
  List<WorkersList> selectedWorkers = [];
  List<CategoryResponse> categories = [];
  List<CategoryResponse> selectedCategories = [];
  String selectedPeriod = "";

  @override
  void initState() {
    super.initState();
    clientCpfController.addListener(_onCpfChanged);
    fetchWorkers();
    fetchCategories();
  }

  void _onCpfChanged() {
    String cpf = clientCpfController.text;
    if (cpf.isEmpty) {
      _clearAddressFields();
    } else if (cpf.replaceAll(RegExp(r'\D'), '').length == 11) {
      _fetchClientDataByCpf(cpf);
    }
  }

  void _clearAddressFields() {
    setState(() {
      cepController.clear();
      addressController.clear();
      numberController.clear();
      addressComplementController.clear();
      cityController.clear();
      stateController.clear();
      neighborhoodController.clear();
      clientNameController.clear();
    });
  }

  Future<void> fetchWorkers() async {
    try {
      final workersList = await getAllWorkers();
      setState(() {
        workers = workersList;
      });
    } catch (e) {
      print('Error fetching workers: $e');
    }
  }

  Future<List<WorkersList>> getAllWorkers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/worker'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<WorkersList> workersList = jsonData.map((item) {
          return WorkersList(
            id: item['id'],
            name: item['name'],
            email: item['email'],
            entryDate: item['entryDate'],
            cpf: item['cpf'],
            cellphone: item['cellphone'],
          );
        }).toList();

        return workersList;
      } else {
        print('Response status: ${response.statusCode}');
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final categoriesList = await getAllCategories();
      setState(() {
        categories = categoriesList;
      });
    } catch (e) {
      print('Error fetching workers: $e');
    }
  }

  Future<List<CategoryResponse>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/category'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<CategoryResponse> categoriesList = jsonData.map((item) {
          return CategoryResponse(
            id: item['id'],
            name: item['name'],
            creationDate: item['creationDate'],
          );
        }).toList();

        return categoriesList;
      } else {
        print('Response status: ${response.statusCode}');
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de categories');
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
        final clientData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          cepController.text = clientData['address'].split(', ')[3];
          addressController.text = clientData['address'].split(', ')[0];
          countryController.text = clientData['address'].split(', ')[4];
          numberController.text = clientData['address'].split(', ')[1].split(' - ')[0];
          neighborhoodController.text = clientData['address'].split(', ')[1].split(' - ')[1];
          cityController.text = clientData['address'].split(', ')[2].split(' - ')[0];
          stateController.text = clientData['address'].split(', ')[2].split(' - ')[1];
          addressComplementController.text = clientData['complement'];

          clientNameController.text = clientData['name'];

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
    Future<void> registerAssistance(VoidCallback onSuccess) async {
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
      List<num> workersIds = selectedWorkers.map((worker) => worker.id).toList();
      List<num> categoriesId = selectedCategories.map((category) => category.id).toList();
      String country = countryController.text;

      if (description.isEmpty ||
          assistanceName.isEmpty ||
          clientCpf.isEmpty ||
          cep.isEmpty ||
          address.isEmpty ||
          number.isEmpty ||
          city.isEmpty ||
          state.isEmpty ||
          neighborhood.isEmpty ||
          selectedPeriod.isEmpty ||
          country.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome do serviço, descrição, CPF do cliente, cep, endereço, número, bairro, cidade, estado, país e período são obrigatórios.');
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
                'O número de CPF deve conter exatamente 11 dígitos.');
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

      AssistanceRequest assistanceRequest = AssistanceRequest(
          description: description,
          name: assistanceName,
          address: '$fullAddress',
          complement: addressComplement,
          cpf: clientCpf,
          period: selectedPeriod,
          categoriesId: categoriesId,
          workersIds: workersIds
      );

      String requestBody = jsonEncode(assistanceRequest.toJson());

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/assistance'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: utf8.encode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registration successful!');
        } else {
          // Registration failed
          print('Registration failed. Status code: ${response.statusCode}');

          if (response.body == 'Cliente não encontrado.') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertPopUp(
                    errorDescription: response.body,
                    onConfirmed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterClientScreen(whoAreYouTag: widget.whoAreYouTag,),
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
              controller: assistanceNameController,
              decoration: const InputDecoration(
                  label: Text(tAssistanceName),
                  prefixIcon: Icon(Icons.work)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  label: Text(tDescription),
                  prefixIcon: Icon(Icons.add)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCategoryExpanded = !_isCategoryExpanded;
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  label: const Text('Categoria'),
                  prefixIcon: const Icon(Icons.category_rounded),
                  suffixIcon: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: IconButton(
                      icon: Icon(
                        _isCategoryExpanded ? LineAwesomeIcons.angle_up : LineAwesomeIcons.angle_down,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCategoryExpanded = !_isCategoryExpanded;
                        });
                      },
                    ),
                  ),
                ),
                child: Text(
                  selectedCategories.isEmpty
                      ? ''
                      : selectedCategories.map((category) => category.name).join(', '),
                ),
              ),
            ),
            if (_isCategoryExpanded)
              Column(
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategories.contains(category)) {
                          selectedCategories.remove(category);
                        } else {
                          selectedCategories.add(category);
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
                              color: selectedCategories.contains(category) ? Colors.green : Colors.transparent,
                              border: Border.all(color: selectedCategories.contains(category) ? Colors.transparent : primaryColor),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: selectedCategories.contains(category)
                              ? const Center(
                              child: Icon(
                                Icons.check,
                                color: whiteColor,
                                size: 10,
                              )
                          )
                              : null,
                        ),
                        Text(category.name, style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: clientCpfController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '###.###.###-##',),
              ],
              decoration: const InputDecoration(
                  label: Text(tClientCpf),
                  prefixIcon: Icon(Icons.numbers)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: clientNameController,
              decoration: const InputDecoration(
                  label: Text(tClientName),
                  prefixIcon: Icon(Icons.person)
              ),
              enabled: false,
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
              enabled: false,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                  label: Text(tAddress),
                  prefixIcon: Icon(Icons.location_on)
              ),
              enabled: false,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: numberController,
              decoration: const InputDecoration(
                  label: Text(tNumber),
                  prefixIcon: Icon(Icons.numbers)
              ),
              enabled: false,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: addressComplementController,
              decoration: const InputDecoration(
                  label: Text(tAddressComplement),
                  prefixIcon: Icon(Icons.home_rounded)
              ),
              enabled: false,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: neighborhoodController,
              decoration: const InputDecoration(
                  label: Text(tNeighborhood),
                  prefixIcon: Icon(Icons.holiday_village_rounded)
              ),
              enabled: false,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                  label: Text(tCity),
                  prefixIcon: Icon(Icons.location_on)
              ),
              enabled: false,
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
              enabled: false,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: countryController,
              decoration: const InputDecoration(
                label: Text(tCountry),
                prefixIcon: Icon(Icons.public),
              ),
              enabled: false,
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
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  registerAssistance(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CentralHomeScreen(whoAreYouTag: widget.whoAreYouTag,)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Serviço cadastrado!')),
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


