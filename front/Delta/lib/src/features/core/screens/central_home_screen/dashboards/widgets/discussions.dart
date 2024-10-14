import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_front/src/constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../data/data.dart';
import 'discussion_info_detail.dart';

class Discussions extends StatelessWidget {
  const Discussions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      padding: const EdgeInsets.all(homePadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discussions',
                 style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: darkColor
                ),
              ),
              Text(
                'View All',
                style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w200,
                    color: darkColor.withOpacity(0.5)
                ),
              ),
            ],
          ),
          const SizedBox(
            height: homePadding,
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: discussionData.length,
              itemBuilder: (context, index) => DiscussionInfoDetail(info: discussionData[index],),
            ),
          )
        ],
      ),
    );
  }
}
