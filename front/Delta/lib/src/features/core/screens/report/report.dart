class ReportRequest {
  final String name;
  final String description;
  final num clientId;
  final List<num> responsibleWorkersIds;
  final num? assistanceId;
  final String totalPrice;

  ReportRequest({
    required this.name,
    required this.description,
    required this.clientId,
    required this.responsibleWorkersIds,
    required this.assistanceId,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'clientId': clientId,
      'responsibleWorkersIds': responsibleWorkersIds,
      'assistanceId': assistanceId,
      'totalPrice': totalPrice
    };
  }
}


class ReportInformations {
  String? id;
  List<String> workersName;
  String clientName;
  ReportResponse report;

  ReportInformations(this.id, this.workersName, this.clientName, this.report);

}

class ReportResponse {
  final String? id;
  final String name;
  final String description;
  final String creationDate;
  final String status;
  final String? assistanceId;
  final String clientId;
  final List<String> responsibleWorkersIds;
  final String totalPrice;

  ReportResponse({required this.id, required this.name,required this.description, required this.creationDate, required this.status,
  required this.assistanceId, required this.clientId, required this.responsibleWorkersIds, required this.totalPrice});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'description': description,
      'creationDate': creationDate,
      'status': status,
      'assistanceId': assistanceId,
      'clientId': clientId,
      'responsibleWorkersIds': responsibleWorkersIds,
      'totalPrice': totalPrice
    };
  }
}