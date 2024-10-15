import 'package:flutter/material.dart';

import '../../../assistance/assistance.dart';

class CurrentAssistancesInfoModel {
  final String? assistanceName, clientName, workersName, date, status;
  final Color? color;
  final IconData? icon;
  final AssistanceResponse? assistanceResponse;

  CurrentAssistancesInfoModel({
    this.icon,
    this.assistanceName,
    this.clientName,
    this.workersName,
    this.status,
    this.date,
    this.color,
    this.assistanceResponse
  });
}
