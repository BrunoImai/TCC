import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/constants/colors.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';

class BarChartAssistances extends StatefulWidget {
  const BarChartAssistances({super.key});

  @override
  _BarChartAssistancesState createState() => _BarChartAssistancesState();
}

class _BarChartAssistancesState extends State<BarChartAssistances> {
  late Future<Map<DateTime, int>> assistancesByWeekFuture;

  List<String> dateRangeOptions = ['Last 7 days', 'Last 30 days', 'Last 90 days'];
  String selectedDateRange = 'Last 7 days';

  @override
  void initState() {
    super.initState();
    assistancesByWeekFuture = getAssistancesByWeek();
  }

  // Future<List<AssistanceResponse>> getAllAssistances() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://localhost:8080/api/central/assistance'),
  //       headers: {
  //         'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var decodedBody = utf8.decode(response.bodyBytes);
  //       var jsonData = json.decode(decodedBody) as List<dynamic>;
  //
  //       final List<AssistanceResponse> assistancesList = jsonData.map((item) {
  //         return AssistanceResponse(
  //           id: item['id'].toString(),
  //           startDate: item['startDate'],
  //           description: item['description'],
  //           name: item['name'],
  //           address: item['address'],
  //           complement: item['complement'],
  //           clientCpf: item['cpf'],
  //           period: item['period'],
  //           workersIds: (item['workersIds'] as List<dynamic>)
  //               .map((id) => id.toString())
  //               .toList(),
  //           categoryIds: (item['categoryIds'] as List<dynamic>)
  //               .map((id) => id.toString())
  //               .toList(),
  //         );
  //       }).toList();
  //
  //       return assistancesList;
  //     } else {
  //       throw Exception('Failed to load assistance list');
  //     }
  //   } catch (e) {
  //     throw Exception('Erro ao carregar a lista de assistências: $e');
  //   }
  // }
  //
  // String getWeekRange(DateTime date) {
  //   final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
  //   final endOfWeek = startOfWeek.add(const Duration(days: 6));
  //   final formatter = DateFormat('dd/MM');
  //   return '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';
  // }
  //
  // int _getWeekOfYear(DateTime date) {
  //   final startOfYear = DateTime(date.year, 1, 1);
  //   final daysDifference = date.difference(startOfYear).inDays;
  //   return (daysDifference / 7).ceil();
  // }
  //
  // Future<Map<int, int>> getAssistancesByWeek() async {
  //   try {
  //     final assistances = await getAllAssistances();
  //     final Map<int, int> weeklyAssistances = {};
  //
  //     final DateTime threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
  //
  //     final int currentWeek = _getWeekOfYear(DateTime.now());
  //     final int startWeek = _getWeekOfYear(threeMonthsAgo);
  //
  //     for (int week = startWeek; week <= currentWeek; week++) {
  //       weeklyAssistances[week] = 0;
  //     }
  //
  //     final filteredAssistances = assistances.where((assistance) {
  //       DateTime startDate = DateTime.parse(assistance.startDate);
  //       return startDate.isAfter(threeMonthsAgo);
  //     }).toList();
  //
  //     for (var assistance in filteredAssistances) {
  //       DateTime startDate = DateTime.parse(assistance.startDate);
  //       int weekOfYear = _getWeekOfYear(startDate);
  //
  //       if (weeklyAssistances.containsKey(weekOfYear)) {
  //         weeklyAssistances[weekOfYear] = weeklyAssistances[weekOfYear]! + 1;
  //       }
  //     }
  //
  //     return weeklyAssistances;
  //   } catch (e) {
  //     throw Exception('Erro ao carregar a lista de assistências por semana: $e');
  //   }
  // }


  Future<List<AssistanceResponse>> getAllAssistances() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/assistance'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<AssistanceResponse> assistancesList = jsonData.map((item) {
          return AssistanceResponse(
            id: item['id'].toString(),
            startDate: item['startDate'],
            description: item['description'],
            name: item['name'],
            address: item['address'],
            complement: item['complement'],
            clientCpf: item['cpf'],
            period: item['period'],
            workersIds: (item['workersIds'] as List<dynamic>)
                .map((id) => id.toString())
                .toList(),
            categoryIds: (item['categoryIds'] as List<dynamic>)
                .map((id) => id.toString())
                .toList(),
          );
        }).toList();

        return assistancesList;
      } else {
        throw Exception('Failed to load assistance list');
      }
    } catch (e) {
      throw Exception('Error loading assistances: $e');
    }
  }

  // Get week range string for display
  String getWeekRange(DateTime date) {
    final startOfWeek = date;
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final formatter = DateFormat('dd/MM');
    return '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';
  }

  // Updated function to get assistances grouped by week start dates
  Future<Map<DateTime, int>> getAssistancesByWeek() async {
    try {
      final assistances = await getAllAssistances();
      final Map<DateTime, int> weeklyAssistances = {};

      DateTime now = DateTime.now();
      DateTime startDateRange;

      // Determine the start date based on the selected date range
      if (selectedDateRange == 'Last 7 days') {
        startDateRange = now.subtract(Duration(days: 7));
      } else if (selectedDateRange == 'Last 30 days') {
        startDateRange = now.subtract(Duration(days: 30));
      } else {
        startDateRange = now.subtract(Duration(days: 90));
      }

      // Generate week start dates between startDateRange and now
      DateTime currentWeekStart = startDateRange.subtract(Duration(days: startDateRange.weekday - 1));
      while (currentWeekStart.isBefore(now)) {
        weeklyAssistances[currentWeekStart] = 0;
        currentWeekStart = currentWeekStart.add(Duration(days: 7));
      }

      // Filter assistances within the date range
      final filteredAssistances = assistances.where((assistance) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        return startDate.isAfter(startDateRange);
      }).toList();

      // Map assistances to their corresponding week start dates
      for (var assistance in filteredAssistances) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        DateTime weekStartDate = startDate.subtract(Duration(days: startDate.weekday - 1));
        weekStartDate = DateTime(weekStartDate.year, weekStartDate.month, weekStartDate.day);

        if (weeklyAssistances.containsKey(weekStartDate)) {
          weeklyAssistances[weekStartDate] = weeklyAssistances[weekStartDate]! + 1;
        } else {
          weeklyAssistances[weekStartDate] = 1;
        }
      }

      return weeklyAssistances;
    } catch (e) {
      throw Exception('Error loading assistances by week: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for date range selection
        DropdownButton<String>(
          value: selectedDateRange,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedDateRange = newValue;
                assistancesByWeekFuture = getAssistancesByWeek();
              });
            }
          },
          items: dateRangeOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Expanded(
          child: FutureBuilder<Map<DateTime, int>>(
            future: assistancesByWeekFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              }

              final weeklyAssistances = snapshot.data!;
              List<DateTime> sortedWeekStarts = weeklyAssistances.keys.toList()..sort();
              List<BarChartGroupData> barGroups = [];
              List<String> xLabels = [];

              for (int i = 0; i < sortedWeekStarts.length; i++) {
                DateTime weekStart = sortedWeekStarts[i];
                int count = weeklyAssistances[weekStart] ?? 0;

                barGroups.add(
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: count.toDouble(),
                      width: 20,
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    )
                  ]),
                );

                String weekRange = getWeekRange(weekStart);
                xLabels.add(weekRange);
              }

              return BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(border: Border.all(width: 0)),
                  groupsSpace: 15,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final style = GoogleFonts.poppins(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          );
                          int index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            String label = xLabels[index];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Transform.rotate(
                                angle: -0.45,
                                child: Text(label, style: style),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Text('${value.toInt()}', style: style),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: barGroups,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
