import 'package:chat_app_flutter/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app_flutter/global/environment.dart';
import 'package:chat_app_flutter/models/usuario.dart';
import 'package:chat_app_flutter/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late Usuario usuariPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID');
      final resp = await http.get(
        uri,
        headers: {
          'Content-type': 'application/json',
          'x-token': '${await AUthService.getToken()}'
        },
      );

      final mensajesResp = mensajesResponseFromJson(resp.body);
      return mensajesResp.mensajes;
    } catch (error) {
      return [];
    }
  }
}
