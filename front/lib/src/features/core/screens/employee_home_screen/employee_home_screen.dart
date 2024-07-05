import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/employee_home_screen/widgets/employee_central_control.dart';
import 'package:tcc_front/src/features/core/screens/employee_home_screen/widgets/employee_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/employee_home_screen/widgets/employee_search_bar.dart';

import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class EmployeeHomeScreen extends StatefulWidget{
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();

}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmployeeHomeAppBar(),
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
            const EmployeeSearchBar(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(controlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const EmployeeCentralControl(),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





