import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_app_bar.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_central_control.dart';
import 'package:tcc_front/src/features/core/screens/home_screen/widgets/company_search_bar.dart';

import '../../../../constants/text_strings.dart';

class CompanyHomeScreen extends StatelessWidget{
  const CompanyHomeScreen({Key? key}) : super(key: key);

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
            Text(exploreTechnician, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const Company_searchbar(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(controlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const Company_central_control(),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





