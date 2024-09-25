import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/notifications/notification.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../authentication/screens/signup/central_manager.dart';
import '../../budget/budget_approval_screen.dart';


class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  bool searchBarInUse = false;
  late Future<List<NotificationInformations>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<NotificationInformations> unreadNotificationList;
  late List<NotificationInformations> filteredUnreadNotificationList;

  @override
  void initState() {
    super.initState();
    futureData = getAllNotifications();
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
      print('Erro ao fazer a solicitação HTTP workers: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
  }


  Future<List<NotificationInformations>> getAllNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/notification'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        final allWorkers = await getAllWorkers();

        final Map<num, String> workerIdToNameMap = {for (var worker in allWorkers) worker.id: worker.name};
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CentralAppBar(whoAreYouTag: widget.whoAreYouTag,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(homePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${CentralManager.instance.loggedUser!.central.name},",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  tNotificationTitle,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: homePadding),
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
                            hintText: tSearch,
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
                const SizedBox(height: homePadding),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(homeCardPadding),
              child: ListView.builder(
                itemCount: filteredUnreadNotificationList.length,
                itemBuilder: (context, index) {
                  final data = filteredUnreadNotificationList[index];
                  return Card(
                    elevation: 3,
                    color: cardBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w800, color: darkColor),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => BudgetApprovalScreen(budgetId: data.notification.budgetId, whoAreYouTag: widget.whoAreYouTag));
                                },
                                icon: const Icon(Icons.edit_notifications_rounded, color: darkColor),
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
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
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
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
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
                                  DateFormat('dd/MM/yyyy').format(DateTime.parse(data.notification.creationDate)),
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
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