class AssistanceRequest {
  final String description;
  final String name;
  final String address;
  final String? complement;
  final String cpf;
  final String period;
  final List<num> categoriesId;
  final List<num> workersIds;


  AssistanceRequest({
    required this.description,
    required this.name,
    required this.address,
    this.complement,
    required this.cpf,
    required this.period,
    required this.categoriesId,
    required this.workersIds
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'address': address,
      'complement': complement,
      'cpf': cpf,
      'period': period,
      'categoriesId': categoriesId,
      'workersIds': workersIds
    };
  }
}


class AssistanceInformations {
  String id;
  List<String> workersName;
  String clientName;
  AssistanceResponse assistance;
  List<String> categoriesName;

  AssistanceInformations(this.id, this.workersName, this.clientName, this.assistance, this.categoriesName);

}

class  UpdateAssistanceRequest {
  final String description;
  final String name;
  final String address;
  final String? complement;
  final String cpf;
  final String? period;
  final List<num> workersIds;
  final List<num> categoriesId;

  UpdateAssistanceRequest({required this.description, required this.name, required this.address, this.complement,required this.cpf,
    required this.period, required this.workersIds, required this.categoriesId});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'address': address,
      'complement': complement,
      'cpf': cpf,
      'period': period,
      'workersIds': workersIds,
      'categoriesId': categoriesId
    };
  }
}

class AssistanceResponse {
  final String id;
  final String startDate;
  final String description;
  final String name;
  final String address;
  final String? complement;
  final String clientCpf;
  final String period;
  final List<String> workersIds;
  final List<String> categoryIds;
  final String assistanceStatus;

  AssistanceResponse({
    required this.id,
    required this.startDate,
    required this.description,
    required this.name,
    required this.address,
    required this.complement,
    required this.clientCpf,
    required this.period,
    required this.workersIds,
    required this.categoryIds,
    required this.assistanceStatus
  });

  factory AssistanceResponse.fromJson(Map<String, dynamic> json) {
    return AssistanceResponse(
      id: json['id'].toString(),
      startDate: json['startDate'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      complement: json['complement'] as String?,
      clientCpf: json['cpf'] as String,
      period: json['period'] as String,
      workersIds: List<String>.from(
        (json['workersIds'] as List<dynamic>).map((e) => e.toString()),
      ),
      categoryIds: List<String>.from(
        (json['categoryIds'] as List<dynamic>).map((e) => e.toString()),
      ),
      assistanceStatus: json['assistanceStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate,
      'description': description,
      'name': name,
      'address': address,
      'complement': complement,
      'clientCpf': clientCpf,
      'period': period,
      'workersIds': workersIds,
      'categoryIds': categoryIds,
      'assistanceStatus': assistanceStatus
    };
  }
}