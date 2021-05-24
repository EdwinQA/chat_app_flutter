import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_flutter/helpers/mostrar_alerta.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/socket_services.dart';
import 'package:chat_app_flutter/widgets/btn_azul.dart';
import 'package:chat_app_flutter/widgets/custom_input.dart';
import 'package:chat_app_flutter/widgets/labels.dart';
import 'package:chat_app_flutter/widgets/logo_login.dart';
import 'package:chat_app_flutter/widgets/terminosycondiciones.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sS = MediaQuery.of(context);
    print('${sS.size.width} a ${sS.size.height} ');
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: (sS.orientation == Orientation.portrait)
                    ? sS.size.height
                    : sS.size.width,
                maxWidth: sS.size.width),
            padding: EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoLogin(titulo: 'Registro'),
                _Form(),
                Labels(
                  ruta: 'login',
                  tienecuenta: '¿Ya tienes cuenta?',
                  invitacion: 'Inicia sesión',
                ),
                TerminosyCondiciones(),
              ],
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authSr = Provider.of<AUthService>(context);
    final socketServices = Provider.of<SocketService>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          CustomInput(
            hint: 'Nombre',
            iconleft: Icon(Icons.perm_identity),
            keyboardType: TextInputType.text,
            textController: nombreCtrl,
          ),
          CustomInput(
            hint: 'Correo',
            iconleft: Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            hint: 'Contraseña',
            iconleft: Icon(Icons.lock),
            textController: passCtrl,
            isPassword: true,
          ),
          SizedBox(height: 20),
          BotonAzul(
            texto: 'Crear cuenta',
            onPressed: authSr.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registerOk = await authSr.register(
                        nombreCtrl.text, emailCtrl.text, passCtrl.text);
                    if (registerOk == true) {
                      socketServices.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Datos Incorrectos', registerOk);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
