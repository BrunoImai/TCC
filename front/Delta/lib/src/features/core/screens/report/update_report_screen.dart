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

import 'package:tcc_front/src/features/core/screens/assistance/assistance.dart';
import 'package:tcc_front/src/features/core/screens/report/report.dart';

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../category/category.dart';
import '../central_home_screen/central_home_screen.dart';
import '../client/client.dart';
import '../worker/worker.dart';
import '../worker/worker_manager.dart';

class UpdateReportScreen extends StatefulWidget {
  const UpdateReportScreen({super.key, required this.report, required this.whoAreYouTag});
  final ReportResponse report;
  final num whoAreYouTag;

  @override
  _UpdateReportScreenState createState() => _UpdateReportScreenState();
}

class _UpdateReportScreenState extends State<UpdateReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController clientCpfController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController assistanceIdController = TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();
  final TextEditingController assistanceSearchController = TextEditingController();

  bool _machinePartExchange = false;
  bool _delayed = false;
  bool _isWorkerExpanded = false;
  bool _clearFieldAssistanceId = false;
  bool _clearFieldName = false;
  bool _clearFieldStatus = false;
  bool _clearFieldDescription = false;
  bool _clearFieldTotalPrice = false;
  List<WorkersList> workers = [];
  List<WorkersList> selectedWorkers = [];
  List<CategoryResponse> categories = [];
  List<CategoryResponse> selectedCategories = [];
  late List<AssistanceInformations> assistanceList;
  late List<AssistanceInformations> filteredAssistancesList;
  AssistanceInformations? selectedAssistance;
  String userToken = "";
  String userType = "";

  @override
  void initState() {
    super.initState();
    if(widget.whoAreYouTag == 2) {
      userToken = CentralManager.instance.loggedUser!.token;
      userType = 'central';
    } else {
      userToken = WorkerManager.instance.loggedUser!.token;
      userType = 'worker';
    }
    fetchWorkers();
    fetchAssistances();
    assistanceSearchController.addListener(_onAssistanceSearchChanged);

    descriptionController.text = widget.report.description;
    nameController.text = widget.report.name;
    totalPriceController.text = widget.report.totalPrice;
    statusController.text = widget.report.status;
    _machinePartExchange = widget.report.machinePartExchange;
    _delayed = widget.report.delayed;

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
        String paymentType = paymentTypeController.text;
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
        final jsonData = json.decode(response.body) as List<dynamic>;

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
        print('Response body: ${response.body}');
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
      final jsonData = json.decode(response.body);
      print(jsonData);
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
        final jsonData = json.decode(response.body) as List<dynamic>;

        final List<CategoryResponse> categoryList = jsonData.map((item) {
          return CategoryResponse(
            id: item['id'],
            name: item['name'],
            creationDate: item['creationDate'],
          );
        }).toList();

        return categoryList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
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
        Uri.parse('http://localhost:8080/api/$userType/assistance'),
        headers: {
          'Authorization': 'Bearer $userToken'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        final allWorkers = await getAllWorkers();

        final Map<num, String> workerIdToNameMap = {for (var worker in allWorkers) worker.id: worker.name};
        print(workerIdToNameMap);

        final allCategories = await getAllCategories();

        final Map<num, String> categoryIdToNameMap = {for (var category in allCategories) category.id: category.name};
        print(categoryIdToNameMap);

        final List<AssistanceInformations> assistancesList = [];
        for (var item in jsonData) {
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
              clientCpf: item['cpf'],
              period: item['period'],
              workersIds: workersIds,
              categoryIds: categoryIds
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
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load assistance list');
      }

    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de clientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateAssistance(VoidCallback onSuccess) async {
      String description = descriptionController.text;
      String name = nameController.text;
      String clientCpf = clientCpfController.text;
      String totalPrice = totalPriceController.text;
      String paymentType = paymentTypeController.text;
      String status = statusController.text;
      List<num> workersIds = selectedWorkers.map((worker) => worker.id).toList();


      if (description.isEmpty ||
          assistanceName.isEmpty ||
          clientCpf.isEmpty ||
          name.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome do serviço, descrição, categoria, CPF do cliente, cep, endereço, número, bairro, cidade, estado e período são obrigatórios.');
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

      UpdateReportRequest updateReportRequest = UpdateReportRequest(
        name: name,
        description: description,
        status: status,
        assistanceId: assistanceId,
        responsibleWorkersIds: workersIds,
        totalPrice: totalPrice,
          paymentType: paymentType,
          machinePartExchange: _machinePartExchange,
          delayed: _delayed
      );

      String requestBody = jsonEncode(updateReportRequest.toJson());
      print(requestBody);

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/$userType/report/${widget.report.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userToken'
          },
          body: requestBody,
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

    Future<void> deleteAssistance() async {

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/$userType/report/${widget.report.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço excluído com sucesso!')),
          );
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            double elementWidth;
            if (constraints.maxWidth < 800) {
              elementWidth = double.infinity;
            } else {
              elementWidth = constraints.maxWidth * 0.3;
            }

            return Center(
              child: Container(
                padding: const EdgeInsets.all(defaultSize),
                width: elementWidth,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
                  child: Column(
                    children: [
                      const Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Icon(Icons.work, color: primaryColor, size: 100),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: assistanceIdController,
                              decoration: InputDecoration(
                                  labelText: 'Número do serviço',
                                  prefixIcon: Icon(Icons.content_paste_search_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldAssistanceId = true;
                                      if (_clearFieldAssistanceId) {
                                        nameController.clear();
                                        clientCpfController.clear();
                                        clientNameController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                              onTap: () async {
                                AssistanceInformations? selectedAssistance = await showDialog<AssistanceInformations>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Selecione um serviço', style: Theme.of(context).textTheme.headline4),
                                      content: SizedBox(
                                        width: double.maxFinite,
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
                              decoration: InputDecoration(
                                  label: Text(tTitle),
                                  prefixIcon: Icon(Icons.assignment_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldName = true;
                                      if (_clearFieldName) {
                                        nameController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: formHeight - 20),
                            TextFormField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                  label: const Text(description),
                                  prefixIcon: const Icon(Icons.subject_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldDescription = true;
                                      if (_clearFieldDescription) {
                                        descriptionController.clear();
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
                              decoration: const InputDecoration(
                                  label: Text(clientCpf),
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
                                        _isWorkerExpanded ? LineAwesomeIcons.angle_up : Icons.edit,
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
                            TextFormField(
                              controller: totalPriceController,
                              decoration: const InputDecoration(
                                  label: Text(tTotalPrice),
                                  prefixIcon: Icon(Icons.attach_money_rounded)
                              ),
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
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
                                  updateAssistance(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CentralHomeScreen(whoAreYouTag: widget.whoAreYouTag,))
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Atualização Realizada')),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder()),
                                child: Text(editAssistance.toUpperCase(), style: const TextStyle(color: darkColor)),
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
                                          text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.report.creationDate)),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: tDelete.toUpperCase(),
                                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                      content: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15.0),
                                        child: Text("Tem certeza que deseja excluir esse serviço?"),
                                      ),
                                      confirm: Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            deleteAssistance();
                                            Get.to(CentralHomeScreen(whoAreYouTag: widget.whoAreYouTag));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Serviço excluído com sucesso!')),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent, side: BorderSide.none),
                                          child: const Text("Sim"),
                                        ),
                                      ),
                                      cancel: OutlinedButton(
                                          onPressed: () => Get.back(), child: const Text("Não")),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                                      elevation: 0,
                                      foregroundColor: Colors.red,
                                      shape: const StadiumBorder(),
                                      side: BorderSide.none),
                                  child: const Text(tDelete),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
