import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';

class BarChartNeighborhood extends StatefulWidget {
  const BarChartNeighborhood({super.key});

  @override
  _BarChartNeighborhoodState createState() => _BarChartNeighborhoodState();
}

class _BarChartNeighborhoodState extends State<BarChartNeighborhood> {
  late Future<Map<String, int>> assistancesByNeighborhoodFuture;

  List<String> dateRangeOptions = ['Últimos 7 dias', 'Últimos 30 dias', 'Esse ano', 'Todos os anos'];
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
      Map<String, int> neighborhoodCounts = {};

      // Filter assistances within the date range
      DateTime now = DateTime.now();
      DateTime startDateRange;

      if (selectedDateRange == 'Últimos 7 dias') {
        startDateRange = now.subtract(Duration(days: 7));
      } else if (selectedDateRange == 'Últimos 30 dias') {
        startDateRange = now.subtract(Duration(days: 30));
      } else if (selectedDateRange == 'Esse ano') {
        startDateRange = DateTime(now.year, 1, 1);
      } else { // 'Todos os anos'
        startDateRange = DateTime(2000, 1, 1);
      }

      final filteredAssistances = assistances.where((assistance) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        return startDate.isAfter(startDateRange) && startDate.isBefore(now);
      }).toList();

      // Process and group by neighborhood-city
      for (var assistance in filteredAssistances) {
        List<String> addressParts = assistance.address.split(', ');
        if (addressParts.length > 2) {
          String neighborhood = addressParts[1].split(' - ')[1];
          String city = addressParts[2].split(' - ')[0];
          String key = '$neighborhood - $city';

          neighborhoodCounts[key] = (neighborhoodCounts[key] ?? 0) + 1;
        }
      }

      // Sort neighborhoods by count in descending order
      var sortedEntries = neighborhoodCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // Limit to top 10 neighborhoods (optional)
      int topN = 10;
      sortedEntries = sortedEntries.take(topN).toList();

      // Convert back to a Map
      neighborhoodCounts = Map.fromEntries(sortedEntries);

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
        const SizedBox(height: homePadding - 5,),
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
                                angle: -0.5,
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
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
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