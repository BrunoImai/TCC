import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/images_strings.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/constants/text_strings.dart';
import 'package:tcc_front/src/commom_widgets/fade_in_animation/fade_in_animation_controller.dart';

import '../../../../commom_widgets/fade_in_animation/animation_design.dart';
import '../../../../commom_widgets/fade_in_animation/fade_in_animation_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startSplashAnimation();

    return Scaffold(
      body: Stack(
        children: [
          FadeInAnimation(
            durationInMs: 2000,
            animate: AnimatePosition(
              topAfter: MediaQuery.of(context).size.height / 2 - defaultSize * 6,
              leftAfter: MediaQuery.of(context).size.width / 2 - defaultSize * 8.5,
              topBefore: -30,
              leftBefore: -30,
            ),
            child: const Image(image: AssetImage(splashTopIcon)),
          ),
          FadeInAnimation(
            durationInMs: 2000,
            animate: AnimatePosition(
                topBefore: 80,
                topAfter: 80,
                leftAfter: defaultSize,
                leftBefore: -80
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(appName,
                    style: Theme.of(context).textTheme.headline3),
                Text(appTagLine,
                    style: Theme.of(context).textTheme.headline2)
              ],
            ),
          ),
        ],
      ),
    );
  }
}