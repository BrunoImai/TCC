import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/profile/worker_profile_screen.dart';

import '../../../../../constants/images_strings.dart';
import '../../../../../constants/text_strings.dart';
import '../worker_home_screen.dart';

class WorkerAppBar extends StatelessWidget implements PreferredSizeWidget{
  const WorkerAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(Icons.menu),
      ),
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Get.to(() => const WorkerHomeScreen()),
          child: Text(appName, style: Theme.of(context).textTheme.headline4),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20, top: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
              onPressed: () => Get.to(() => const WorkerProfileScreen()),
              icon: const Image(image: AssetImage(userProfileImage))),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}