import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/radial_painter.dart';
import 'package:http/http.dart' as http;
import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../../../authentication/screens/signup/central_manager.dart';
import '../../../report/report.dart';

class WorkDelayed extends StatefulWidget {
  const WorkDelayed({super.key});

  @override
  _WorkDelayedState createState() => _WorkDelayedState();
}


class _WorkDelayedState extends State<WorkDelayed>{
  double percent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<ReportResponse> reports = await getAllReports();

      int totalReports = reports.length;
      print('totalReports D: $totalReports');
      int reportsWithWorkDelayed = reports
          .where((report) => report.delayed == true)
          .length;
      print('reportsWithWorkDelayed $reportsWithWorkDelayed');

      setState(() {
        percent = totalReports > 0 ? reportsWithWorkDelayed / totalReports : 0.0;
        print('percent D $percent');
      });
    } catch (e) {
      print('Erro ao carregar os dados: $e');
    }
  }

  Future<List<ReportResponse>> getAllReports() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/report'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as List<dynamic>;

        final List<ReportResponse> reportsList = jsonData.map((item) {
          return ReportResponse(
            id: item['id'].toString(),
            name: item['name'],
            description: item['description'],
            creationDate: item['creationDate'],
            status: item['status'],
            assistanceId: item['assistanceId'],
            responsibleWorkersIds:
            (item['workersIds'] as List<dynamic>).map((id) => id.toString()).toList(),
            paymentType: item['paymentType'],
            machinePartExchange: item['machinePartExchange'],
            delayed: item['delayed'],
          );
        }).toList();

        return reportsList;
      } else {
        throw Exception('Failed to load report list');
      }
    } catch (e) {
      throw Exception('Erro ao carregar a lista de relatórios: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 351,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(homePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assitências que tiveram atraso',
            style: TextStyle(
              color: darkColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(homePadding),
            padding: const EdgeInsets.all(homePadding),
            height: 230,
            child: CustomPaint(
              foregroundPainter: RadialPainter(
                bgColor: darkColor.withOpacity(0.1),
                lineColor: primaryColor,
                percent: percent,
                width: 18.0,
              ),
              child: Center(
                child: Text(
                  '${(percent * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: darkColor,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: homePadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: primaryColor,
                      size: 10,
                    ),
                    const SizedBox(width: homePadding /2,),
                    Text('Sim',style: TextStyle(
                      color: darkColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: darkColor.withOpacity(0.2),
                      size: 10,
                    ),
                    const SizedBox(width: homePadding /2,),
                    Text('Não',style: TextStyle(
                      color: darkColor.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
