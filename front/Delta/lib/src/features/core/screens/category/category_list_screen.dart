import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/features/core/screens/category/update_category_screen.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../central_home_screen/widgets/central_app_bar.dart';
import '../central_home_screen/widgets/central_drawer_menu.dart';
import 'category.dart';


class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  bool searchBarInUse = false;
  late Future<List<CategoryResponse>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<CategoryResponse> categoryList;
  late List<CategoryResponse> filteredCategoryList;

  @override
  void initState() {
    super.initState();
    futureData = getAllCategories();
    searchController.addListener(_onSearchChanged);
    categoryList = [];
    filteredCategoryList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredCategoryList = categoryList.where((category) {
        final name = category.name.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<List<CategoryResponse>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/category'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        final List<CategoryResponse> categoriesList = [];
        for (var item in jsonData) {
          final category = CategoryResponse(
              id: item['id'],
              name: item['name'],
              creationDate: item['creationDate'],
          );

          categoriesList.add(category);
        }

        setState(() {
          categoryList = categoriesList;
          filteredCategoryList = categoriesList;
        });


        return categoryList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load client list');
      }

    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de categorias');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthFactor = screenWidth <= 600 ? 1.0 : 0.3;

    return Scaffold(
      appBar: CentralAppBar(whoAreYouTag: widget.whoAreYouTag),
      drawer: CentralDrawerMenu(whoAreYouTag: widget.whoAreYouTag),
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
                  tCategoryListTitle,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: homePadding),
                // Search Box
                Container(
                  decoration: const BoxDecoration(
                      border: Border(left: BorderSide(width: 4))),
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(homeCardPadding),
                child: Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: filteredCategoryList.map((category) {
                      return FractionallySizedBox(
                        widthFactor: widthFactor,
                        child: Card(
                          elevation: 3,
                          color: cardBgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
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
                                            Icons.category_rounded,
                                            color: darkColor,
                                            size: 35,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              category.name,
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
                                        Get.to(() => UpdateCategoryScreen(
                                          category: category,
                                          whoAreYouTag: widget.whoAreYouTag,
                                        ));
                                      },
                                      icon: const Icon(Icons.edit, color: darkColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: darkColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(DateTime.parse(category.creationDate)),
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
