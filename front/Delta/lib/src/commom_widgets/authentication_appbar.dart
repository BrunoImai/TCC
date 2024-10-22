import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../constants/text_strings.dart';
import '../features/authentication/screens/welcome/welcome_screen.dart';

class WelcomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WelcomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Get.to(() => const WelcomeScreen()),
          child: Text(tAppName, style: Theme.of(context).textTheme.headline4),
        ),
      ),
      centerTitle: true,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}