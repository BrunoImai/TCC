
class CentralRequest {
  final String companyName;
  final String email;
  final String cnpj;
  final String phoneNo;
  final String password;


  CentralRequest({
    required this.companyName,
    required this.email,
    required this.cnpj,
    required this.phoneNo,
    required this.password
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'phoneNo': phoneNo,
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

class LoggedCentral {
  String token;
  int id;
  String name;
  String email;
  bool isAdm;

  LoggedCentral(
      this.token,
      this.id,
      this.name,
      this.email,
      this.isAdm
  );
}