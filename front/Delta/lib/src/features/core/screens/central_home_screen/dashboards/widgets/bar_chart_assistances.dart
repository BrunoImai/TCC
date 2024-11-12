import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';

class BarChartAssistances extends StatefulWidget {
  const BarChartAssistances({super.key});

  @override
  _BarChartAssistancesState createState() => _BarChartAssistancesState();
}

class _BarChartAssistancesState extends State<BarChartAssistances> {
  late Future<Map<String, int>> assistancesGroupedFuture;

  List<String> dateRangeOptions = [
    'Últimos 7 dias',
    'Últimos 30 dias',
    'Esse ano',
    'Todos os anos',
    'Período personalizado'
  ];
  String selectedDateRange = 'Últimos 7 dias';
  DateTime? customStartDate;
  DateTime? customEndDate;

  @override
  void initState() {
    super.initState();
    assistancesGroupedFuture = getAssistancesByPeriod();
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
              assistanceStatus: item['assistanceStatus']);
        }).toList();

        return assistancesList;
      } else {
        throw Exception('Failed to load assistance list');
      }
    } catch (e) {
      throw Exception('Error loading assistances: $e');
    }
  }

  Future<Map<String, int>> getAssistancesByPeriod() async {
    try {
      final assistances = await getAllAssistances();
      Map<DateTime, int> tempGroupedAssistances = {};

      DateTime now = DateTime.now();
      DateTime nowDateOnly = DateTime(now.year, now.month, now.day);

      DateTime startDateRange;
      DateTime endDateRange = nowDateOnly;

      switch (selectedDateRange) {
        case 'Últimos 7 dias':
          startDateRange = nowDateOnly.subtract(Duration(days: 6));
          break;
        case 'Últimos 30 dias':
          startDateRange = nowDateOnly.subtract(Duration(days: 29));
          break;
        case 'Esse ano':
          startDateRange = DateTime(now.year, 1, 1);
          break;
        case 'Todos os anos':
          startDateRange = DateTime(now.year - 10, 1, 1);
          break;
        case 'Período personalizado':
          if (customStartDate != null && customEndDate != null) {
            startDateRange = DateTime(customStartDate!.year,
                customStartDate!.month, customStartDate!.day);
            endDateRange = DateTime(
                customEndDate!.year, customEndDate!.month, customEndDate!.day);
          } else {
            throw Exception('No custom date range selected');
          }
          break;
        default:
          startDateRange = DateTime(now.year - 10, 1, 1);
          break;
      }

      DateTime current = startDateRange;
      while (current.isBefore(endDateRange) ||
          current.isAtSameMomentAs(endDateRange)) {
        tempGroupedAssistances[current] = 0;
        if (selectedDateRange == 'Esse ano') {
          current = DateTime(current.year, current.month + 1, 1);
        } else if (selectedDateRange == 'Todos os anos') {
          current = DateTime(current.year + 1, 1, 1);
        } else {
          current = current.add(Duration(days: 1));
        }
      }

      for (var assistance in assistances) {
        DateTime startDate = DateTime.parse(assistance.startDate);
        DateTime keyDate;

        if (startDate.isBefore(startDateRange) ||
            startDate.isAfter(endDateRange)) {
          continue;
        }

        if (selectedDateRange == 'Esse ano') {
          keyDate = DateTime(startDate.year, startDate.month, 1);
        } else if (selectedDateRange == 'Todos os anos') {
          keyDate = DateTime(startDate.year, 1, 1);
        } else {
          keyDate = DateTime(startDate.year, startDate.month, startDate.day);
        }

        if (tempGroupedAssistances.containsKey(keyDate)) {
          tempGroupedAssistances[keyDate] =
              (tempGroupedAssistances[keyDate] ?? 0) + 1;
        }
      }

      final sortedGroupedAssistances = Map.fromEntries(
          tempGroupedAssistances.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)));

      Map<String, int> finalGroupedAssistances = {};
      for (var entry in sortedGroupedAssistances.entries) {
        String formattedKey;
        if (selectedDateRange == 'Esse ano') {
          formattedKey = DateFormat('MMM yyyy', 'pt_BR').format(entry.key);
        } else if (selectedDateRange == 'Todos os anos') {
          formattedKey = DateFormat('yyyy').format(entry.key);
        } else {
          formattedKey = DateFormat('dd/MM/yy').format(entry.key);
        }
        finalGroupedAssistances[formattedKey] = entry.value;
      }

      return finalGroupedAssistances;
    } catch (e) {
      throw Exception('Error loading assistances by period: $e');
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
                onPressed: () async {
                  if (dateRange == 'Período personalizado') {
                    final picked = await showDateRangePicker(
                      context: context,
                      initialDateRange:
                          customStartDate != null && customEndDate != null
                              ? DateTimeRange(
                                  start: customStartDate!, end: customEndDate!)
                              : null,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      setState(() {
                        customStartDate = picked.start;
                        customEndDate = picked.end;
                        selectedDateRange = dateRange;
                        assistancesGroupedFuture = getAssistancesByPeriod();
                      });
                    }
                  } else {
                    setState(() {
                      selectedDateRange = dateRange;
                      assistancesGroupedFuture = getAssistancesByPeriod();
                    });
                  }
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
        if (selectedDateRange == 'Período personalizado' &&
            customStartDate != null &&
            customEndDate != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Período: ${DateFormat('dd/MM/yyyy').format(customStartDate!)} - ${DateFormat('dd/MM/yyyy').format(customEndDate!)}',
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        const SizedBox(height: 16.0),
        Expanded(
          child: FutureBuilder<Map<String, int>>(
            future: assistancesGroupedFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Sem dados disponíveis');
              }

              final groupedAssistances = snapshot.data!;
              List<String> xLabels = groupedAssistances.keys.toList();
              List<BarChartGroupData> barGroups = [];

              for (int i = 0; i < xLabels.length; i++) {
                final label = xLabels[i];
                final count = groupedAssistances[label] ?? 0;

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
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Transform.rotate(
                                angle: -0.8,
                                child: Text(xLabels[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 8.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    )),
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
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text('${value.toInt()}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
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
