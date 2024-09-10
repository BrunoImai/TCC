import 'dart:async'; // Adicione esta importação
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../authentication/screens/signup/central_manager.dart';
import 'notification.dart';

class NotificationController extends GetxController {
  var unreadNotificationsCount = 0.obs;
  Timer? _timer;

  Future<void> fetchUnreadNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/notification/unread'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> notificationsJson = jsonDecode(response.body);

        List<NotificationResponse> notifications = notificationsJson.map((json) {
          return NotificationResponse.fromJson(json);
        }).toList();

        int unreadCount = notifications.where((notification) => !notification.readed).length;

        unreadNotificationsCount.value = unreadCount;
      } else {
        print('Erro ao buscar notificações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao realizar a requisição: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();

    fetchUnreadNotifications();

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchUnreadNotifications();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
