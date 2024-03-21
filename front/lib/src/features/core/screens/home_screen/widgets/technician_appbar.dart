import 'package:flutter/material.dart';

import '../../../../../constants/images_strings.dart';
import '../../../../../constants/text_strings.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget{
  const HomeAppBar({
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
      title: Text(appName, style: Theme.of(context).textTheme.headline4),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20, top: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(onPressed: () {}, icon: const Image(image: AssetImage(userProfileImage))),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}