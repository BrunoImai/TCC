class CategoryRequest {
  final String name;

  CategoryRequest({
    required this.name
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name
    };
  }
}


class CategoryResponse {
  final int id;
  final String name;
  final String creationDate;


  CategoryResponse({
    required this.id,
    required this.name,
    required this.creationDate,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: json['id'],
      name: json['name'],
      creationDate: json['creationDate']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creationDate': creationDate,
    };
  }
}

