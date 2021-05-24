import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app_flutter/pages/login_page.dart';
import 'package:chat_app_flutter/pages/usuarios_page.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/socket_services.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (_, snapshot) {
          return Center(
            child: Text('Espere porfavor...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authSrv = Provider.of<AUthService>(context, listen: false);
    final socketSrv = Provider.of<SocketService>(context, listen: false);
    final autenticado = await authSrv.isLoggedIn();

    if (autenticado) {
      //Navigator.pushReplacementNamed(context, 'usuarios');
      socketSrv.connect();
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
