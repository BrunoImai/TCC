import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/profile_info.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_search_bar.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/responsive.dart';
import '../../../../../../constants/text_strings.dart';
import '../../../../../../controllers/controller.dart';
import '../../central_home_screen.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key,required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: context.read<Controller>().controlMenu,
            icon: const Icon(Icons.menu),
          ),
        Expanded(
          child: Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Get.to(() => CentralHomeScreen(whoAreYouTag: whoAreYouTag)),
                child: Text(
                  appName,
                  style: Theme.of(context).textTheme.headline4
                ),
              ),
            ),
          ),
        ),
        ProfileInfo(whoAreYouTag: whoAreYouTag,)
      ],
    );
  }
}
