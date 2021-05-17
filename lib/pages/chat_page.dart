import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app_flutter/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _ctrlText = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
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

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            child: Text('Te', style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
          ),
          SizedBox(height: 3),
          Text(
            'Edwin Quebrada',
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
    print(texto);
    _ctrlText.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      texto: texto,
      uid: '123',
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
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
