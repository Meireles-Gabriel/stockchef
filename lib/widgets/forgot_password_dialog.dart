import 'package:flutter/material.dart';

void forgotPasswordDialog(BuildContext context, Map texts) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Título do Alerta'),
        content: Text('Conteúdo da mensagem de alerta aqui.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirmar'),
            onPressed: () {
              // Ação quando o usuário confirma
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
