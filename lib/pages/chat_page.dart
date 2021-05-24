import 'dart:io';

import 'package:chat_app_flutter/models/mensajes_response.dart';
import 'package:chat_app_flutter/models/usuario.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/chat_service.dart';
import 'package:chat_app_flutter/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app_flutter/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _ctrlText = new TextEditingController();
  final _focusNode = new FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AUthService aUthService;
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.aUthService = Provider.of<AUthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorialMensajes(this.chatService.usuariPara.uid);
  }

  void _cargarHistorialMensajes(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    final historial = chat.map(
      (m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: new AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 0),
        )..forward(),
      ),
    );
    
    setState(() {
      _messages.insertAll(0,historial);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: Duration(microseconds: 300)),
    );
    setState(() {
      _messages.insert(_messages.length, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuariopara = chatService.usuariPara;
    return Scaffold(
      appBar: _appBar(usuariopara),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    _messages[(index - (_messages.length - 1)) * -1],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1),
            _inputChat(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(Usuario usuario) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            child: Text(usuario.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
          ),
          SizedBox(height: 3),
          Text(
            usuario.nombre,
            style: TextStyle(color: Colors.black87, fontSize: 12),
          )
        ],
      ),
      centerTitle: true,
      elevation: 1,
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        height: 50,
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _ctrlText,
                onSubmitted: _hundSubmit,
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().length > 0)
                      _estaEscribiendo = true;
                    else
                      _estaEscribiendo = false;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Mensaje',
                  border: InputBorder.none,
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              //color: Colors.red,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: !Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _hundSubmit(_ctrlText.text)
                          : null,
                    )
                  : Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estaEscribiendo
                              ? () => _hundSubmit(_ctrlText.text)
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _hundSubmit(String texto) {
    if (texto.isEmpty) return;

    _ctrlText.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      texto: texto,
      uid: aUthService.usuario.uid,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );
    _messages.insert(_messages.length, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
    this.socketService.socket.emit('mensaje-personal', {
      'de': this.aUthService.usuario.uid,
      'para': this.chatService.usuariPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
