import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/authentication/screens/signup/central_manager.dart';

import '../../../../../../constants/images_strings.dart';
import '../../../../../../constants/responsive.dart';
import '../../../../../../utils/notifications/notification_controller.dart';
import '../../../../../../utils/notifications/unread_notification_screen.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key,required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.put(NotificationController(whoAreYouTag));


    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(homePadding),
          child: Stack(
            children: [
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
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: homePadding),
          padding: const EdgeInsets.symmetric(
            horizontal: homePadding,
            vertical: homePadding / 2,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  userProfileImage,
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                ),
              ),
              if(!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: homePadding / 2),
                child: Text('Olá, ${CentralManager.instance.loggedUser!.central.name}', style: Theme.of(context).textTheme.headline4),
              )
            ],
          ),
        )
      ],
    );
  }
}
