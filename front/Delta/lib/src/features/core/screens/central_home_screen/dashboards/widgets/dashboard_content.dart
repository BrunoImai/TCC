import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/analytic_cards.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/custom_appbar.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/discussions.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/top_referals.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/users.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/users_by_device.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/viewers.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/widgets/central_app_bar.dart';
import '../../../../../../constants/responsive.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, required this.whoAreYouTag});

  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          children: [
            CustomAppbar(whoAreYouTag: whoAreYouTag),
            const SizedBox(
              height: homePadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const AnalyticCards(),
                          const SizedBox(height: homePadding,),
                          const Users(),
                          if(Responsive.isMobile(context))
                            const SizedBox(height: homePadding,),
                          if(Responsive.isMobile(context))
                            const Discussions(),
                        ],
                      ),
                    ),
                    if(!Responsive.isMobile(context))
                      const SizedBox(width: homePadding,),
                    if(!Responsive.isMobile(context))
                    const Expanded(
                        flex: 2,
                        child: Discussions()
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const SizedBox(height: homePadding,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(!Responsive.isMobile(context))
                                const Expanded(
                                  flex: 2,
                                  child: TopReferals(),
                                ),
                              if(!Responsive.isMobile(context))
                                const SizedBox(width: homePadding,),
                              const Expanded(
                                flex: 3,
                                child: Viewers(),
                              ),
                            ],
                          ),
                          if(Responsive.isMobile(context))
                            const SizedBox(height: homePadding,),
                          if(Responsive.isMobile(context))
                            const TopReferals(),
                          if(Responsive.isMobile(context))
                            const UsersByDevice(),
                        ],
                      ),
                    ),
                    if(!Responsive.isMobile(context))
                      const SizedBox(width: homePadding,),
                    if(!Responsive.isMobile(context))
                      const Expanded(
                          flex: 2,
                          child: UsersByDevice()
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
