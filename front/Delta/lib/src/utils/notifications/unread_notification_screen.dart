import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/features/core/screens/budget/budget_approval_screen.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/text_strings.dart';
import '../../features/authentication/screens/signup/central_manager.dart';
import '../../features/core/screens/budget/budget.dart';
import '../../features/core/screens/budget/update_budget_screen.dart';
import '../../features/core/screens/worker/worker_manager.dart';
import '../../features/core/screens/worker_home_screen/widgets/worker_app_bar.dart';
import 'notification.dart';


class UnreadNotificationScreen extends StatefulWidget {
  const UnreadNotificationScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  _UnreadNotificationScreenState createState() => _UnreadNotificationScreenState();
}

class _UnreadNotificationScreenState extends State<UnreadNotificationScreen> {
  bool searchBarInUse = false;
  late Future<List<NotificationInformations>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<NotificationInformations> unreadNotificationList;
  late List<NotificationInformations> filteredUnreadNotificationList;
  String userToken = "";
  String userType = "";
  String userUrl = "";
  String userName = "";


  @override
  void initState() {
    super.initState();
    if (widget.whoAreYouTag == 2) {
      userToken = CentralManager.instance.loggedUser!.token;
      userType = 'central';
      userUrl = 'http://localhost:8080/api/central/assistance';
      userName = utf8.decode(CentralManager.instance.loggedUser!.central.name.codeUnits);
    } else {
      userToken = WorkerManager.instance.loggedUser!.token;
      userType = 'worker';
      userUrl = 'http://localhost:8080/api/worker/assistance/currentAssistance';
      userName = utf8.decode(WorkerManager.instance.loggedUser!.worker.name.codeUnits);
    }
    futureData = getAllUnreadNotifications();
    searchController.addListener(_onSearchChanged);
    unreadNotificationList = [];
    filteredUnreadNotificationList = [];
  }

  void _onSearchChanged() {
    setState(() {
      filteredUnreadNotificationList = unreadNotificationList.where((data) {
        final name = data.notification.title.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
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


  Future<List<NotificationInformations>> getAllUnreadNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/$userType/notification/unread'),
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

        final List<NotificationInformations> notificationsList = [];
        for (var item in jsonData) {
          final workerName = workerIdToNameMap[item['workerId']] ?? 'Unknown';

          final workerId = item['workerId'].toString();


          final notification = NotificationResponse(
              id: item['id'].toString(),
              title: item['title'],
              message: item['message'],
              creationDate: item['creationDate'],
              readed: item['readed'],
              workerId: workerId.toString(),
              budgetId: item['budgetId'].toString()
          );

          print("Notificarion: $notification");

          final notificationInformations = NotificationInformations(
              notification.id, workerName, notification);
          notificationsList.add(notificationInformations);
        }

        setState(() {
          unreadNotificationList = notificationsList;
          filteredUnreadNotificationList = notificationsList;
        });
        print("UnreadNotificationList: $unreadNotificationList");

        return unreadNotificationList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load notification list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP notification: $e');
      throw Exception('Falha ao carregar a lista de notification');
    }
  }

  Future<BudgetResponse?> getBudgetById(String id) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/$userType/budget/$id'),
      headers: {
        'Authorization': 'Bearer $userToken'
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      String convertStatus(String status) {
        switch (status) {
          case 'EM_ANALISE':
            return 'em análise';
          case 'APROVADO':
            return 'aprovado';
          case 'REPROVADO':
            return 'reprovado';
          default:
            return status;
        }
      }

      return BudgetResponse(
          id: jsonData['id'].toString(),
          name: jsonData['name'],
          description: jsonData['description'],
          creationDate: jsonData['creationDate'],
          status: convertStatus(jsonData['status']),
          assistanceId: jsonData['assistanceId'].toString(),
          clientId: jsonData['clientId'].toString(),
          responsibleWorkersIds: (jsonData['responsibleWorkersIds'] as List<
              dynamic>).map((id) => id.toString()).toList(),
          totalPrice: jsonData['totalPrice'].toString()
      );
    } else {
      print('Failed to load budget approval. Status code: ${response
          .statusCode}');
      return null;
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

    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final widthFactor = screenWidth <= 600 ? 1.0 : 0.3;

    return Scaffold(
      appBar: appBar,
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
                  tUnreadNotificationSubTitle,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline2,
                ),
                const SizedBox(height: homePadding),
                //Search Box
                Container(
                  decoration: const BoxDecoration(
                      border: Border(left: BorderSide(width: 4))),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
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
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.5)),
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
                    children: filteredUnreadNotificationList.map((data) {
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.short_text,
                                            color: darkColor,
                                            size: 35,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              data.notification.title,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: darkColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        if (widget.whoAreYouTag == 2) {
                                          Get.to(() =>
                                              BudgetApprovalScreen(
                                                  budgetId: data.notification
                                                      .budgetId,
                                                  whoAreYouTag: widget
                                                      .whoAreYouTag));
                                        } else {
                                          BudgetResponse? budget = await getBudgetById(
                                              data.notification.budgetId);
                                          if (budget != null) {
                                            Get.to(() =>
                                                UpdateBudgetScreen(budget: budget,
                                                    whoAreYouTag: widget
                                                        .whoAreYouTag));
                                          } else {
                                            print('Failed to fetch budget');
                                          }
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.edit_notifications_rounded,
                                          color: darkColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.message_rounded,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        data.notification.message,
                                        style: GoogleFonts.poppins(fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: darkColor),
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
                                      Icons.person,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        data.workerName,
                                        style: GoogleFonts.poppins(fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: darkColor),
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
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                data.notification.creationDate)),
                                        style: GoogleFonts.poppins(fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: darkColor),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
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