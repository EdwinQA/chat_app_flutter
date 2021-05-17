import 'package:chat_app_flutter/pages/login_page.dart';
import 'package:chat_app_flutter/pages/usuarios_page.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere porfavor...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authSr = Provider.of<AUthService>(context, listen: false);
    final autenticado = await authSr.isLoggedIn();

    if (autenticado) {
      //Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsuariosPage(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    }
  }
}
