
class ClientRequest {
  final String name;
  final String email;
  final String cpf;
  final String cellphone;
  final String address;
  final String complement;


  ClientRequest({
    required this.name,
    required this.email,
    required this.cpf,
    required this.cellphone,
    required this.address,
    required this.complement
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cellphone': cellphone,
      'email': email,
      'cpf': cpf,
      'address': address,
      'complement': complement
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
  String id;
  ClientsList client;

  ClientInformations(this.id, this.client);

}

class  UpdateClientRequest {
  final String name;
  final String email;
  final String cpf;
  final String cellphone;
  final String address;
  final String complement;

  UpdateClientRequest({required this.name, required this.email, required this.cpf,
    required this.cellphone, required this.address, required this.complement});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'cpf': cpf,
      'cellphone': cellphone,
      'address': address,
      'complement': complement
    };
  }
}

class ClientsList {
  final num id;
  final String name;
  final String email;
  final String entryDate;
  final String cpf;
  final String cellphone;
  final String address;
  final String complement;

  ClientsList({required this.id, required this.name, required this.email, required this.entryDate, required this.cpf,
    required this.cellphone, required this.address, required this.complement});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'email': email,
      'entryDate' : entryDate,
      'cpf': cpf,
      'cellphone': cellphone,
      'address': address,
      'complement': complement
    };
  }
}