import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/images_strings.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/central_home_screen.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/profile/profile_screen.dart';

import '../../../../../../constants/text_strings.dart';
import '../../../../../../utils/notifications/notification_list_screen.dart';
import '../../../assistance/assistance_list_screen.dart';
import '../../../assistance/register_assistance_screen.dart';
import '../../../budget/budget_list_screen.dart';
import '../../../budget/register_budget_screen.dart';
import '../../../category/category_list_screen.dart';
import '../../../category/register_category_screen.dart';
import '../../../client/client_list_screen.dart';
import '../../../client/register_client_screen.dart';
import '../../../report/register_report_screen.dart';
import '../../../report/report_list_screen.dart';
import '../../../worker/register_worker_screen.dart';
import '../../../worker/worker_list_screen.dart';
import 'drawer_list_tile.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key, required this.whoAreYouTag});

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
              tap: () => Get.to(() => CentralHomeScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
              title: tNotificationsHistory,
              icon: Icons.notifications,
              tap: () => Get.to(() => NotificationListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
              title: registerClient,
              icon: Icons.person_add,
              tap: () => Get.to(() => RegisterClientScreen(whoAreYouTag: whoAreYouTag,)),
          ),
          DrawerListTile(
              title: clients,
              icon: Icons.person_search,
              tap: () => Get.to(() => ClientListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: registerWorker,
            icon: Icons.person_add,
            tap: () => Get.to(() => RegisterWorkerScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: workers,
            icon: Icons.person_search,
            tap: () => Get.to(() => WorkerListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: registerService,
            icon: Icons.work,
            tap: () => Get.to(() => RegisterAssistanceScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: serviceHistory,
            icon: Icons.work_history,
            tap: () => Get.to(() => AssistanceListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: registerBudget,
            icon: Icons.attach_money_rounded,
            tap: () => Get.to(() => RegisterBudgetScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: registerBudget,
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
          DrawerListTile(
            title: tRegisterReport,
            icon: Icons.add_box_rounded,
            tap: () => Get.to(() => RegisterCategoryScreen(whoAreYouTag: whoAreYouTag)),
          ),
          DrawerListTile(
            title: tRegisterCategory,
            icon: Icons.category_rounded,
            tap: () => Get.to(() => CategoryListScreen(whoAreYouTag: whoAreYouTag)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: homePadding * 2),
            child: Divider(
              color: secondaryColor,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Perfil',
              icon: Icons.person,
              tap: () => Get.to(() => const ProfileScreen())
          ),
        ],
      ),
    );
  }
}
