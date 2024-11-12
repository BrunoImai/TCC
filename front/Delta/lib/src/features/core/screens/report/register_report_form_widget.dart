import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc_front/src/features/core/screens/assistance/assistance.dart';
import 'package:tcc_front/src/features/core/screens/category/category.dart';
import 'package:tcc_front/src/features/core/screens/report/report.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker_manager.dart';
import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../central_home_screen/central_home_screen.dart';
import '../client/client.dart';
import '../worker/worker.dart';
import '../worker_home_screen/worker_home_screen.dart';

class RegisterReportFormWidget extends StatefulWidget {
  const RegisterReportFormWidget({
    super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  _RegisterReportFormWidget createState() => _RegisterReportFormWidget();
}

class _RegisterReportFormWidget extends State<RegisterReportFormWidget> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController clientCpfController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController assistanceIdController = TextEditingController();
  final TextEditingController assistanceSearchController = TextEditingController();

  bool _machinePartExchange = false;
  bool _delayed = false;
  bool _isWorkerExpanded = false;
  bool _isPaymentTypeExpanded = false;
  List<WorkersList> workers = [];
  List<WorkersList> selectedWorkers = [];
  List<CategoryResponse> categories = [];
  List<CategoryResponse> selectedCategories = [];
  String selectedPaymentType = "";
  late List<AssistanceInformations> assistanceList = [];
  late List<AssistanceInformations> filteredAssistancesList = [];
  AssistanceInformations? selectedAssistance;
  String userToken = "";
  String userType = "";
  String userUrl = "";


  @override
  void initState() {
    super.initState();
    if(widget.whoAreYouTag == 2) {
      userToken = CentralManager.instance.loggedUser!.token;
      userType = 'central';
      userUrl = 'http://localhost:8080/api/central/assistance';
    } else {
      userToken = WorkerManager.instance.loggedUser!.token;
      userType = 'worker';
      userUrl = 'http://localhost:8080/api/worker/assistance/currentAssistance';
    }
    fetchWorkers();
    fetchAssistances();
    assistanceSearchController.addListener(_onAssistanceSearchChanged);
  }

  void _onAssistanceSearchChanged() {
    String query = assistanceSearchController.text.toLowerCase();
    setState(() {
      filteredAssistancesList = assistanceList.where((assistance) {
        return assistance.assistance.id.contains(query) ||
            assistance.clientName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> fetchAssistances() async {
    try {
      final assistances = await getAllAssistances();
      setState(() {
        assistanceList = assistances;
        filteredAssistancesList = assistances;
      });
    } catch (e) {
      print('Error fetching assistances: $e');
    }
  }

  void _onAssistanceSelected(AssistanceInformations? assistance) {
    if (assistance != null) {
      setState(() {
        selectedAssistance = assistance;
        nameController.text = assistance.assistance.name;
        clientCpfController.text = assistance.assistance.clientCpf;
        clientNameController.text = assistance.clientName;
        assistanceIdController.text = assistance.assistance.id;
        selectedWorkers = workers.where((worker) =>
            assistance.assistance.workersIds.contains(worker.id.toString())).toList();
      });
    }
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
        Uri.parse('http://localhost:8080/api/$userType/worker'),
        headers: {
          'Authorization': 'Bearer $userToken'
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
        print('Response status worker: ${response.statusCode}');
        print('Response body worker: ${response.body}');
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
  }

  Future<ClientResponse?> getClientByCpf(String cpf) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/$userType/client/byCpf/$cpf'),
      headers: {
        'Authorization': 'Bearer $userToken'
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      return ClientResponse(
        id: jsonData['id'],
        name: jsonData['name'],
        email: jsonData['email'],
        entryDate: jsonData['entryDate'],
        cpf: jsonData['cpf'],
        cellphone: jsonData['cellphone'],
        address: jsonData['address'],
        complement: jsonData['complement'],
      );
    } else {
      print('Failed to load client. Status code: ${response.statusCode}');
      return null;
    }
  }

  Future<List<CategoryResponse>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/$userType/category'),
        headers: {
          'Authorization': 'Bearer $userToken'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<CategoryResponse> categoryList = jsonData.map((item) {
          return CategoryResponse(
            id: item['id'],
            name: item['name'],
            creationDate: item['creationDate'],
          );
        }).toList();

        return categoryList;
      } else {
        print('Response status category: ${response.statusCode}');
        print('Response body category: ${response.body}');
        throw Exception('Failed to load category list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
  }

  Future<List<AssistanceInformations>> getAllAssistances() async {
    try {
      final response = await http.get(
        Uri.parse(userUrl),
        headers: {
          'Authorization': 'Bearer $userToken'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody);

        final List<dynamic> assistancesJson = (jsonData is List) ? jsonData : [jsonData];

        final allWorkers = await getAllWorkers();
        final Map<num, String> workerIdToNameMap = {for (var worker in allWorkers) worker.id: worker.name};
        print(workerIdToNameMap);

        final allCategories = await getAllCategories();
        final Map<num, String> categoryIdToNameMap = {for (var category in allCategories) category.id: category.name};
        print(categoryIdToNameMap);

        final List<AssistanceInformations> assistancesList = [];
        for (var item in assistancesJson) {
          final client = await getClientByCpf(item['cpf']);

          final workerNames = (item['workersIds'] as List<dynamic>)
              .map((id) => workerIdToNameMap[id] ?? 'Unknown')
              .toList();

          final workersIds = (item['workersIds'] as List<dynamic>)
              .map((id) => id.toString()).toList();

          final categoriesName = (item['categoryIds'] as List<dynamic>)
              .map((id) => categoryIdToNameMap[id] ?? 'Unknown')
              .toList();
          print(categoriesName);

          final categoryIds = (item['categoryIds'] as List<dynamic>)
              .map((id) => id.toString()).toList();
          print(categoryIds);

          final assistance = AssistanceResponse(
            id: item['id'].toString(),
            startDate: item['startDate'],
            description: item['description'],
            name: item['name'],
            address: item['address'],
            complement: item['complement'],
            clientCpf: item['cpf'],
            period: item['period'],
            workersIds: workersIds,
            categoryIds: categoryIds,
            assistanceStatus: item['assistanceStatus']
          );

          final assistanceInformations = AssistanceInformations(
              assistance.id, workerNames, client!.name, assistance, categoriesName);

          assistancesList.add(assistanceInformations);
        }

        setState(() {
          assistanceList = assistancesList;
          filteredAssistancesList = assistancesList;
        });

        return assistanceList;
      } else {
        print('Response status assistance: ${response.statusCode}');
        print('Response body assistance: ${response.body}');
        throw Exception('Failed to load assistance list');
      }

    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de clientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> registerReport(VoidCallback onSuccess) async {
      String description = descriptionController.text;
      String name = nameController.text;
      String clientCpf = clientCpfController.text;
      List<num> workersIds = selectedWorkers.map((worker) => worker.id).toList();

      if (description.isEmpty ||
          name.isEmpty ||
          clientCpf.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      if (name.length == 1) {
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


      if (selectedAssistance == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Por favor, selecione uma assistência.');
          },
        );
        return;
      }

      num? clientId;
      num? assistanceId = num.tryParse(selectedAssistance!.assistance.id);

      final client = await getClientByCpf(clientCpf);
      if (client != null) {
        clientId = client.id;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(errorDescription: 'Cliente não encontrado.');
          },
        );
        return;
      }

      String convertPaymentTypeRequest(String status) {
        switch (status) {
          case 'Débito':
            return 'DEBITO';
          case 'Crédito':
            return 'CREDITO';
          case 'Dinheiro':
            return 'DINHEIRO';
          case 'Pix':
            return 'PIX';
          default:
            return status;
        }
      }

      ReportRequest reportRequest = ReportRequest(
        name: name,
        description: description,
        responsibleWorkersIds: workersIds,
        assistanceId: assistanceId,
        paymentType: convertPaymentTypeRequest(selectedPaymentType),
        machinePartExchange: _machinePartExchange,
        delayed: _delayed
      );

      String requestBody = jsonEncode(reportRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/$userType/report'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $userToken'
          },
          body: utf8.encode(requestBody),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registro bem-sucedido!');
        } else {
          print('Falha no registro. Código de status: ${response.statusCode}');

          if (response.body == 'Cliente não encontrado.') {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertPopUp(errorDescription: 'Cliente não encontrado.');
                });
          }
        }
      } catch (e) {
        print('Erro ao registrar: $e');
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: assistanceIdController,
              decoration: const InputDecoration(
                labelText: 'Número do serviço',
                prefixIcon: Icon(Icons.content_paste_search_rounded)
              ),
              onTap: () async {
                fetchAssistances();
                AssistanceInformations? selectedAssistance = await showDialog<AssistanceInformations>(
                  context: context,
                  builder: (BuildContext context) {
                    double screenWidth = MediaQuery.of(context).size.width;

                    double dialogWidth;
                    if (screenWidth < 800) {
                      dialogWidth = screenWidth;
                    } else {
                      dialogWidth = screenWidth * 0.3;
                    }

                    return Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: homePadding - 5),
                      child: SizedBox(
                        width: dialogWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Selecione um serviço',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            const Divider(height: 1),
                            SizedBox(
                              height: 350,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: assistanceList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final assistance = assistanceList[index];
                                  return ListTile(
                                    title: Text(assistance.assistance.id),
                                    onTap: () {
                                      Navigator.pop(context, assistance);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (selectedAssistance != null) {
                  setState(() {
                    _onAssistanceSelected(selectedAssistance);
                  });
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text(tTitle),
                  prefixIcon: Icon(Icons.assignment_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  label: Text(tDescription),
                  prefixIcon: Icon(Icons.subject_rounded)
              ),
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
              readOnly: true,
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: clientNameController,
              decoration: const InputDecoration(
                  label: Text(tClientName),
                  prefixIcon: Icon(Icons.person)
              ),
              readOnly: true,
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
            const SizedBox(height: formHeight - 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPaymentTypeExpanded = !_isPaymentTypeExpanded;
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Método de Pagamento',
                  prefixIcon: const Icon(Icons.payment_rounded),
                  suffixIcon: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(
                      _isPaymentTypeExpanded ? LineAwesomeIcons.angle_up : LineAwesomeIcons.angle_down, // Changed the icon based on _isPaymentTypeExpanded
                    ),
                  ),
                ),
                child: Text(selectedPaymentType ?? ''),
              ),
            ),
            if (_isPaymentTypeExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Crédito', style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      setState(() {
                        selectedPaymentType = 'Crédito';
                        _isPaymentTypeExpanded = false;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Débito', style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      setState(() {
                        selectedPaymentType = 'Débito';
                        _isPaymentTypeExpanded = false; // Close the menu after selection
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Dinheiro', style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      setState(() {
                        selectedPaymentType = 'Dinheiro';
                        _isPaymentTypeExpanded = false; // Close the menu after selection
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Pix', style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      setState(() {
                        selectedPaymentType = 'Pix';
                        _isPaymentTypeExpanded = false; // Close the menu after selection
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: formHeight - 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Houve troca de peça?'),
                Switch(
                  value: _machinePartExchange,
                  activeColor: primaryColor,
                  onChanged: (bool value) {
                    setState(() {
                      _machinePartExchange = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: formHeight - 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Houve atraso na finalização do serviço?'),
                Switch(
                  value: _delayed,
                  activeColor: primaryColor,
                  onChanged: (bool value) {
                    setState(() {
                      _delayed = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  registerReport(() {
                    if (widget.whoAreYouTag == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CentralHomeScreen(whoAreYouTag: widget.whoAreYouTag,)
                          )
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkerHomeScreen(whoAreYouTag: widget.whoAreYouTag,)
                        )
                    );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Relatório cadastrado!')),
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


