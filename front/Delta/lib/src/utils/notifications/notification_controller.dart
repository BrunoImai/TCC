import 'dart:async'; // Adicione esta importação
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import '../../features/authentication/screens/signup/central_manager.dart';
import '../../features/core/screens/worker/worker_manager.dart';
import 'notification.dart';

class NotificationController extends GetxController {
  var unreadNotificationsCount = 0.obs;
  Timer? _timer;
  final num whoAreYouTag;

  NotificationController(this.whoAreYouTag);



  String getUserToken() {
    if (whoAreYouTag == 2) {
      return CentralManager.instance.loggedUser!.token;
    } else {
      return WorkerManager.instance.loggedUser!.token;
    }
  }

  String getUserUrl() {
    if (whoAreYouTag == 2) {
      return 'http://localhost:8080/api/central/notification/unread';
    } else {
      return 'http://localhost:8080/api/worker/notification/unread';
    }
  }

  Future<void> fetchUnreadNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(getUserUrl()),
        headers: {
          'Authorization': 'Bearer ${getUserToken()}',
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

    _timer = Timer.periodic(Duration(seconds:3000), (timer) {
      fetchUnreadNotifications();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
