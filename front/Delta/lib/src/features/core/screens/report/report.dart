class ReportRequest {
  final String name;
  final String description;
  final List<num> responsibleWorkersIds;
  final num? assistanceId;
  final String paymentType;
  final bool machinePartExchange;
  final bool delayed;

  ReportRequest({
    required this.name,
    required this.description,
    required this.responsibleWorkersIds,
    required this.assistanceId,
    required this.paymentType,
    required this.machinePartExchange,
    required this.delayed
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'responsibleWorkersIds': responsibleWorkersIds,
      'assistanceId': assistanceId,
      'paymentType': paymentType,
      'machinePartExchange': machinePartExchange,
      'delayed': delayed
    };
  }
}


class ReportInformations {
  String? id;
  List<String> workersName;
  ReportResponse report;

  ReportInformations(this.id, this.workersName, this.report);

}

class UpdateReportRequest {
  final String name;
  final String description;
  final String status;
  final num? assistanceId;
  final List<num> responsibleWorkersIds;
  final String paymentType;
  final bool machinePartExchange;
  final bool delayed;

  UpdateReportRequest({required this.name,required this.description, required this.status,
    required this.assistanceId, required this.responsibleWorkersIds, required this.paymentType,
    required this.machinePartExchange, required this.delayed});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'assistanceId': assistanceId,
      'responsibleWorkersIds': responsibleWorkersIds,
      'paymentType': paymentType,
      'machinePartExchange': machinePartExchange,
      'delayed': delayed
    };
  }
}

class ReportResponse {
  final String? id;
  final String name;
  final String description;
  final String creationDate;
  final String status;
  final String? assistanceId;
  final List<String> responsibleWorkersIds;
  final String paymentType;
  final bool machinePartExchange;
  final bool delayed;

  ReportResponse({required this.id, required this.name,required this.description, required this.creationDate, required this.status,
  required this.assistanceId, required this.responsibleWorkersIds, required this.paymentType,
    required this.machinePartExchange, required this.delayed});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'description': description,
      'creationDate': creationDate,
      'status': status,
      'assistanceId': assistanceId,
      'responsibleWorkersIds': responsibleWorkersIds,
      'paymentType': paymentType,
      'machinePartExchange': machinePartExchange,
      'delayed': delayed
    };
  }
}