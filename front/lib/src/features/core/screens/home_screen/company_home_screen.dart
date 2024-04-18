import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_central_control.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_search_bar.dart';

import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class CompanyHomeScreen extends StatefulWidget{
  const CompanyHomeScreen({super.key});

  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();



}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {


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
            Text(homePageTitle + CentralManager.instance.loggedUser!.central.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(exploreTechnician, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const CompanySearchBar(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(controlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const CompanyCentralControl(),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





