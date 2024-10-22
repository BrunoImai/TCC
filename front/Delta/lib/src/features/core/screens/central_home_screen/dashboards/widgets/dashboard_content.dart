import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_front/src/constants/sizes.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/analytic_cards.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/custom_appbar.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/current_assistances.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/work_delayed.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/assistances_chart.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/machine_part_exchange.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/revenue.dart';
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
                          const AssistancesChart(),
                          if(Responsive.isMobile(context))
                            const SizedBox(height: homePadding,),
                          if(Responsive.isMobile(context))
                            CurrentAssistances(whoAreYouTag: whoAreYouTag,),
                        ],
                      ),
                    ),
                    if(!Responsive.isMobile(context))
                      const SizedBox(width: homePadding,),
                    if(!Responsive.isMobile(context))
                    Expanded(
                        flex: 2,
                        child: CurrentAssistances(whoAreYouTag: whoAreYouTag)
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
                                  child: WorkDelayed(),
                                ),
                              if(!Responsive.isMobile(context))
                                const SizedBox(width: homePadding,),
                              const Expanded(
                                flex: 3,
                                child: Revenue(),
                              ),
                            ],
                          ),
                          if(Responsive.isMobile(context))
                            const SizedBox(height: homePadding,),
                          if(Responsive.isMobile(context))
                            const WorkDelayed(),
                          if(Responsive.isMobile(context))
                            const MachinePartExchange(),
                        ],
                      ),
                    ),
                    if(!Responsive.isMobile(context))
                      const SizedBox(width: homePadding,),
                    if(!Responsive.isMobile(context))
                      const Expanded(
                          flex: 2,
                          child: MachinePartExchange()
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
