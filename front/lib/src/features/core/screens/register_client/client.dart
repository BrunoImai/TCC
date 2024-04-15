
class ClientRequest {
  final String name;
  final String email;
  final String cpf;
  final String cellphone;
  final String address;


  ClientRequest({
    required this.name,
    required this.email,
    required this.cpf,
    required this.cellphone,
    required this.address
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cellphone': cellphone,
      'email': email,
      'cpf': cpf,
      'address': address
    };
  }
}

class  ClientResponse{
  final num id;
  final String name;
  final String email;
  final String entryDate;
  final String cpf;
  final String cellphone;
  final String address;

  ClientResponse(this.id, this.name, this.email, this.entryDate, this.cpf, this.cellphone, this.address);


  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      json['id'] as num,
      json['name'] as String,
      json['email'] as String,
      json['entryDate'] as String,
      json['cpf'] as String,
      json['cellphone'] as String,
      json['address'] as String
    );
  }
}

class ClientInformations {
  String token;
  ClientResponse client;

  ClientInformations(this.token, this.client);

}

class  UpdateClientRequest {
  final String name;
  final String email;
  final String cpf;
  final String cellphone;
  final String address;

  UpdateClientRequest({required this.name, required this.email, required this.cpf,
    required this.cellphone, required this.address});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cpf': cpf,
      'cellphone': cellphone,
      'address': address,
    };
  }
}