import 'dart:ui';

import 'package:chat_app_flutter/widgets/btn_azul.dart';
import 'package:chat_app_flutter/widgets/custom_input.dart';
import 'package:chat_app_flutter/widgets/labels.dart';
import 'package:chat_app_flutter/widgets/logo_login.dart';
import 'package:chat_app_flutter/widgets/terminosycondiciones.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
              function: () {
                print(emailCtrl.text);
              },
              texto: 'Ingresar'),
        ],
      ),
    );
  }
}
