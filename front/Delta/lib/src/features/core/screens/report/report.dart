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
  String id;
  List<String> workersName;
  String clientName;
  ReportResponse assistance;
  List<String> categoriesName;

  ReportInformations(this.id, this.workersName, this.clientName, this.assistance, this.categoriesName);

}

class  UpdateReportRequest {
  final String description;
  final String name;
  final String address;
  final String complement;
  final String cpf;
  final String? period;
  final List<num> workersIds;
  final List<num> categoriesId;

  UpdateReportRequest({required this.description, required this.name, required this.address, required this.complement,required this.cpf,
    required this.period, required this.workersIds, required this.categoriesId});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'address': address,
      'cpf': cpf,
      'period': period,
      'workersIds': workersIds,
      'categoriesId': categoriesId
    };
  }
}

class ReportResponse {
  final String id;
  final String startDate;
  final String description;
  final String name;
  final String address;
  final String clientCpf;
  final String period;
  final List<String> workersIds;
  final List<String> categoryIds;

  ReportResponse({required this.id, required this.startDate,required this.description, required this.name, required this.address, required this.clientCpf,
    required this.period, required this.workersIds, required this.categoryIds});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'startDate': startDate,
      'description': description,
      'name': name,
      'address': address,
      'clientCpf': clientCpf,
      'period': period,
      'workersIds': workersIds,
      'categoryIds': categoryIds
    };
  }
}