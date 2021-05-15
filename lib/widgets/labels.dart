import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;

  final String tienecuenta;

  final String invitacion;

  const Labels(
      {required this.ruta,
      required this.tienecuenta,
      required this.invitacion});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            tienecuenta,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w200),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.ruta);
            },
            child: Text(
              invitacion,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
