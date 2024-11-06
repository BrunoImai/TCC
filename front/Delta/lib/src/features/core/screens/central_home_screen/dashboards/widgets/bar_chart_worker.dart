import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../assistance/assistance.dart';
import '../../../worker/worker.dart';

class BarChartWorker extends StatefulWidget {
  const BarChartWorker({super.key});

  @override
  _BarChartWorkerState createState() => _BarChartWorkerState();
}

class _BarChartWorkerState extends State<BarChartWorker> {
  late Future<Map<String, int>> assistancesByWorkerFuture;

  final Map<String, String> statusOptions = {
    'AGUARDANDO': 'Aguardando',
    'EM_ANDAMENTO': 'Em andamento',
    'FINALIZADO': 'Finalizado',
  };
  String selectedStatus = 'EM_ANDAMENTO';

  @override
  void initState() {
    super.initState();
    assistancesByWorkerFuture = getAssistancesByWorker();
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
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<WorkersList> workersList = jsonData.map((item) {
          return WorkersList(
            id: item['id'],
            name: item['name'],
            email: item['email'],
            entryDate: item['entryDate'],
            cpf: item['cpf'],
            cellphone: item['cellphone'],
          );
        }).toList();

        return workersList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load worker list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de workers');
    }
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
            assistanceStatus: item['assistanceStatus']
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

  Future<Map<String, int>> getAssistancesByWorker() async {
    try {
      final assistances = await getAllAssistances();
      final workers = await getAllWorkers();

      final filteredAssistances = assistances.where((assistance) {
        return assistance.assistanceStatus == selectedStatus;
      }).toList();

      final Map<String, int> assistancesByWorker = {};
      for (var worker in workers) {
        int assistanceCount = filteredAssistances.where((assistance) {
          return assistance.workersIds.contains(worker.id);
        }).length;
        assistancesByWorker[worker.name] = assistanceCount;
      }

      return assistancesByWorker;
    } catch (e) {
      throw Exception('Error loading assistances by worker: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: homePadding - 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: statusOptions.keys.map((status) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedStatus = status;
                    assistancesByWorkerFuture = getAssistancesByWorker();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedStatus == status
                      ? primaryColor
                      : Colors.grey[300],
                  side: BorderSide.none,
                ),
                child: Text(
                  statusOptions[status]!,
                  style: GoogleFonts.poppins(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: selectedStatus == status ? Colors.white : Colors.black,
                ),
                ),
              ),
            );
          }).toList(),
        ),
        Expanded(
          child: FutureBuilder<Map<String, int>>(
            future: assistancesByWorkerFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              }
              final assistancesByWorker = snapshot.data!;
              List<BarChartGroupData> barGroups = [];
              List<String> xLabels = [];

              int i = 0;
              assistancesByWorker.forEach((workerName, count) {
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
                xLabels.add(workerName);
                i++;
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
                            fontSize: 10.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          );
                          int index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 8.0,
                              child: Transform.rotate(
                                angle: -0.45,
                                child: Text(xLabels[index], style: style),
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