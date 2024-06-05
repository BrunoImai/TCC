
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
  final num id;
  final String orderDate;
  final String description;
  final String name;
  final String address;
  final String cpf;
  final String period;
  final List<num> workersIds;


  AssistanceResponse({required this.id, required this.orderDate, required this.description, required this.name, required this.address, required this.cpf,
    required this.period, required this.workersIds});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'orderDate': orderDate,
      'description': description,
      'name': name,
      'address': address,
      'cpf': cpf,
      'period': period,
      'workersIds': workersIds
    };
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
  final String? period;
  final List<num> workersIds;

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
  final String clientName;
  final String period;
  final List<String> workersNames;

  AssistancesList({required this.id, required this.description, required this.name, required this.address, required this.clientName,
    required this.period, required this.workersNames});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'description': description,
      'name': name,
      'address': address,
      'clientName': clientName,
      'period': period,
      'workersIds': workersNames
    };
  }
}