import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/constants/colors.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';

class BarChartNeighborhood extends StatefulWidget {
  const BarChartNeighborhood({super.key});

  @override
  _BarChartNeighborhoodState createState() => _BarChartNeighborhoodState();
}

class _BarChartNeighborhoodState extends State<BarChartNeighborhood> {
  late Future<Map<String, int>> assistancesByNeighborhoodFuture;

  List<String> dateRangeOptions = ['Últimos 7 dias', 'Últimos 30 dias', 'Últimos 90 dias'];
  String selectedDateRange = 'Últimos 7 dias';

  @override
  void initState() {
    super.initState();
    assistancesByNeighborhoodFuture = getAssistancesByNeighborhood();
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
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        return jsonData.map((item) {
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
              assistanceStatus: item['assistanceStatus']
          );
        }).toList();
      } else {
        throw Exception('Failed to load assistance list');
      }
    } catch (e) {
      throw Exception('Error loading assistances: $e');
    }
  }

  Future<Map<String, int>> getAssistancesByNeighborhood() async {
    try {
      final assistances = await getAllAssistances();
      final Map<String, int> neighborhoodCounts = {};

      // Filtrar assistências dentro do intervalo de datas
      DateTime now = DateTime.now();
      DateTime startDateRange;

      if (selectedDateRange == 'Últimos 7 dias') {
        startDateRange = now.subtract(Duration(days: 7));
      } else if (selectedDateRange == 'Últimos 30 dias') {
        startDateRange = now.subtract(Duration(days: 30));
      } else {
        startDateRange = now.subtract(Duration(days: 90));
      }

      final filteredAssistances = assistances.where((assistance) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        return startDate.isAfter(startDateRange);
      }).toList();

      // Processar e agrupar por bairro-cidade
      for (var assistance in filteredAssistances) {
        List<String> addressParts = assistance.address.split(', ');
        if (addressParts.length > 2) {
          String neighborhood = addressParts[1].split(' - ')[1];
          String city = addressParts[2].split(' - ')[0];
          String key = '$neighborhood - $city';

          neighborhoodCounts[key] = (neighborhoodCounts[key] ?? 0) + 1;
        }
      }

      return neighborhoodCounts;
    } catch (e) {
      throw Exception('Error loading assistances by neighborhood: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: dateRangeOptions.map((String dateRange) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedDateRange = dateRange;
                    assistancesByNeighborhoodFuture = getAssistancesByNeighborhood();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDateRange == dateRange
                      ? primaryColor
                      : Colors.grey[300],
                  side: BorderSide.none,
                ),
                child: Text(
                  dateRange,
                  style: GoogleFonts.poppins(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: selectedDateRange == dateRange
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Expanded(
          child: FutureBuilder<Map<String, int>>(
            future: assistancesByNeighborhoodFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              }

              final neighborhoodCounts = snapshot.data!;
              List<String> neighborhoods = neighborhoodCounts.keys.toList();
              List<BarChartGroupData> barGroups = [];

              for (int i = 0; i < neighborhoods.length; i++) {
                String neighborhood = neighborhoods[i];
                int count = neighborhoodCounts[neighborhood] ?? 0;

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
                          int index = value.toInt();
                          final style = GoogleFonts.poppins(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          );
                          if (index >= 0 && index < neighborhoods.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Transform.rotate(
                                angle: -0.45,
                                child: Text(neighborhoods[index], style: style),
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