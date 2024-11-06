import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';
import 'package:tcc_front/src/features/core/screens/central_home_screen/dashboards/widgets/bar_chart_worker.dart';

import '../../../../../../constants/sizes.dart';
import 'bar_chart_assistances.dart';


class WorkerChart extends StatelessWidget {
  const WorkerChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      padding: const EdgeInsets.all(homePadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quantidade de serviços por funcionário",
            style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: darkColor
            ),
          ),
          const Expanded(
            child: BarChartWorker(),
          )
        ],
      ),
    );
  }
}
