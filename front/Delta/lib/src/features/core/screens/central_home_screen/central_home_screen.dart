import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/custom_appbar.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_central_control.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_drawer_menu.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_search_bar.dart';

import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import 'dashboards/widgets/drawer_menu.dart';

class CentralHomeScreen extends StatefulWidget{
  const CentralHomeScreen({super.key, required this.whoAreYouTag});
  final num whoAreYouTag;

  @override
  State<CentralHomeScreen> createState() => _CentralHomeScreenState();



}

class _CentralHomeScreenState extends State<CentralHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CentralAppBar(whoAreYouTag: widget.whoAreYouTag),
      drawer: CentralDrawerMenu(whoAreYouTag: widget.whoAreYouTag),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(homePadding - 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Heading
            Text(tHomePageTitle + CentralManager.instance.loggedUser!.central.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(tExploreWorker, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const CentralSearchBar(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(tControlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            CentralCentralControl(whoAreYouTag: widget.whoAreYouTag,),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





