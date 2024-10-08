import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/profile_info.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_search_bar.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/responsive.dart';
import '../../../../../../controllers/controller.dart';

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
            icon: Icon(Icons.menu, color: darkColor.withOpacity(0.5),),
          ),
        Expanded(child: CentralSearchBar()),
        ProfileInfo(whoAreYouTag: whoAreYouTag,)
      ],
    );
  }
}
