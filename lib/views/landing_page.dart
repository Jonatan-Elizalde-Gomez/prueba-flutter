import 'package:flutter/material.dart';
import 'package:prueba_tecnica_firma/views/FormularioPedido.dart';
import 'package:prueba_tecnica_firma/views/firma_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [FormularioPedido(), FirmaPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Aplicación prueba",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Pedir Producto",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: "Ir a Firma",
          ),
        ],
      ),
    );
  }
}
