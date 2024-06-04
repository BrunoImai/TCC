
import 'package:tcc_front/src/features/core/screens/worker/worker.dart';

class AssistanceRequest {
  final String description;
  final String name;
  final String address;
  final String cpf;
  final String? period;
  final List<num> workersIds;


  AssistanceRequest({
    required this.description,
    required this.name,
    required this.address,
    required this.cpf,
    required this.period,
    required this.workersIds
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'address': address,
      'cpf': cpf,
      'period': period,
      'workersIds': workersIds
    };
  }
}

class  AssistanceResponse{
  final String description;
  final String name;
  final String address;
  final String cpf;
  final String period;
  final String workersIds;


  AssistanceResponse(this.description, this.name, this.address, this.cpf,this.period, this.workersIds);

  factory AssistanceResponse.fromJson(Map<String, dynamic> json) {
    return AssistanceResponse(
      json['description'] as String,
      json['name'] as String,
      json['address'] as String,
      json['cpf'] as String,
      json['period'] as String,
      json['workersIds'] as String
    );
  }
}

class AssistanceInformations {
  String id;
  AssistancesList assistance;

  AssistanceInformations(this.id, this.assistance);

}

class  UpdateAssistanceRequest {
  final String description;
  final String name;
  final String address;
  final String cpf;
  final String period;
  final String workersIds;

  UpdateAssistanceRequest({required this.description, required this.name, required this.address, required this.cpf,
    required this.period, required this.workersIds});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'name': name,
      'address': address,
      'cpf': cpf,
      'period': period,
      'workersIds': workersIds
    };
  }
}

class AssistancesList {
  final num id;
  final String description;
  final String name;
  final String address;
  final String cpf;
  final String period;
  final List<num> workersIds;

  AssistancesList({required this.id, required this.description, required this.name, required this.address, required this.cpf,
    required this.period, required this.workersIds});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'description': description,
      'name': name,
      'address': address,
      'cpf': cpf,
      'period': period,
      'workersIds': workersIds
    };
  }
}