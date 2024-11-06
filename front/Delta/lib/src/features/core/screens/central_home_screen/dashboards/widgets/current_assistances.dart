import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/features/core/screens/assistance/assistance_list_screen.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';
import '../../../category/category.dart';
import '../../../client/client.dart';
import '../../../worker/worker.dart';
import '../models/current_assistances_info_model.dart';
import 'current_assistances_info_detail.dart';

class CurrentAssistances extends StatefulWidget {
  const CurrentAssistances({super.key, required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  _CurrentAssistancesState createState() => _CurrentAssistancesState();
}

class _CurrentAssistancesState extends State<CurrentAssistances> {
  late List<AssistanceInformations> assistanceList = [];

  final Map<String, String> statusOptions = {
    'AGUARDANDO': 'Aguardando',
    'EM_ANDAMENTO': 'Em andamento',
    'FINALIZADO': 'Finalizado',
  };
  String selectedStatus = 'EM_ANDAMENTO';

  @override
  void initState() {
    super.initState();
    getAllAssistances(selectedStatus);
  }

  String convertStatus(String status) {
    switch (status) {
      case 'AGUARDANDO':
        return 'Aguardando';
      case 'EM_ANDAMENTO':
        return 'Em andamento';
      case 'FINALIZADO':
        return 'Finalizado';
      default:
        return status;
    }
  }

  Future<ClientResponse?> getClientByCpf(String cpf) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/central/client/byCpf/$cpf'),
      headers: {
        'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
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
        Uri.parse('http://localhost:8080/api/central/category'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
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
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load category list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workers');
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
        print('Response body: ${response.body}');
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
  }


  Future<List<AssistanceInformations>> getAllAssistances(String status) async {
    try {
      final List<AssistanceInformations> assistancesList = [];

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/assistance/status/$status'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code for $status: ${response.statusCode}");

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final allWorkers = await getAllWorkers();
        final Map<num, String> workerIdToNameMap = {
          for (var worker in allWorkers) worker.id: worker.name
        };

        final allCategories = await getAllCategories();
        final Map<num, String> categoryIdToNameMap = {
          for (var category in allCategories) category.id: category.name
        };

        for (var item in jsonData) {
          final client = await getClientByCpf(item['cpf']);

          final workerNames = (item['workersIds'] as List<dynamic>)
              .map((id) => workerIdToNameMap[id] ?? 'Unknown')
              .toList();

          final workersIds = (item['workersIds'] as List<dynamic>)
              .map((id) => id.toString())
              .toList();

          final categoriesName = (item['categoryIds'] as List<dynamic>)
              .map((id) => categoryIdToNameMap[id] ?? 'Unknown')
              .toList();

          final categoryIds = (item['categoryIds'] as List<dynamic>)
              .map((id) => id.toString())
              .toList();

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
            assistance.id,
            workerNames,
            client!.name,
            assistance,
            categoriesName,
          );
          assistancesList.add(assistanceInformations);
        }
      } else {
        print('Response status: ${response.statusCode} for $status');
        print('Response body: ${response.body}');
      }

      setState(() {
        assistanceList = assistancesList;
      });

      return assistanceList;
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load assistance list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      padding: const EdgeInsets.all(homePadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Serviços',
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: darkColor,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Get.to(() => AssistanceListScreen(whoAreYouTag: widget.whoAreYouTag)),
                  child: SizedBox(
                    width: 80,
                    child: Text(
                      'Todos os serviços',
                      maxLines: 2,
                      softWrap: true,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w200,
                        color: darkColor.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: homePadding - 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: statusOptions.keys.map((status) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedStatus = status;
                      getAllAssistances(selectedStatus);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStatus == status
                        ? primaryColor
                        : Colors.grey[300],
                    side: BorderSide.none,
                  ),
                  child: Text(
                    statusOptions[status]!,
                    style: GoogleFonts.poppins(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: selectedStatus == status ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: assistanceList.length,
              itemBuilder: (context, index) => CurrentAssistancesInfoDetail(
                whoAreYouTag: widget.whoAreYouTag,
                info: CurrentAssistancesInfoModel(
                  assistanceName: assistanceList[index].assistance.name,
                  clientName: "Cliente: ${assistanceList[index].clientName}",
                  workersName: "Funcionário: ${assistanceList[index].workersName.join(', ')}",
                  status: convertStatus(assistanceList[index].assistance.assistanceStatus),
                  icon: Icons.construction,
                  assistanceResponse: assistanceList[index].assistance,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}