import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'mostrarModalDeFirma.dart';

class FormularioPedido extends StatefulWidget {
  @override
  _FormularioPedidoState createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  Uint8List? firmaImagen;
  final TextEditingController _productoController = TextEditingController();

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
                      labelText: 'Producto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => mostrarModalDeFirma(context, (Uint8List data) {
                      setState(() {
                        firmaImagen = data;
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
                                fit: BoxFit.contain,
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
    _productoController.dispose();
    super.dispose();
  }
}
