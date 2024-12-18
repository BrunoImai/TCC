import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tcc_front/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker_manager.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/profile/widgets/worker_profile_menu_widget.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/images_strings.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';


class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tProfile, style: Theme.of(context).textTheme.headline4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100), child: const Image(image: AssetImage(userProfileImage))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: primaryColor),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(utf8.decode(WorkerManager.instance.loggedUser!.worker.name.codeUnits), style: Theme.of(context).textTheme.headline4),
              Text(WorkerManager.instance.loggedUser!.worker.email, style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              WorkerProfileMenuWidget(title: tSettings, icon: LineAwesomeIcons.cog, onPress: () {}),
              WorkerProfileMenuWidget(title: tInformation, icon: LineAwesomeIcons.info, onPress: () {}),
              WorkerProfileMenuWidget(title: tUserManagement, icon: LineAwesomeIcons.user_check, onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              WorkerProfileMenuWidget(
                  title: tLogout,
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: tLogout.toUpperCase(),
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text("Tem certeza que deseja sair?"),
                      ),
                      confirm: Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.offAll(() => const WelcomeScreen()),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                          child: const Text("Sim"),
                        ),
                      ),
                      cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("Não")),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}