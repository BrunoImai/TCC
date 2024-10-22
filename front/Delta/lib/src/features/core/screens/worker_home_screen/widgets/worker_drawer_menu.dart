import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/images_strings.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import '../../../../../commom_widgets/drawer_list_tile.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../utils/notifications/notification_list_screen.dart';
import '../../budget/budget_list_screen.dart';
import '../../budget/register_budget_screen.dart';
import '../../report/register_report_screen.dart';
import '../../report/report_list_screen.dart';
import '../profile/worker_profile_screen.dart';
import '../worker_home_screen.dart';

class WorkerDrawerMenu extends StatelessWidget {
  const WorkerDrawerMenu({super.key, required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(homePadding),
            child: Image.asset(welcomeImage),
          ),
          DrawerListTile(
              title: 'Home',
              icon: Icons.home_rounded,
              tap: () => Get.to(() => WorkerHomeScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
              title: tNotificationsHistory,
              icon: Icons.notifications,
              tap: () => Get.to(() => NotificationListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: tRegisterBudget,
            icon: Icons.attach_money_rounded,
            tap: () => Get.to(() => RegisterBudgetScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: tRegisterBudget,
            icon: Icons.monetization_on_outlined,
            tap: () => Get.to(() => BudgetListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: tRegisterReport,
            icon: Icons.library_books_rounded,
            tap: () => Get.to(() => RegisterReportScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: tReports,
            icon: Icons.subject_rounded,
            tap: () => Get.to(() => ReportListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: homePadding * 2),
            child: Divider(
              color: primaryColor,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Perfil',
              icon: Icons.person,
              tap: () => Get.to(() => const WorkerProfileScreen())
          ),
        ],
      ),
    );
  }
}
