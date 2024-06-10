
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
  final String startDate;
  final String description;
  final String name;
  final String address;
  final String cpf;
  final String period;
  final List<num> workersIds;


  AssistanceResponse({required this.id, required this.startDate, required this.description, required this.name, required this.address, required this.cpf,
    required this.period, required this.workersIds});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'startDate': startDate,
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
  final String startDate;
  final String description;
  final String name;
  final String address;
  final String clientCpf;
  final String period;
  final List<String> workersIds;

  AssistancesList({required this.id, required this.startDate,required this.description, required this.name, required this.address, required this.clientCpf,
    required this.period, required this.workersIds});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'startDate': startDate,
      'description': description,
      'name': name,
      'address': address,
      'clientCpf': clientCpf,
      'period': period,
      'workersIds': workersIds
    };
  }
}