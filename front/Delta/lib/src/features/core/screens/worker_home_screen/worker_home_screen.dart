import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_central_control.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_coordinates.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_drawer_menu.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_search_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker_manager.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/colors.dart';
import '../../../../constants/text_strings.dart';
import '../assistance/assistance.dart';
import '../category/category.dart';
import '../client/client.dart';
import '../worker/worker.dart';

class WorkerHomeScreen extends StatefulWidget{
  const WorkerHomeScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;


  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();

}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  AssistanceInformations? selectedAssistance;
  List<WorkersList> workers = [];
  List<WorkersList> selectedWorkers = [];
  List<CategoryResponse> categories = [];
  List<CategoryResponse> selectedCategories = [];
  late List<AssistanceInformations> assistanceList;

  @override
  void initState() {
    super.initState();
    fetchWorkers();
    fetchCurrentAssistance();
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
        Uri.parse('http://localhost:8080/api/worker/worker'),
        headers: {
          'Authorization': 'Bearer ${WorkerManager.instance.loggedUser!.token}'
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
      Uri.parse('http://localhost:8080/api/worker/client/byCpf/$cpf'),
      headers: {
        'Authorization': 'Bearer ${WorkerManager.instance.loggedUser!.token}'
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
        Uri.parse('http://localhost:8080/api/worker/category'),
        headers: {
          'Authorization': 'Bearer ${WorkerManager.instance.loggedUser!.token}'
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

  Future<void> fetchCurrentAssistance() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/worker/assistance/currentAssistance'),
        headers: {
          'Authorization': 'Bearer ${WorkerManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        print(jsonData);

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
                  complement: jsonData['complement'],
                  clientCpf: jsonData['cpf'],
                  period: jsonData['period'],
                  workersIds: (jsonData['workersIds'] as List<dynamic>).map((id) => id.toString()).toList(),
                  categoryIds: (jsonData['categoryIds'] as List<dynamic>).map((id) => id.toString()).toList()
              ),
              categoriesName
          );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final widthFactor = screenWidth < 600 ? 1.0 : 1.0;

    return Scaffold(
      appBar: WorkerAppBar(whoAreYouTag: widget.whoAreYouTag),
      drawer: WorkerDrawerMenu(whoAreYouTag: widget.whoAreYouTag),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Heading
            Text(tHomePageTitle + WorkerManager.instance.loggedUser!.worker.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(tExploreControlCentral, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const WorkerSearchBar(),
            const SizedBox(height: homePadding,),

            //Current and next service
            Text(tCurrentAndNextAssistance, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: Center(
                child: Card(
                  color: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.work, size: 40, color: darkColor),
                        const SizedBox(height: 10),
                        Text(
                          selectedAssistance != null ? 'Serviço Atual' : 'Nenhum serviço atual',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: darkColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        if (selectedAssistance != null) ...[
                          Text(
                            'Cliente: ${selectedAssistance!.clientName}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: darkColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Endereço: ${selectedAssistance!.assistance.address}, ${selectedAssistance!.assistance.complement}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: darkColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Descrição: ${selectedAssistance!.assistance.description}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: darkColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Funcionários: ${selectedAssistance!.workersName.join(', ')}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: darkColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
            WorkerCoordinates(selectedAssistance: selectedAssistance),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(tControlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            WorkerCentralControl(whoAreYouTag: widget.whoAreYouTag, selectedAssistance: selectedAssistance,),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





