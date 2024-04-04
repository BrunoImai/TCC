
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

class Central {

}

class LoggedCentral {
  String token;
  Central central = Central();

  LoggedCentral(this.token, this.central);

/*int id;
  String name;
  String email;
  bool isAdm;

  LoggedCentral(
      this.token,
      this.id,
      this.name,
      this.email,
      this.isAdm
  );*/
}