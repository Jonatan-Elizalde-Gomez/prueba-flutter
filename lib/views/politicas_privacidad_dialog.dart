import 'package:flutter/material.dart';
import 'package:prueba_tecnica_firma/views/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoliticasPrivacidadDialog extends StatefulWidget {
  @override
  _PoliticasPrivacidadDialogState createState() =>
      _PoliticasPrivacidadDialogState();
}

class _PoliticasPrivacidadDialogState extends State<PoliticasPrivacidadDialog> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Políticas de Privacidad'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Aquí van tus políticas de privacidad.'),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Switch(
              value: _switchValue,
              onChanged: (bool value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
            Flexible(
              child: TextButton(
                child: Text('Acepto'),
                onPressed: _switchValue
                    ? () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('aceptoPoliticas', true);
                        Navigator.of(context)
                            .pop(); // Primero cierras el diálogo
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LandingPage()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ],
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10.0),
    );
  }
}
