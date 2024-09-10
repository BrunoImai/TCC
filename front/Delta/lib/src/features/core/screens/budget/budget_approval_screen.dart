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
import 'package:tcc_front/src/features/core/screens/budget/budget.dart';

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

class BudgetApprovalScreen extends StatefulWidget {
  const BudgetApprovalScreen({super.key, required this.budget, required this.whoAreYouTag});
  final BudgetResponse budget;
  final num whoAreYouTag;

  @override
  _BudgetApprovalScreenState createState() => _BudgetApprovalScreenState();
}

class _BudgetApprovalScreenState extends State<BudgetApprovalScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController clientCpfController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController assistanceIdController = TextEditingController();
  final TextEditingController assistanceSearchController = TextEditingController();

  bool _clearFieldTotalPrice = false;
  bool _clearFieldStatus = false;
  List<WorkersList> workers = [];
  List<WorkersList> selectedWorkers = [];
  List<CategoryResponse> categories = [];
  List<CategoryResponse> selectedCategories = [];
  late List<AssistanceInformations> assistanceList;
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
    fetchAssistance(widget.budget.assistanceId!);

    descriptionController.text = widget.budget.description;
    nameController.text = widget.budget.name;
    totalPriceController.text = widget.budget.totalPrice;
    statusController.text = widget.budget.status;

    assistanceIdController.text = widget.budget.assistanceId!;
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

  Future<void> fetchAssistance(String assistanceId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/$userType/assistance/$assistanceId'),
        headers: {
          'Authorization': 'Bearer $userToken'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        final client = await getClientByCpf(jsonData['cpf']);
        final allWorkers = await getAllWorkers();
        final allCategories = await getAllCategories();

        final workerIdToNameMap = {for (var worker in allWorkers) worker.id: worker.name};
        final categoryIdToNameMap = {for (var category in allCategories) category.id: category.name};

        final workerNames = (jsonData['workersIds'] as List<dynamic>)
            .map((id) => workerIdToNameMap[id] ?? 'Unknown')
            .toList();

        final categoriesName = (jsonData['categoryIds'] as List<dynamic>)
            .map((id) => categoryIdToNameMap[id] ?? 'Unknown')
            .toList();

        setState(() {
          selectedAssistance = AssistanceInformations(
              jsonData['id'].toString(),
              workerNames,
              client!.name,
              AssistanceResponse(
                id: jsonData['id'].toString(),
                startDate: jsonData['startDate'],
                description: jsonData['description'],
                name: jsonData['name'],
                address: jsonData['address'],
                clientCpf: jsonData['cpf'],
                period: jsonData['period'],
                workersIds: (jsonData['workersIds'] as List<dynamic>).map((id) => id.toString()).toList(),
                categoryIds: (jsonData['categoryIds'] as List<dynamic>).map((id) => id.toString()).toList(),
              ),
              categoriesName
          );

          assistanceIdController.text = selectedAssistance!.assistance.id;
          nameController.text = selectedAssistance!.assistance.name;
          descriptionController.text = selectedAssistance!.assistance.description;
          clientCpfController.text = selectedAssistance!.assistance.clientCpf;
          clientNameController.text = selectedAssistance!.clientName;
          selectedWorkers = workers.where((worker) =>
              selectedAssistance!.assistance.workersIds.contains(worker.id.toString())).toList();
        });
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load assistance');
      }
    } catch (e) {
      print('Error fetching assistance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateAssistance(VoidCallback onSuccess) async {
      String description = descriptionController.text;
      String name = nameController.text;
      String clientCpf = clientCpfController.text;
      String totalPrice = totalPriceController.text;
      String status = statusController.text;
      List<num> workersIds = selectedWorkers.map((worker) => worker.id).toList();


      if (description.isEmpty ||
          assistanceName.isEmpty ||
          totalPrice.isEmpty ||
          clientCpf.isEmpty ||
          name.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
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

      UpdateBudgetRequest updateBudgetRequest = UpdateBudgetRequest(
        name: name,
        description: description,
        status: status,
        assistanceId: assistanceId,
        clientId: clientId,
        responsibleWorkersIds: workersIds,
        totalPrice: totalPrice,
      );

      String requestBody = jsonEncode(updateBudgetRequest.toJson());
      print(requestBody);

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/$userType/budget/${widget.budget.id}'),
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
        Uri.parse('http://localhost:8080/api/$userType/budget/${widget.budget.id}'),
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
        title: Text(tEditBudget, style: Theme.of(context).textTheme.headline4),
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
                              decoration: const InputDecoration(
                                labelText: 'Número do serviço',
                                prefixIcon: Icon(Icons.content_paste_search_rounded),
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(height: formHeight - 20),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                label: Text(tTitle),
                                prefixIcon: Icon(Icons.assignment_rounded),
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(height: formHeight - 20),
                            TextFormField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                label: Text(description),
                                prefixIcon: Icon(Icons.subject_rounded),
                              ),
                              readOnly: true,
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
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  label: Text('Funcionários'),
                                  prefixIcon: Icon(Icons.people),
                                ),
                                child: Text(
                                  selectedWorkers.isEmpty
                                      ? ''
                                      : selectedWorkers.map((worker) => worker.name).join(', '),
                                ),
                              ),
                            ),
                            const SizedBox(height: formHeight - 20),
                            TextFormField(
                              controller: totalPriceController,
                              decoration: InputDecoration(
                                label: const Text(tTotalPrice),
                                prefixIcon: const Icon(Icons.attach_money_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldTotalPrice = true;
                                      if (_clearFieldTotalPrice) {
                                        totalPriceController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                            ),
                            const SizedBox(height: formHeight - 20),
                            TextFormField(
                              controller: statusController,
                              decoration: InputDecoration(
                                label: const Text(tTotalPrice),
                                prefixIcon: const Icon(Icons.attach_money_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldStatus = true;
                                      if (_clearFieldStatus) {
                                        statusController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
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
                                child: Text(tEditBudget.toUpperCase(), style: const TextStyle(color: darkColor)),
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
                                          text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.budget.creationDate)),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
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
