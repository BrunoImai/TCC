import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../budget/budget.dart';

class RevenueLineChart extends StatefulWidget {
  const RevenueLineChart({super.key});

  @override
  _RevenueLineChartState createState() => _RevenueLineChartState();
}

class _RevenueLineChartState extends State<RevenueLineChart> {
  List<Color> gradientColors = [
    primaryColor,
    secondaryColor,
  ];

  List<FlSpot> revenueSpots = [];
  List<String> xAxisLabels = [];
  List<String> dateRangeOptions = ['Last 7 days', 'Last 30 days', 'This Year', 'All Years'];
  String selectedDateRange = 'Last 7 days';

  @override
  void initState() {
    super.initState();
    fetchBudgetData();
  }

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
  // Future<void> fetchBudgetData() async {
  //   try {
  //     final budgets = await getAllBudgets();
  //     final approvedBudgets = budgets
  //         .where((budget) => budget.status == 'APROVADO')
  //         .toList();
  //
  //     Map<int, double> weeklyRevenue = {};
  //
  //     final now = DateTime.now();
  //     final threeMonthsAgo = now.subtract(Duration(days: 90));
  //
  //     DateTime currentDate = threeMonthsAgo;
  //     while (currentDate.isBefore(now)) {
  //       int weekOfYear = _getWeekOfYear(currentDate);
  //       weeklyRevenue[weekOfYear] = 0.0;
  //       currentDate = currentDate.add(Duration(days: 7));
  //     }
  //
  //     for (var budget in approvedBudgets) {
  //       final creationDate = DateTime.parse(budget.creationDate);
  //       if (creationDate.isAfter(threeMonthsAgo)) {
  //         int weekOfYear = _getWeekOfYear(creationDate);
  //         double totalPrice = double.tryParse(budget.totalPrice) ?? 0.0;
  //
  //         if (totalPrice >= 0) {
  //           if (weeklyRevenue.containsKey(weekOfYear)) {
  //             weeklyRevenue[weekOfYear] = weeklyRevenue[weekOfYear]! + totalPrice;
  //           }
  //         }
  //       }
  //     }
  //
  //     List<FlSpot> spots = weeklyRevenue.entries.map((entry) {
  //       return FlSpot(entry.key.toDouble(), entry.value);
  //     }).toList();
  //
  //     setState(() {
  //       revenueSpots = spots;
  //     });
  //   } catch (e) {
  //     print('Erro ao buscar dados: $e');
  //   }
  // }
  //
  //
  // Future<List<BudgetResponse>> getAllBudgets() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://localhost:8080/api/central/budget'),
  //       headers: {
  //         'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var decodedBody = utf8.decode(response.bodyBytes);
  //       var jsonData = json.decode(decodedBody) as List<dynamic>;
  //
  //       final List<BudgetResponse> budgetsList = jsonData.map((item) {
  //         return BudgetResponse(
  //           id: item['id'].toString(),
  //           name: item['name'],
  //           description: item['description'],
  //           creationDate: item['creationDate'],
  //           status: item['status'],
  //           assistanceId: item['assistanceId'].toString(),
  //           clientId: item['clientId'].toString(),
  //           responsibleWorkersIds:
  //           (item['responsibleWorkersIds'] as List<dynamic>)
  //               .map((id) => id.toString())
  //               .toList(),
  //           totalPrice: item['totalPrice'].toString(),
  //         );
  //       }).toList();
  //
  //       return budgetsList;
  //     } else {
  //       throw Exception('Failed to load budget list');
  //     }
  //   } catch (e) {
  //     throw Exception('Erro ao carregar a lista de budgets: $e');
  //   }
  // }

  Future<void> fetchBudgetData() async {
    try {
      final budgets = await getAllBudgets();
      final approvedBudgets = budgets.where((budget) => budget.status == 'APROVADO').toList();

      Map<String, double> revenueData = {};

      final now = DateTime.now();

      if (selectedDateRange == 'Last 7 days' || selectedDateRange == 'Last 30 days') {
        int days = selectedDateRange == 'Last 7 days' ? 7 : 30;
        DateTime startDate = now.subtract(Duration(days: days));

        // Initialize revenue data map for each day
        for (int i = 0; i <= days; i++) {
          DateTime date = startDate.add(Duration(days: i));
          String dateKey = DateFormat('yyyy-MM-dd').format(date);
          revenueData[dateKey] = 0.0;
        }

        // Aggregate revenue per day
        for (var budget in approvedBudgets) {
          final creationDate = DateTime.parse(budget.creationDate);
          if (!creationDate.isBefore(startDate) && !creationDate.isAfter(now)) {
            String dateKey = DateFormat('yyyy-MM-dd').format(creationDate);
            double totalPrice = double.tryParse(budget.totalPrice) ?? 0.0;

            if (revenueData.containsKey(dateKey)) {
              revenueData[dateKey] = revenueData[dateKey]! + totalPrice;
            }
          }
        }
      } else if (selectedDateRange == 'This Year') {
        int currentYear = now.year;

        // Initialize revenue data map for each month
        for (int month = 1; month <= 12; month++) {
          String monthKey = '$currentYear-${month.toString().padLeft(2, '0')}';
          revenueData[monthKey] = 0.0;
        }

        // Aggregate revenue per month
        for (var budget in approvedBudgets) {
          final creationDate = DateTime.parse(budget.creationDate);
          if (creationDate.year == currentYear) {
            String monthKey = '${creationDate.year}-${creationDate.month.toString().padLeft(2, '0')}';
            double totalPrice = double.tryParse(budget.totalPrice) ?? 0.0;

            if (revenueData.containsKey(monthKey)) {
              revenueData[monthKey] = revenueData[monthKey]! + totalPrice;
            }
          }
        }
      } else if (selectedDateRange == 'All Years') {
        // Aggregate revenue per year
        for (var budget in approvedBudgets) {
          final creationDate = DateTime.parse(budget.creationDate);
          String yearKey = '${creationDate.year}';
          double totalPrice = double.tryParse(budget.totalPrice) ?? 0.0;

          if (revenueData.containsKey(yearKey)) {
            revenueData[yearKey] = revenueData[yearKey]! + totalPrice;
          } else {
            revenueData[yearKey] = totalPrice;
          }
        }
      }

      // Convert revenue data to FlSpot list for the chart
      List<String> sortedKeys = revenueData.keys.toList()..sort((a, b) => a.compareTo(b));
      List<FlSpot> spots = [];

      for (int i = 0; i < sortedKeys.length; i++) {
        String key = sortedKeys[i];
        double value = revenueData[key]!;
        spots.add(FlSpot(i.toDouble(), value));
      }

      setState(() {
        revenueSpots = spots;
        xAxisLabels = sortedKeys; // Store the labels
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Fetch all budgets from the API
  Future<List<BudgetResponse>> getAllBudgets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/budget'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<BudgetResponse> budgetsList = jsonData.map((item) {
          return BudgetResponse(
            id: item['id'].toString(),
            name: item['name'],
            description: item['description'],
            creationDate: item['creationDate'],
            status: item['status'],
            assistanceId: item['assistanceId'].toString(),
            clientId: item['clientId'].toString(),
            responsibleWorkersIds: (item['responsibleWorkersIds'] as List<dynamic>)
                .map((id) => id.toString())
                .toList(),
            totalPrice: item['totalPrice'].toString(),
          );
        }).toList();

        return budgetsList;
      } else {
        throw Exception('Failed to load budget list');
      }
    } catch (e) {
      throw Exception('Error loading budgets: $e');
    }
  }

  // Get X-axis labels based on the selected date range
  String getXAxisLabel(int index) {
    if (index < 0 || index >= xAxisLabels.length) {
      return '';
    }

    if (selectedDateRange == 'Last 7 days' || selectedDateRange == 'Last 30 days') {
      DateTime date = DateTime.parse(xAxisLabels[index]);
      return DateFormat('dd/MM').format(date);
    } else if (selectedDateRange == 'This Year') {
      DateTime date = DateTime.parse('${xAxisLabels[index]}-01');
      return DateFormat('MMM').format(date);
    } else if (selectedDateRange == 'All Years') {
      return xAxisLabels[index];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        homePadding,
        homePadding * 1.5,
        homePadding,
        homePadding,
      ),
      child: Column(
        children: [
          // Dropdown for date range selection
          DropdownButton<String>(
            value: selectedDateRange,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedDateRange = newValue;
                  fetchBudgetData();
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
            child: revenueSpots.isEmpty
                ? const Center(child: Text('No data available'))
                : LineChart(
              LineChartData(
                gridData: const FlGridData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= revenueSpots.length) {
                          return const SizedBox.shrink();
                        }
                        String label = getXAxisLabel(index);

                        const style = TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        );

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8.0,
                          child: Transform.rotate(
                            angle: -0.45,
                            child: Text(label, style: style),
                          ),
                        );
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
                          fontSize: 8,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(value.toStringAsFixed(0), style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                minX: 0,
                maxX: revenueSpots.isNotEmpty ? (revenueSpots.length - 1).toDouble() : 0,
                minY: 0,
                maxY: revenueSpots.isNotEmpty
                    ? revenueSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
                    : 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: revenueSpots,
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}