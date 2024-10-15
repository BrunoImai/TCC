import 'package:flutter/material.dart';
import '../../../../../../constants/colors.dart';
import '../models/current_assistances_info_model.dart';
import '../models/referal_info_model.dart';

List discussionData = [
  CurrentAssistancesInfoModel(
    icon: Icons.people,
    assistanceName: "Lutfhi Chan",
    date: "Jan 25,2021",
  ),
  CurrentAssistancesInfoModel(
    icon: Icons.people,
    assistanceName: "Devi Carlos",
    date: "Jan 25,2021",
  ),
  CurrentAssistancesInfoModel(
    icon: Icons.people,
    assistanceName: "Danar Comel",
    date: "Jan 25,2021",
  ),
  CurrentAssistancesInfoModel(
    icon: Icons.people,
    assistanceName: "Karin Lumina",
    date: "Jan 25,2021",
  ),
  CurrentAssistancesInfoModel(
    icon: Icons.people,
    assistanceName: "Fandid Deadan",
    date: "Jan 25,2021",
  ),
  CurrentAssistancesInfoModel(
    icon: Icons.people,
    assistanceName: "Lutfhi Chan",
    date: "Jan 25,2021",
  ),
];

List referalData = [
  ReferalInfoModel(
    title: "Facebook",
    count: 234,
    icon: Icons.facebook_rounded,
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Twitter",
    count: 234,
    icon: Icons.border_inner_rounded,
    color: primaryColor,
  ),
  ReferalInfoModel(
    title: "Linkedin",
    count: 234,
    icon: Icons.ac_unit_sharp,
    color: primaryColor,
  ),

  ReferalInfoModel(
    title: "Dribble",
    count: 234,
    icon: Icons.social_distance,
    color: primaryColor,
  ),
];
