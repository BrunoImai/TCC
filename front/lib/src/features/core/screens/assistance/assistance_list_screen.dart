import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/features/core/screens/assistance/assistance.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/widgets/company_app_bar.dart';
import '../worker/worker.dart';




class AssistanceListScreen extends StatefulWidget {
  const AssistanceListScreen({Key? key}) : super(key: key);

  @override
  _AssistancesListScreenState createState() => _AssistancesListScreenState();
}

class _AssistancesListScreenState extends State<AssistanceListScreen> {
  bool searchBarInUse = false;
  late Future<List<AssistancesList>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<AssistancesList> assistanceList;
  late List<AssistancesList> filteredAssistancesList;

  @override
  void initState() {
    super.initState();
    futureData = getAllAssistances();
    searchController.addListener(_onSearchChanged);
    assistanceList = [];
    filteredAssistancesList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredAssistancesList = assistanceList.where((assistance) {
        final name = assistance.name.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<String> getClientNameByCpf(String cpf) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/client/$cpf'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['name'];
      } else {
        print('Failed to load client name. Status code: ${response.statusCode}');
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching client name: $e');
      return 'Unknown';
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

  Future<List<AssistancesList>> getAllAssistances() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/assistance'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        final allWorkers = await getAllWorkers();

        final Map<num, String> workerIdToNameMap = {for (var worker in allWorkers) worker.id: worker.name};

        final List<AssistancesList> assistancesList = [];
        for (var item in jsonData) {
          final clientName = await getClientNameByCpf(item['cpf']);

          final workerNames = (item['workersIds'] as List<dynamic>)
              .map((id) => workerIdToNameMap[id.toString()] ?? 'Unknown')
              .toList();

          final assistance = AssistancesList(
              id: item['id'],
              description: item['description'],
              name: item['name'],
              address: item['address'],
              clientName: clientName,
              period: item['period'],
              workersNames: workerNames
          );
          assistancesList.add(assistance);
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
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(homePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${CentralManager.instance.loggedUser!.central.name},",style: Theme.of(context).textTheme.bodyText2,),
                Text(clientListSubTitle, style: Theme.of(context).textTheme.headline2,),
                const SizedBox(height: homePadding,),
                //Search Box
                Container(
                  decoration: const BoxDecoration(border: Border(left: BorderSide(width: 4))),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            _onSearchChanged();
                          },
                          decoration: InputDecoration(
                            hintText: search,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _onSearchChanged();
                              },
                              icon: const Icon(Icons.search, size: 25),
                            ),
                          ),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: homePadding,),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(homeCardPadding),
              child: ListView.builder(
                itemCount: filteredAssistancesList.length,
                itemBuilder: (context, index) {
                  final assistance = filteredAssistancesList[index];
                  return Card(
                    elevation: 3,
                    color: cardBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.work,
                                    color: darkColor,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    assistance.name,
                                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w800, color: darkColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  //Get.to(() => UpdateClientScreen(assistance: assistance));
                                },
                                icon: const Icon(Icons.edit, color: darkColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.person,
                                    color: darkColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    assistance.clientName,
                                    style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.location_on,
                                    color: darkColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    assistance.address,
                                    style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.people,
                                    color: darkColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    assistance.workersNames.join(', '),
                                    style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
