import 'package:tcc_front/src/features/core/screens/budget/budget.dart';

class NotificationResponse {
  final String id;
  final String title;
  final String message;
  final String creationDate;
  final bool readed;
  final String workerId;
  final String budgetId;

  NotificationResponse({required this.id, required this.title, required this.message, required this.creationDate,
    required this.readed, required this.workerId, required this.budgetId});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
        id: json['id'].toString(),
        title: json['title'],
        message: json['message'],
        creationDate: json['creationDate'],
        readed: json['readed'],
        workerId: json['workerId'].toString(),
        budgetId: json['budgetId'].toString()
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
      'budgetId': budgetId
    };
  }
}

class NotificationInformations {
  String? id;
  String workerName;
  NotificationResponse notification;

  NotificationInformations(this.id, this.workerName, this.notification);
}