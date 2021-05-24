import 'package:chat_app_flutter/services/chat_service.dart';
import 'package:chat_app_flutter/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app_flutter/models/usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/socket_services.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = new ListUsuariosService();
  RefreshController _refreshCtrl = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authServ = Provider.of<AUthService>(context);
    final socketServ = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${authServ.usuario.nombre}',
            style: TextStyle(color: Colors.black)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socketServ.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AUthService.deleteToken();
          },
          icon: Icon(Icons.exit_to_app, color: Colors.black),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketServ.serverStatus == ServerStatus.Online)
                ? Icon(Icons.offline_bolt, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshCtrl,
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context,listen: false);
        chatService.usuariPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshCtrl.refreshCompleted();
  }
}
