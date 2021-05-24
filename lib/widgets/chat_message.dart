import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    required this.texto,
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AUthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ),
        child: Container(
          child: this.uid == authServices.usuario.uid
              ? _myMessage()
              : _noMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(right: 5, left: 50, top: 5, bottom: 5),
        child: Text(this.texto, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _noMyMessage() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(right: 50, left: 5, top: 5, bottom: 5),
        child: Text(this.texto, style: TextStyle(color: Colors.black87)),
        decoration: BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
