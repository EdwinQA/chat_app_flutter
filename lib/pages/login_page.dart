import 'dart:ui';

import 'package:chat_app_flutter/helpers/mostrar_alerta.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/widgets/btn_azul.dart';
import 'package:chat_app_flutter/widgets/custom_input.dart';
import 'package:chat_app_flutter/widgets/labels.dart';
import 'package:chat_app_flutter/widgets/logo_login.dart';
import 'package:chat_app_flutter/widgets/terminosycondiciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sS = MediaQuery.of(context);
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
                LogoLogin(
                  titulo: 'Messenger',
                ),
                _Form(),
                Labels(
                  ruta: 'register',
                  tienecuenta: '¿No tienes cuenta?',
                  invitacion: 'Crea una ahora!',
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
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authSr = Provider.of<AUthService>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
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
            texto: 'Ingresar',
            onPressed: authSr.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authSr.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Login Incorrecto',
                          'Revise las credenciales nuevamente');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
