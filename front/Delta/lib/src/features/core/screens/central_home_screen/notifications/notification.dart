class NotificationResponse {
  final int id;
  final String title;
  final String message;
  final String creationDate;
  final bool readed;
  final String workerId;

  NotificationResponse({required this.id, required this.title, required this.message, required this.creationDate,
    required this.readed, required this.workerId});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      creationDate: json['creationDate'],
      readed: json['readed'],
      workerId: json['workerId'].toString(),
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
    };
  }
}

class NotificationInformations {
  int? id;
  String workerName;
  NotificationResponse notification;

  NotificationInformations(this.id, this.workerName, this.notification);
}