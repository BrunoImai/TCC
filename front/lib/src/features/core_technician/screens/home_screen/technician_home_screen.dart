import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/images_strings.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core_technician/screens/home_screen/widgets/technician_appbar.dart';

import '../../../../constants/text_strings.dart';

class TechnicianHomeScreen extends StatelessWidget{
  const TechnicianHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            Text(homePageTitle, style: Theme.of(context).textTheme.bodyText2,),
            Text(exploreServices, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            Container(
              decoration: const BoxDecoration(border: Border(left: BorderSide(width: 4))),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(search, style: Theme.of(context).textTheme.headline2?.apply(color: Colors.grey.withOpacity(0.5))),
                  const Icon(Icons.search, size: 25),
                ],
              ),
            ),
            const SizedBox(height: homePadding,),

            //Next Service
            /*Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardBgColor),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                          children: const [
                            Flexible(child: Image(image: AssetImage(welcomeImage))),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),*/
          ],
        ),
        ),
      ),
    );
  }
}

