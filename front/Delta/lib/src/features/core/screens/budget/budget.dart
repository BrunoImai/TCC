class BudgetRequest {
  final String name;
  final String description;
  final num clientId;
  final List<num> responsibleWorkersIds;
  final num? assistanceId;
  final String totalPrice;

  BudgetRequest({
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


class BudgetInformations {
  String? id;
  List<String> workersName;
  String clientName;
  BudgetResponse budget;

  BudgetInformations(this.id, this.workersName, this.clientName, this.budget);
}

class UpdateBudgetRequest {
  final String name;
  final String description;
  final String status;
  final num? assistanceId;
  final num clientId;
  final List<num> responsibleWorkersIds;
  final String totalPrice;

  UpdateBudgetRequest({required this.name,required this.description, required this.status,
    required this.assistanceId, required this.clientId, required this.responsibleWorkersIds, required this.totalPrice});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'assistanceId': assistanceId,
      'clientId': clientId,
      'responsibleWorkersIds': responsibleWorkersIds,
      'totalPrice': totalPrice
    };
  }
}

class BudgetResponse {
  final String? id;
  final String name;
  final String description;
  final String creationDate;
  final String status;
  final String? assistanceId;
  final String clientId;
  final List<String> responsibleWorkersIds;
  final String totalPrice;

  BudgetResponse({required this.id, required this.name,required this.description, required this.creationDate, required this.status,
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