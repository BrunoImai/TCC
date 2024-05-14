import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/features/core/screens/worker/worker.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/widgets/company_app_bar.dart';


class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({Key? key}) : super(key: key);

  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  bool searchBarInUse = false;
  late Future<List<WorkersList>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<WorkersList> workerList;
  late List<WorkersList> filteredWorkerList;

  @override
  void initState() {
    super.initState();
    futureData = getAllWorkers();
    searchController.addListener(_onSearchChanged);
    workerList = [];
    filteredWorkerList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredWorkerList = workerList.where((worker) {
        final name = worker.name.toLowerCase();
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

        final List<WorkersList> workersList = [];
        for (var item in jsonData) {
          final worker = WorkersList(
              id: item['id'],
              name: item['name'],
              email: item['email'],
              entryDate: item['entryDate'],
              cpf: item['cpf'],
              cellphone: item['cellphone'],
          );
          workersList.add(worker);
        }

        setState(() {
          workerList = workersList;
          filteredWorkerList = workersList;
        });


        return workerList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load worker list');
      }

    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workeres');
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
                Text(workerListSubTitle, style: Theme.of(context).textTheme.headline2,),
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
                itemCount: filteredWorkerList.length,
                itemBuilder: (context, index) {
                  final worker = filteredWorkerList[index];
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
                                    Icons.person_outline_rounded,
                                    color: darkColor,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    worker.name,
                                    style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w800, color: darkColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  //Get.to(() => UpdateWorkerScreen(worker: worker));
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
                                    Icons.email,
                                    color: darkColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    worker.email,
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
                                    Icons.phone,
                                    color: darkColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    worker.cellphone,
                                    style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
