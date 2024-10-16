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
  late Future<Map<int, int>> assistancesByWeekFuture;

  @override
  void initState() {
    super.initState();
    assistancesByWeekFuture = getAssistancesByWeek();
  }

  Future<List<AssistanceResponse>> getAllAssistances() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/assistance'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

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
      throw Exception('Erro ao carregar a lista de assistências: $e');
    }
  }

  // Função para pegar o intervalo de datas de uma semana a partir da data
  String getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1)); // Início da semana (segunda-feira)
    final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Final da semana (domingo)
    final formatter = DateFormat('dd/MM');
    return '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';
  }

  int _getWeekOfYear(DateTime date) {
    // A primeira semana do ano é a semana em que ocorre o primeiro dia do ano (1º de janeiro).
    final startOfYear = DateTime(date.year, 1, 1);
    final daysDifference = date.difference(startOfYear).inDays;

    // O número da semana é o número de dias desde o início do ano dividido por 7, arredondado para cima.
    return (daysDifference / 7).ceil();
  }

  Future<Map<int, int>> getAssistancesByWeek() async {
    try {
      final assistances = await getAllAssistances();
      final Map<int, int> weeklyAssistances = {};

      final DateTime threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));

      final filteredAssistances = assistances.where((assistance) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        return startDate.isAfter(threeMonthsAgo);
      }).toList();

      for (var assistance in filteredAssistances) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        int weekOfYear = _getWeekOfYear(startDate);

        if (weeklyAssistances.containsKey(weekOfYear)) {
          weeklyAssistances[weekOfYear] = weeklyAssistances[weekOfYear]! + 1;
        } else {
          weeklyAssistances[weekOfYear] = 1;
        }
      }
      print(weeklyAssistances);

      return weeklyAssistances;
    } catch (e) {
      throw Exception('Erro ao carregar a lista de assistências por semana: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, int>>(
      future: assistancesByWeekFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        }

        final weeklyAssistances = snapshot.data!;
        List<BarChartGroupData> barGroups = [];

        weeklyAssistances.forEach((week, count) {
          print('Week: $week, Count: $count');
          barGroups.add(
            BarChartGroupData(x: week, barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              )
            ]),
          );
        });

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
                    DateTime startDate = DateTime.now().subtract(Duration(days: (DateTime.now().weekday - 1) + (52 - value.toInt()) * 7));
                    String weekRange = getWeekRange(startDate);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Transform.rotate(
                        angle: -0.45,
                          child: Text(weekRange, style: style)
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
    );
  }
}
