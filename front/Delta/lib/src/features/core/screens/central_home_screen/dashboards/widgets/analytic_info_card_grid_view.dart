import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';
import '../../../budget/budget.dart';
import '../../../client/client.dart';
import '../../../worker/worker.dart';
import '../models/analytic_info_model.dart';
import 'analytic_info_card.dart';
import '../../../../../../constants/colors.dart';

class AnalyticInfoCardGridView extends StatefulWidget {
  const AnalyticInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  _AnalyticInfoCardGridViewState createState() => _AnalyticInfoCardGridViewState();
}

class _AnalyticInfoCardGridViewState extends State<AnalyticInfoCardGridView> {
  List<AnalyticInfo> analyticData = [
    AnalyticInfo(
      icon: Icons.work_history,
      title: "Serviços",
      count: 0,
      color: primaryColor,
    ),
    AnalyticInfo(
      icon: Icons.people,
      title: "Clientes",
      count: 0,
      color: primaryColor,
    ),
    AnalyticInfo(
      icon: Icons.people,
      title: "Funcionários",
      count: 0,
      color: primaryColor,
    ),
    AnalyticInfo(
      icon: Icons.attach_money_rounded,
      title: "Orçamentos",
      count: 0,
      color: primaryColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final assistances = await getAllAssistances();
      final clients = await getAllClients();
      final workers = await getAllWorkers();
      final budgets = await getAllBudgets();

      setState(() {
        analyticData[0].count = assistances.length;
        analyticData[1].count = clients.length;
        analyticData[2].count = workers.length;
        analyticData[3].count = budgets.length;
      });
    } catch (e) {
      print('Erro ao buscar dados: $e');
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
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      throw Exception('Erro ao carregar a lista de workers: $e');
    }
  }

  Future<List<ClientResponse>> getAllClients() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/client'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<ClientResponse> clientsList = jsonData.map((item) {
          return ClientResponse(
            id: item['id'],
            name: item['name'],
            email: item['email'],
            entryDate: item['entryDate'],
            cpf: item['cpf'],
            cellphone: item['cellphone'],
            address: item['address'],
            complement: item['complement'],
          );
        }).toList();

        return clientsList;

      } else {
        throw Exception('Failed to load client list');
      }
    } catch (e) {
      throw Exception('Erro ao carregar a lista de clientes: $e');
    }
  }

  Future<List<BudgetResponse>> getAllBudgets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/budget'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<BudgetResponse> budgetsList = jsonData.map((item) {
          return BudgetResponse(
            id: item['id'].toString(),
            name: item['name'],
            description: item['description'],
            creationDate: item['creationDate'],
            status: item['status'],
            assistanceId: item['assistanceId'].toString(),
            clientId: item['clientId'].toString(),
            responsibleWorkersIds: (item['responsibleWorkersIds'] as List<dynamic>).map((id) => id.toString()).toList(),
            totalPrice: item['totalPrice'].toString(),
          );
        }).toList();

        return budgetsList;
      } else {
        throw Exception('Failed to load budget list');
      }
    } catch (e) {
      throw Exception('Erro ao carregar a lista de budgets: $e');
    }
  }

  Future<List<AssistanceResponse>> getAllAssistances() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/assistance'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<AssistanceResponse> assistancesList = jsonData.map((item) {
          return AssistanceResponse(
            id: item['id'].toString(),
            startDate: item['startDate'],
            description: item['description'],
            name: item['name'],
            address: item['address'],
            complement: item['complement'],
            clientCpf: item['cpf'],
            period: item['period'],
            workersIds: (item['workersIds'] as List<dynamic>).map((id) => id.toString()).toList(),
            categoryIds: (item['categoryIds'] as List<dynamic>).map((id) => id.toString()).toList(),
            assistanceStatus: item['assistanceStatus']
          );
        }).toList();

        return assistancesList;
      } else {
        throw Exception('Failed to load assistance list');
      }
    } catch (e) {
      throw Exception('Erro ao carregar a lista de assistências: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: analyticData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: homePadding,
        mainAxisSpacing: homePadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => AnalyticInfoCard(
        info: analyticData[index],
      ),
    );
  }
}
