import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tcc_front/src/features/core/screens/client/update_client_screen.dart';
import '../../../../commom_widgets/authentication_appbar.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/company_home_screen.dart';
import '../home_screen/widgets/company_app_bar.dart';
import 'client.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({Key? key}) : super(key: key);

  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  bool searchBarInUse = false;
  late Future<List<ClientsList>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<ClientsList> clientList;
  late List<ClientsList> filteredClientList;

  @override
  void initState() {
    super.initState();
    futureData = getAllClients();
    searchController.addListener(_onSearchChanged);
    clientList = [];
    filteredClientList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredClientList = clientList.where((client) {
        final name = client.name.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<List<ClientsList>> getAllClients() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/client'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        final List<ClientsList> clientsList = [];
        for (var item in jsonData) {
          final client = ClientsList(
              id: item['id'],
              name: item['name'],
              email: item['email'],
              entryDate: item['entryDate'],
              cpf: item['cpf'],
              cellphone: item['cellphone'],
              address: item['address']);
          clientsList.add(client);
        }

        setState(() {
          clientList = clientsList;
          filteredClientList = clientsList;
        });

        print(clientList);

        return clientList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load client list');
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
                itemCount: filteredClientList.length,
                itemBuilder: (context, index) {
                  final client = filteredClientList[index];
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
                              Text(
                                client.name,
                                style: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600, color: darkColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => UpdateClientScreen(clientId: client.id));
                                },
                                icon: const Icon(Icons.edit, color: darkColor,),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            client.email,
                            style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          ),
                          SizedBox(height: 5),
                          Text(
                            client.cellphone,
                            style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          ),
                          SizedBox(height: 5),
                          Text(
                            client.address,
                            style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
