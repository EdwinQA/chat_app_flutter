import 'package:chat_app_flutter/global/environment.dart';
import 'package:chat_app_flutter/models/list_usuario_response.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app_flutter/models/usuario.dart';

class ListUsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/usuarios');
      final resp = await http.get(
        uri,
        headers: {
          'Content-type': 'application/json',
          'x-token': '${await AUthService.getToken()}'
        },
      );
      final usuariosResponse = listUsuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
