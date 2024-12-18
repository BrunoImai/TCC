import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/features/core/screens/budget/budget.dart';
import 'package:tcc_front/src/features/core/screens/budget/update_budget_screen.dart';
import 'package:tcc_front/src/features/core/screens/client/client.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../central_home_screen/widgets/central_app_bar.dart';
import '../central_home_screen/widgets/central_drawer_menu.dart';
import '../worker/worker.dart';
import '../worker/worker_manager.dart';
import '../worker_home_screen/widgets/worker_app_bar.dart';


class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  _BudgetListScreenState createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  bool searchBarInUse = false;
  late Future<List<BudgetInformations>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<BudgetInformations> budgetList;
  late List<BudgetInformations> filteredBudgetsList;
  String userToken = "";
  String userType = "";
  String userName = "";

  @override
  void initState() {
    super.initState();
    if (widget.whoAreYouTag == 2) {
      userToken = CentralManager.instance.loggedUser!.token;
      userType = 'central';
      userName = utf8.decode(CentralManager.instance.loggedUser!.central.name.codeUnits);
    } else {
      userToken = WorkerManager.instance.loggedUser!.token;
      userType = 'worker';
      userName = utf8.decode(WorkerManager.instance.loggedUser!.worker.name.codeUnits);
    }
    futureData = getAllBudgets();
    searchController.addListener(_onSearchChanged);
    budgetList = [];
    filteredBudgetsList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredBudgetsList = budgetList.where((data) {
        final name = data.budget.name.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<ClientResponse?> getClientById(int id) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/$userType/client/$id'),
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
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP workers: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
  }

  Future<List<BudgetInformations>> getAllBudgets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/$userType/budget'),
        headers: {
          'Authorization': 'Bearer $userToken'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final allWorkers = await getAllWorkers();

        final Map<num, String> workerIdToNameMap = {
          for (var worker in allWorkers) worker.id: worker.name
        };
        print(workerIdToNameMap);

        final List<BudgetInformations> budgetsList = [];
        for (var item in jsonData) {
          final client = await getClientById(item['clientId']);

          final workerNames = (item['responsibleWorkersIds'] as List<dynamic>)
              .map((id) => workerIdToNameMap[id] ?? 'Unknown')
              .toList();

          final workersIds = (item['responsibleWorkersIds'] as List<dynamic>)
              .map((id) => id.toString()).toList();


          final budget = BudgetResponse(
              id: item['id'].toString(),
              name: item['name'],
              description: item['description'],
              creationDate: item['creationDate'],
              status: item['status'],
              assistanceId: item['assistanceId'].toString(),
              clientId: item['clientId'].toString(),
              responsibleWorkersIds: workersIds,
              totalPrice: item['totalPrice'].toString()
          );

          print("Budget: $budget");
          final budgetInformations = BudgetInformations(
              budget.id, workerNames, client!.name, budget);
          budgetsList.add(budgetInformations);
        }

        setState(() {
          budgetList = budgetsList;
          filteredBudgetsList = budgetsList;
        });
        print("BudgetList: $budgetList");

        return budgetList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load budget list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP budgets: $e');
      throw Exception('Falha ao carregar a lista de budgets');
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar;
    if (widget.whoAreYouTag == 2) {
      appBar = CentralAppBar(whoAreYouTag: widget.whoAreYouTag);
    } else {
      appBar = WorkerAppBar(whoAreYouTag: widget.whoAreYouTag);
    }

    final drawer = widget.whoAreYouTag == 2
        ? CentralDrawerMenu(whoAreYouTag: widget.whoAreYouTag)
        : CentralDrawerMenu(whoAreYouTag: widget.whoAreYouTag);

    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final widthFactor = screenWidth <= 600 ? 1.0 : 0.3;

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(homePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$userName,",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2,
                ),
                Text(
                  tBudgetListSubTitle,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline2,
                ),
                const SizedBox(height: homePadding),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(width: 4)),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            hintText: tSearch,
                            hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.5)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _onSearchChanged();
                              },
                              icon: const Icon(Icons.search, size: 25),
                            ),
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: homePadding),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(homeCardPadding),
                child: Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: filteredBudgetsList.map((data) {
                      return FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: Card(
                          elevation: 3,
                          color: cardBgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.content_paste_search_rounded,
                                            color: darkColor,
                                            size: 35,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              "Número do serviço: ${data.budget.assistanceId as String}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w800,
                                                color: darkColor,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.to(() =>
                                            UpdateBudgetScreen(
                                              budget: data.budget,
                                              whoAreYouTag: widget.whoAreYouTag,
                                            ));
                                      },
                                      icon: const Icon(
                                          Icons.edit, color: darkColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.assignment_rounded,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        data.budget.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: darkColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.pending_actions,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "Status: ${data.budget.status}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: darkColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.attach_money_rounded,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "Preço total: ${data.budget.totalPrice} reais",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: darkColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "Data de casdastro: ${DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                data.budget.creationDate))}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: darkColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.people,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "Funcionário: ${data.workersName.join(', ')}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                          color: darkColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}