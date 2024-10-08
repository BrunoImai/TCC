import 'package:flutter/material.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/dashboard_content.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/drawer_menu.dart';
import '../../../../../constants/responsive.dart';
import '../../../../../controllers/controller.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key, required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context, listen: false);
    return Scaffold(
      drawer: DrawerMenu(whoAreYouTag: whoAreYouTag,),
      key: controller.scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: DrawerMenu(whoAreYouTag: whoAreYouTag,),),
            Expanded(
              flex: 5,
              child: DashboardContent(whoAreYouTag: whoAreYouTag,),
            )
          ],
        ),
      ),
    );
  }
}
