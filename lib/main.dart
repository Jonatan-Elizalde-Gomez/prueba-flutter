import 'package:flutter/material.dart';
import 'package:prueba_tecnica_firma/views/landing_page.dart';
import 'package:prueba_tecnica_firma/views/politicas_privacidad_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final prefs = snapshot.data as SharedPreferences;
            final bool? aceptoPoliticas = prefs.getBool('aceptoPoliticas');

            if (aceptoPoliticas == true) {
              return LandingPage();
            } else {
              return PoliticasPrivacidadDialog();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
