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
import '../../central_home_screen.dart';
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
  late List<AssistanceInformations> filteredAssistancesList = [];

  @override
  void initState() {
    super.initState();
    getAllAssistances();
  }


  Future<ClientResponse?> getClientByCpf(String cpf) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/central/client/byCpf/$cpf'),
      headers: {
        'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
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
        Uri.parse('http://localhost:8080/api/central/category'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
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


  Future<List<AssistanceInformations>> getAllAssistances() async {
    try {
      final statusFilters = ['AGUARDANDO', 'EM_ANDAMENTO'];

      final List<AssistanceInformations> assistancesList = [];

      for (String status in statusFilters) {
        final response = await http.get(
          Uri.parse('http://localhost:8080/api/central/assistance/status/$status'),
          headers: {
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
        );
        print("Status code for $status: ${response.statusCode}");

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body) as List<dynamic>;
          print("Data for $status: $jsonData");

          final allWorkers = await getAllWorkers();
          final Map<num, String> workerIdToNameMap = {for (var worker in allWorkers) worker.id: worker.name};
          print(workerIdToNameMap);

          final allCategories = await getAllCategories();
          final Map<num, String> categoryIdToNameMap = {for (var category in allCategories) category.id: category.name};
          print(categoryIdToNameMap);

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
              complement: item['complement'],
              clientCpf: item['cpf'],
              period: item['period'],
              workersIds: workersIds,
              categoryIds: categoryIds,
            );

            final assistanceInformations = AssistanceInformations(
                assistance.id, workerNames, client!.name, assistance, categoriesName
            );
            assistancesList.add(assistanceInformations);
          }
        } else {
          print('Response status: ${response.statusCode} for $status');
          print('Response body: ${response.body}');
        }
      }

      setState(() {
        assistanceList = assistancesList;
        filteredAssistancesList = assistancesList;
      });

      return assistanceList;
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de assistências');
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
                'Serviços em andamento',
                 style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: darkColor
                ),
              ),

              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Get.to(() => AssistanceListScreen(whoAreYouTag: widget.whoAreYouTag)),
                  child: Text(
                    'Todos os serviços',
                    style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w200,
                        color: darkColor.withOpacity(0.5)
                    ),
                  ),
                ),
              ),


            ],
          ),
          const SizedBox(
            height: homePadding,
          ),
          Expanded(
            child: ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredAssistancesList.length,
              itemBuilder: (context, index) => CurrentAssistancesInfoDetail(
                whoAreYouTag: widget.whoAreYouTag,
                info: CurrentAssistancesInfoModel(
                  assistanceName: filteredAssistancesList[index].assistance.name,
                  clientName: "Cliente: ${filteredAssistancesList[index].clientName}",
                  workersName: "Funcionário: ${filteredAssistancesList[index].workersName.join(', ')}",
                  status: filteredAssistancesList[index].assistance.period,
                  icon: Icons.construction,
                  assistanceResponse: filteredAssistancesList[index].assistance,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
