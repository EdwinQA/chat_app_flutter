import 'package:chat_app_flutter/global/environment.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;

  void connect() async {
    final token = await AUthService.getToken();
//Dart IO Client
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConecct': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      //socket.emit('mensajealservidor', {'nombre': 'fernando'});
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('respuestaalcliente', (data) {
    //   print('mensaje del servidor');
    //   print('nombre: ' + data['nombre']);
    //   print(data.containsKey('nombre2')?data['nombre2']:'no hay');
    // });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
