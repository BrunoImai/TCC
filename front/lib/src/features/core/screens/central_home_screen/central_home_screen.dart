import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_central_control.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_search_bar.dart';

import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class CentralHomeScreen extends StatefulWidget{
  const CentralHomeScreen({super.key});

  @override
  State<CentralHomeScreen> createState() => _CentralHomeScreenState();



}

class _CentralHomeScreenState extends State<CentralHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CentralAppBar(),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Heading
            Text(homePageTitle + CentralManager.instance.loggedUser!.central.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(exploreTechnician, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const CentralSearchBar(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(controlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const CentralCentralControl(),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





