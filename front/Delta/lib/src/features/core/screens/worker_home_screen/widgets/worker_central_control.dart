import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../utils/notifications/notification_list_screen.dart';
import '../../assistance/assistance.dart';
import '../../budget/budget.dart';
import '../../budget/budget_list_screen.dart';
import '../../budget/register_budget_screen.dart';
import '../../report/register_report_screen.dart';
import '../../report/report_list_screen.dart';
import '../../worker/worker_manager.dart';

class WorkerCentralControl extends StatefulWidget {
  const WorkerCentralControl({
    super.key,
    required this.whoAreYouTag,
    this.selectedAssistance
  });

  final num whoAreYouTag;
  final AssistanceInformations? selectedAssistance;

  @override
  _WorkerCentralControlState createState() => _WorkerCentralControlState();
}

class _WorkerCentralControlState extends State<WorkerCentralControl> {
  String? budgetStatus;


  @override
  void initState() {
    super.initState();
    if (widget.selectedAssistance != null) {
      fetchBudgetStatus(widget.selectedAssistance!.assistance.id);
    }
  }

  @override
  void didUpdateWidget(covariant WorkerCentralControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAssistance != null && widget.selectedAssistance != oldWidget.selectedAssistance) {
      fetchBudgetStatus(widget.selectedAssistance!.assistance.id);
    }
  }

  Future<void> fetchBudgetStatus(String assistanceId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/worker/budget/byAssistance/$assistanceId'),
        headers: {
          'Authorization': 'Bearer ${WorkerManager.instance.loggedUser!.token}'
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody) as Map<String, dynamic>;
        final budget = BudgetResponse.fromJson(jsonData);

        setState(() {
          budgetStatus = budget.status;
        });
      } else {
        print('Failed to load budget. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching budget: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthFactor = screenWidth < 600 ? 1.0 : 0.3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Wrap(
          spacing: homePadding,
          runSpacing: homePadding,
          alignment: WrapAlignment.center,
          children: [
            // Notificações
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => NotificationListScreen(whoAreYouTag: widget.whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tNotificationsHistory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: darkColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Registrar orçamento
            FractionallySizedBox(
            widthFactor: widthFactor,
            child: ElevatedButton(
              onPressed: () => Get.to(() => RegisterBudgetScreen(whoAreYouTag: widget.whoAreYouTag)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: cardBgColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_money_rounded, size: 30, color: darkColor),
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        tRegisterBudget,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: darkColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

            // Histórico de orçamento
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => BudgetListScreen(whoAreYouTag: widget.whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on_outlined, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tBudgetHistory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: darkColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Registrar relatório
            if(budgetStatus == 'APROVADO')
              FractionallySizedBox(
                widthFactor: widthFactor,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => RegisterReportScreen(whoAreYouTag: widget.whoAreYouTag)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: cardBgColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: SizedBox(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.library_books_rounded, size: 30, color: darkColor),
                        const SizedBox(height: 10),
                        Flexible(
                          child: Text(
                            tRegisterReport,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: darkColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Histórico de relatórios
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => ReportListScreen(whoAreYouTag: widget.whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.subject_rounded, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tReports,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: darkColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}