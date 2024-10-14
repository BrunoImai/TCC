import 'package:flutter/material.dart';
import '../../../../../../constants/colors.dart';
import '../../../../../../constants/sizes.dart';
import '../models/referal_info_model.dart';


class ReferalInfoDetail extends StatelessWidget {
  const ReferalInfoDetail({super.key, required this.info});

  final ReferalInfoModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: homePadding),
      padding: const EdgeInsets.all(homePadding / 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(homePadding / 1.5),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: info.color!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              info.icon!,
              color: info.color!,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: homePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: darkColor,
                    ),
                  ),
                  Text(
                    '${info.count!}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
