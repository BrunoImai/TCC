
class WorkerRequest {
  final String name;
  final String email;
  final String cpf;
  final String cellphone;
  final String password;


  WorkerRequest({
    required this.name,
    required this.email,
    required this.cpf,
    required this.cellphone,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cellphone': cellphone,
      'email': email,
      'cpf': cpf,
      'password': password
    };
  }
}

class  WorkerResponse{
  final num id;
  final String name;
  final String email;
  final String entryDate;
  final String cpf;
  final String cellphone;

  WorkerResponse(this.id, this.name, this.email, this.entryDate, this.cpf, this.cellphone);


  factory WorkerResponse.fromJson(Map<String, dynamic> json) {
    return WorkerResponse(
      json['id'] as num,
      json['name'] as String,
      json['email'] as String,
      json['entryDate'] as String,
      json['cpf'] as String,
      json['cellphone'] as String
    );
  }
}

class WorkerInformations {
  String id;
  WorkersList worker;

  WorkerInformations(this.id, this.worker);

}

class LoggedWorker {
  String token;
  WorkerResponse worker;

  LoggedWorker(this.token, this.worker);
}

class  UpdateWorkerRequest {
  final String name;
  final String email;
  final String cpf;
  final String cellphone;
  final String oldPassword;
  final String? newPassword;

  UpdateWorkerRequest({required this.name, required this.email, required this.cpf,
    required this.cellphone, required this.oldPassword, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cpf': cpf,
      'cellphone': cellphone,
      'oldPassword' : oldPassword,
      'newPassword' : newPassword
    };
  }
}

class WorkersList {
  final num id;
  final String name;
  final String email;
  final String entryDate;
  final String cpf;
  final String cellphone;

  WorkersList({required this.id, required this.name, required this.email, required this.entryDate, required this.cpf,
    required this.cellphone});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'email': email,
      'entryDate' : entryDate,
      'cpf': cpf,
      'cellphone': cellphone,
    };
  }
}