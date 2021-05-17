import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/models/usuario.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usuarios = [
    Usuario(
        uid: '1',
        nombre: 'Edwin',
        email: 'edanwitunry@gmail.com',
        online: true),
    Usuario(
        uid: '2', nombre: 'Camilo', email: 'camilo@gmail.com', online: false),
    Usuario(
        uid: '3', nombre: 'Daniel', email: 'daniel@gmail.com', online: true),
    Usuario(uid: '4', nombre: 'Paola', email: 'paola@gmail.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final authSr = Provider.of<AUthService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${authSr.usuario.nombre}',
            style: TextStyle(color: Colors.black)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            //TODO: Desconectar del socket server
            Navigator.pushReplacementNamed(context, 'login');
            AUthService.deleteToken();
          },
          icon: Icon(Icons.exit_to_app, color: Colors.black),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.offline_bolt, color: Colors.blue[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue.withOpacity(0.4),
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, index) => Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[300],
        child: Text(
          usuario.nombre.substring(0, 2),
          style: TextStyle(color: Colors.white),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
