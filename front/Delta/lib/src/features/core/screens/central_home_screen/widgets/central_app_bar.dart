import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/central_home_screen.dart';
import '../../../../../constants/images_strings.dart';
import '../../../../../constants/text_strings.dart';
import '../../../../../utils/notifications/notification_controller.dart';
import '../../../../../utils/notifications/unread_notification_screen.dart';
import '../profile/profile_screen.dart';

class CentralAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CentralAppBar({
    super.key,
    required this.whoAreYouTag,
  });

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.put(NotificationController(whoAreYouTag));

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
          onTap: () => Get.to(() => CentralHomeScreen(whoAreYouTag: whoAreYouTag)),
          child: Text(appName, style: Theme.of(context).textTheme.headline4),
        ),
      ),
      actions: [
        Obx(() => Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              iconSize: 28,
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Get.to(() => UnreadNotificationScreen(whoAreYouTag: whoAreYouTag,));
              },
            ),
            if (notificationController.unreadNotificationsCount.value > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    notificationController.unreadNotificationsCount.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        )
        ),
        // Ícone do perfil do usuário
        Container(
          margin: const EdgeInsets.only(right: 20, top: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            iconSize: 36,
            onPressed: () => Get.to(() => const ProfileScreen()),
            icon: const Image(image: AssetImage(userProfileImage)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
