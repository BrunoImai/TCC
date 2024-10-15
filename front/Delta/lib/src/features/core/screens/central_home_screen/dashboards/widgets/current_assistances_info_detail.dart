import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../../../assistance/update_assistance_screen.dart';
import '../models/current_assistances_info_model.dart';


class CurrentAssistancesInfoDetail extends StatelessWidget {
  const CurrentAssistancesInfoDetail({super.key, required this.info, required this.whoAreYouTag});

  final CurrentAssistancesInfoModel info;
  final num whoAreYouTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: homePadding),
      padding: const EdgeInsets.all(homePadding / 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Icon(
              info.icon!,
              size: 38,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: homePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.assistanceName!,
                    style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: darkColor
                    ),
                  ),

                  Text(
                    info.clientName!,
                    style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: darkColor
                    ),
                  ),

                  Text(
                    info.workersName!,
                    style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: darkColor
                    ),
                  ),

                  Text(
                    info.status!,
                    style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: darkColor.withOpacity(0.5)
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => UpdateAssistanceScreen(assistance: info.assistanceResponse!, whoAreYouTag: whoAreYouTag,));
            },
            icon: Icon(Icons.more_vert_rounded, color: primaryColor.withOpacity(0.5),size: 18,),
          ),
        ],
      ),
    );
  }
}
