import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_front/src/commom_widgets/fade_in_animation/animation_design.dart';
import 'package:tcc_front/src/commom_widgets/fade_in_animation/fade_in_animation_controller.dart';
import 'package:tcc_front/src/commom_widgets/fade_in_animation/fade_in_animation_model.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/images_strings.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/constants/text_strings.dart';
import 'package:tcc_front/src/features/authentication/screens/login/login_screen.dart';


class WhoAreYouScreen extends StatelessWidget{

  const WhoAreYouScreen({super.key });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeInAnimationController());
    controller.startAnimation();

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? secondaryColor : whiteColor,
      body: Stack(
        children: [
          FadeInAnimation(
            durationInMs: 1200,
            animate: AnimatePosition(
              bottomAfter: 0,
              bottomBefore: -100,
              leftBefore: 0,
              leftAfter: 0,
              topAfter: 0,
              topBefore: 0,
              rightAfter: 0,
              rightBefore: 0,
            ),
            child: Container(
              padding: const EdgeInsets.all(defaultSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: 'welcome-image-tag',
                    child: Image(
                      image: const AssetImage(logoDegrade),
                      height: height * 0.6,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        tWhoAreYouTitle,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        tWhoAreYouSubTitle,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 800) {
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.to(() => const LoginScreen(whoAreYouTag: 1)),
                                child: Text(tEmployee.toUpperCase()),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Get.to(() => const LoginScreen(whoAreYouTag: 2)),
                                child: Text(tCompany.toUpperCase()),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.3,
                              child: OutlinedButton(
                                onPressed: () => Get.to(() => const LoginScreen(whoAreYouTag: 1)),
                                child: Text(tEmployee.toUpperCase()),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            SizedBox(
                              width: constraints.maxWidth * 0.3,
                              child: ElevatedButton(
                                onPressed: () => Get.to(() => const LoginScreen(whoAreYouTag: 2)),
                                child: Text(tCompany.toUpperCase()),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}