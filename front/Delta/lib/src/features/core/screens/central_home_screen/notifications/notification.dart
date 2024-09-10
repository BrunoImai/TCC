class NotificationResponse {
  final int id;
  final String title;
  final String message;
  final String creationDate;
  final bool readed;
  final String workerId;
  final int budget_id;

  NotificationResponse({required this.id, required this.title, required this.message, required this.creationDate,
    required this.readed, required this.workerId, required this.budget_id});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      creationDate: json['creationDate'],
      readed: json['readed'],
      workerId: json['workerId'].toString(),
      budget_id: json['budget_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title': title,
      'message': message,
      'creationDate': creationDate,
      'readed': readed,
      'workerId': workerId,
      'budget_id': budget_id
    };
  }
}

class NotificationInformations {
  int? id;
  String workerName;
  NotificationResponse notification;

  NotificationInformations(this.id, this.workerName, this.notification);
}