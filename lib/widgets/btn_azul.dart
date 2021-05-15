import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final void Function()? function;
  final String texto;

  const BotonAzul({
    required this.function,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: function,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            '${this.texto}',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
