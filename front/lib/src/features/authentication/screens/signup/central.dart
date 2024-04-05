
class CentralRequest {
  final String name;
  final String email;
  final String cnpj;
  final String cellphone;
  final String password;


  CentralRequest({
    required this.name,
    required this.email,
    required this.cnpj,
    required this.cellphone,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cellphone': cellphone,
      'email': email,
      'password': password,
      'cnpj': cnpj
    };
  }
}

class CentralLoginRequest {
  final String email;
  final String password;

  CentralLoginRequest({
    required this.email,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class  CentralResponse{
  final num id;
  final String name;
  final String email;
  final String creationDate;
  final String cnpj;
  final String cellphone;


  CentralResponse(this.id, this.name, this.email, this.creationDate, this.cnpj,this.cellphone);


  factory CentralResponse.fromJson(Map<String, dynamic> json) {
    return CentralResponse(
      json['id'] as num,
      json['name'] as String,
      json['email'] as String,
      json['creationDate'] as String,
      json['cnpj'] as String,
      json['cellphone'] as String,
    );
  }
}

class LoggedCentral {
  String token;
  CentralResponse central;

  LoggedCentral(this.token, this.central);

}