import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:prueba_tecnica_firma/controllers/firma_controller.dart';
import 'package:prueba_tecnica_firma/models/firma.dart';

void mostrarModalDeFirma(
    BuildContext context, Function(Uint8List) onSelectFirma) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return FutureBuilder<List<Firma>>(
        future: FirmaController().getFirmas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            final firmas = snapshot.data!.take(3).toList();

            return FractionallySizedBox(
              heightFactor: 0.9,
              child: DraggableScrollableSheet(
                maxChildSize: 0.9,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: ListView.builder(
                      controller: controller,
                      itemCount: firmas.length,
                      itemBuilder: (_, index) {
                        final firma = firmas[index];
                        final image = base64Decode(firma.dataBase64);
                        return ListTile(
                          leading: Image.memory(image),
                          title: Text('Firma'),
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectFirma(image);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    },
  );
}
