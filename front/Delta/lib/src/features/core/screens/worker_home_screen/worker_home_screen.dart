import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_central_control.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_coordinates.dart';
import 'package:tcc_front/src/features/core/screens/worker_home_screen/widgets/worker_search_bar.dart';
import 'package:tcc_front/src/features/core/screens/worker/worker_manager.dart';

import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class WorkerHomeScreen extends StatefulWidget{
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();

}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WorkerAppBar(),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Heading
            Text(homePageTitle + WorkerManager.instance.loggedUser!.worker.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(exploreServices, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const WorkerSearchBar(),
            const SizedBox(height: homePadding,),

            //Current and next service
            Text(currentAndNextAssistance, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const WorkerCoordinates(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(controlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const WorkerCentralControl(),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





