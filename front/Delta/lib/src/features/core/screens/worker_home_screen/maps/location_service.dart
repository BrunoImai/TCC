import 'dart:js';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/src/features/core/screens/worker/worker_manager.dart';

class LocationService {
  // Obtém a localização atual do dispositivo
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Serviço de localização desabilitado
      return Future.error('O serviço de localização está desabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissão negada
        return Future.error('As permissões de localização foram negadas.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissões de localização permanentemente negadas
      return Future.error(
          'As permissões de localização foram permanentemente negadas, não podemos solicitar permissões.');
    }

    // Obtém a localização atual
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
  }

  // Envia a localização atual para o servidor
  static Future<void> sendLocationToServer(Position position) async {
    final url = 'http://localhost:8080/api/worker/assistance/closest?coordinate=${position.latitude}, ${position.longitude}';
    final token = WorkerManager.instance.loggedUser!.token;
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print('URL: $url');
    print('Token: $token');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if(response.body == ""){
      throw Exception('Não há serviços no momento, tente novamente mais tarde!');
    }

    if (response.statusCode != 200) {
      throw Exception('Falha ao enviar a localização para o servidor. Status Code: ${response.statusCode}');
    }
  }

}
