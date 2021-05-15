import 'package:flutter/material.dart';

class LogoLogin extends StatelessWidget {
  final String titulo;

  const LogoLogin({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Image(image: AssetImage('assets/tag-logo.png'), height: 100),
            Text(this.titulo, style: TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}
