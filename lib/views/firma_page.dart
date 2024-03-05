import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:prueba_tecnica_firma/controllers/firma_controller.dart';
import 'landing_page.dart'; // Importa tu LandingPage

class FirmaPage extends StatefulWidget {
  @override
  _FirmaPageState createState() => _FirmaPageState();
}

class _FirmaPageState extends State<FirmaPage> {
  List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dibuja tu Firma"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (points.isNotEmpty) {
                final signature = await _capturePng();
                FirmaController().guardarFirma(signature);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          points.add(Offset
              .infinite); // Usamos Offset.infinite para separar las líneas
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: FirmaPainter(points),
        ),
      ),
    );
  }

  Future<String> _capturePng() async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    FirmaPainter(points)
        .paint(canvas, Size(context.size!.width, context.size!.height));
    ui.Picture picture = recorder.endRecording();
    ui.Image image = await picture.toImage(
        context.size!.width.toInt(), context.size!.height.toInt());
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    return base64Encode(pngBytes);
  }
}

class FirmaPainter extends CustomPainter {
  final List<Offset> points;

  FirmaPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
