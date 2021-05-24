// To parse this JSON data, do
//
//     final listUsuariosResponse = listUsuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app_flutter/models/usuario.dart';

ListUsuariosResponse listUsuariosResponseFromJson(String str) =>
    ListUsuariosResponse.fromJson(json.decode(str));

String listUsuariosResponseToJson(ListUsuariosResponse data) =>
    json.encode(data.toJson());

class ListUsuariosResponse {
  ListUsuariosResponse({
    required this.ok,
    required this.usuarios,
  });

  bool ok;
  List<Usuario> usuarios;

  factory ListUsuariosResponse.fromJson(Map<String, dynamic> json) =>
      ListUsuariosResponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(
            json["usuarios"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
