
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/features/core/screens/assistance/assistance_list_screen.dart';
import 'package:tcc_front/src/features/core/screens/category/category_list_screen.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../budget/budget_list_screen.dart';
import '../../budget/register_budget_screen.dart';
import '../../category/register_category_screen.dart';
import '../../client/client_list_screen.dart';
import '../../client/register_client_screen.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Wrap(
          spacing: homePadding,
          runSpacing: homePadding,
          alignment: WrapAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterClientScreen(whoAreYouTag: whoAreYouTag,)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_add, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          registerClient,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => ClientListScreen(whoAreYouTag: whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_search, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          clients,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterWorkerScreen(whoAreYouTag: whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_add, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          registerWorker,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => WorkerListScreen(whoAreYouTag: whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_search, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          workers,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterAssistanceScreen(whoAreYouTag: whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.work, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          registerService,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => AssistanceListScreen(whoAreYouTag: whoAreYouTag,)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.work_history, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          serviceHistory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterBudgetScreen(whoAreYouTag: whoAreYouTag)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.library_books_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          registerBudget,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => BudgetListScreen(whoAreYouTag: whoAreYouTag,)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.subject_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          budgetHistory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => RegisterCategoryScreen(whoAreYouTag: whoAreYouTag,)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_box_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterCategory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => CategoryListScreen(whoAreYouTag: whoAreYouTag,)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.category_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tCategories,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.attach_money, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          comissionControl,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //const SizedBox(width: homeCardPadding,),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_chart_outlined, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          dashboards,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
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