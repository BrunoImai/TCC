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

  @override
  void initState() {
    super.initState();
    fetchBudgetData();
  }

  String getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final formatter = DateFormat('dd/MM');
    return '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';
  }

  int _getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(startOfYear).inDays;
    return (daysDifference / 7).ceil();
  }

  Future<void> fetchBudgetData() async {
    try {
      final budgets = await getAllBudgets();
      final approvedBudgets = budgets
          .where((budget) => budget.status == 'APROVADO')
          .toList();

      Map<int, double> weeklyRevenue = {};

      final now = DateTime.now();
      final threeMonthsAgo = now.subtract(Duration(days: 90));

      DateTime currentDate = threeMonthsAgo;
      while (currentDate.isBefore(now)) {
        int weekOfYear = _getWeekOfYear(currentDate);
        weeklyRevenue[weekOfYear] = 0.0;
        currentDate = currentDate.add(Duration(days: 7));
      }

      for (var budget in approvedBudgets) {
        final creationDate = DateTime.parse(budget.creationDate);
        if (creationDate.isAfter(threeMonthsAgo)) {
          int weekOfYear = _getWeekOfYear(creationDate);
          double totalPrice = double.tryParse(budget.totalPrice) ?? 0.0;

          if (totalPrice >= 0) {
            if (weeklyRevenue.containsKey(weekOfYear)) {
              weeklyRevenue[weekOfYear] = weeklyRevenue[weekOfYear]! + totalPrice;
            }
          }
        }
      }

      List<FlSpot> spots = weeklyRevenue.entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value);
      }).toList();

      setState(() {
        revenueSpots = spots;
      });
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
  }


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
            responsibleWorkersIds:
            (item['responsibleWorkersIds'] as List<dynamic>)
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
      throw Exception('Erro ao carregar a lista de budgets: $e');
    }
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
      child: LineChart(
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
                  final weekNumber = value.toInt();
                  final now = DateTime.now();
                  final startOfYear = DateTime(now.year, 1, 1);
                  final date = startOfYear.add(Duration(days: weekNumber * 7));
                  final weekRange = getWeekRange(date);

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
                      child: Text(weekRange, style: style),
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
          minX: revenueSpots.isEmpty ? 0 : revenueSpots.first.x,
          maxX: revenueSpots.isEmpty ? 0 : revenueSpots.last.x,
          minY: 0,
          maxY: revenueSpots.isEmpty
              ? 0
              : revenueSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).clamp(0.0, double.infinity),
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
    );
  }
}