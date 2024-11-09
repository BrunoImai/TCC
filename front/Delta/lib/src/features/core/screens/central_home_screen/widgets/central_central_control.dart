
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/src/features/core/screens/assistance/assistance_list_screen.dart';
import 'package:tcc_front/src/features/core/screens/category/category_list_screen.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/dash_board_screen.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../controllers/controller.dart';
import '../../../../../utils/notifications/notification_list_screen.dart';
import '../../budget/budget_list_screen.dart';
import '../../budget/register_budget_screen.dart';
import '../../category/register_category_screen.dart';
import '../../client/client_list_screen.dart';
import '../../client/register_client_screen.dart';
import '../../report/register_report_screen.dart';
import '../../report/report_list_screen.dart';
import '../../worker/register_worker_screen.dart';
import '../../worker/worker_list_screen.dart';
import '../../assistance/register_assistance_screen.dart';

class CentralCentralControl extends StatelessWidget {
  const CentralCentralControl({
    super.key, required this.whoAreYouTag
  });

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthFactor = screenWidth < 600 ? 0.3 : 0.2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Wrap(
          spacing: homePadding - 5,
          runSpacing: homePadding - 5,
          alignment: WrapAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => NotificationListScreen(whoAreYouTag: whoAreYouTag)),
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
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterClientScreen(whoAreYouTag: whoAreYouTag,)),
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
                      const Icon(Icons.person_add, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterClient,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => ClientListScreen(whoAreYouTag: whoAreYouTag)),
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
                      const Icon(Icons.person_search, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tClients,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterWorkerScreen(whoAreYouTag: whoAreYouTag)),
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
                      const Icon(Icons.person_add, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterWorker,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => WorkerListScreen(whoAreYouTag: whoAreYouTag)),
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
                      const Icon(Icons.person_search, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tWorkers,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterAssistanceScreen(whoAreYouTag: whoAreYouTag)),
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
                      const Icon(Icons.work, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterService,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => AssistanceListScreen(whoAreYouTag: whoAreYouTag,)),
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
                      const Icon(Icons.work_history, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tServiceHistory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterBudgetScreen(whoAreYouTag: whoAreYouTag)),
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
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => BudgetListScreen(whoAreYouTag: whoAreYouTag,)),
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
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterReportScreen(whoAreYouTag: whoAreYouTag)),
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
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => ReportListScreen(whoAreYouTag: whoAreYouTag,)),
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
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterCategoryScreen(whoAreYouTag: whoAreYouTag,)),
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
                      const Icon(Icons.add_box_rounded, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterCategory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => CategoryListScreen(whoAreYouTag: whoAreYouTag,)),
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
                      const Icon(Icons.category_rounded, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tCategories,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: widthFactor,
              child: ElevatedButton(
                onPressed: () => Get.to(() => DashBoardScreen(whoAreYouTag: whoAreYouTag),),
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
                      const Icon(Icons.insert_chart_outlined, size: 30, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tDashboards,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: darkColor),
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