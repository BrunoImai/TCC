import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/constants/images_strings.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/technician_appbar.dart';

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
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                      },
                      decoration: InputDecoration(
                        hintText: search,
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search, size: 25),
                        ),
                      ),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: homePadding,),

            //Next Service
            Text(nextService, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            SizedBox(
              width: double.infinity,
              height: 320,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "Rua ...",
                            style: Theme.of(context).textTheme.headline4,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                            child: const Image(image: AssetImage(welcomeImage), height: 110,)
                          ),
                        ],
                      ),
                    /*Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                          onPressed: (){},
                          child: const Icon(Icons.play_arrow),
                        ),
                        SizedBox(width: homeCardPadding,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list[index].heading,
                              style: txtTheme.headline4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              list[index].subHeading,
                              style: txtTheme.bodyText2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

