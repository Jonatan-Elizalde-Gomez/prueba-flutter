import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'mostrarModalDeFirma.dart'; // Asegúrate de tener el path correcto

class FormularioPedido extends StatefulWidget {
  @override
  _FormularioPedidoState createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  Uint8List? firmaImagen; // Almacena la imagen de la firma como datos Uint8List
  final TextEditingController _productoController =
      TextEditingController(); // Controlador para el campo del producto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulario de Pedido")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _productoController,
                    decoration: InputDecoration(
                      labelText: 'Producto', // Etiqueta del campo de texto
                      border: OutlineInputBorder(), // Borde del campo de texto
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => mostrarModalDeFirma(context, (Uint8List data) {
                      setState(() {
                        firmaImagen = data; // Actualiza la imagen de la firma
                      });
                    }),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: firmaImagen != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                firmaImagen!,
                                fit: BoxFit
                                    .contain, // Ajusta la imagen para que se adapte al contenedor
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload,
                                      size: 30, color: Colors.grey[500]),
                                  Text("Arrastra y suelta tu firma aquí",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    _mostrarRecibo(context);
                  },
                  child: Text('Enviar'),
                ),
                // Añade aquí más elementos del formulario según sea necesario
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarRecibo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recibo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Producto: ${_productoController.text}'),
                SizedBox(height: 20),
                firmaImagen != null
                    ? Image.memory(
                        firmaImagen!,
                        fit: BoxFit.contain,
                      )
                    : Text('No se ha adjuntado ninguna firma'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    _productoController.dispose();
    super.dispose();
  }
}
