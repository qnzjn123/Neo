import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IconGenerator {
  static Future<Uint8List> generateAppIcon({int size = 512}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Background gradient
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF6C63FF),
          Color(0xFF9C63FF),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

    // Draw background with rounded corners
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(size * 0.2),
      ),
      bgPaint,
    );

    // Draw microphone icon
    final micPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = size / 2;
    final micWidth = size * 0.15;
    final micHeight = size * 0.25;

    // Microphone body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center, center - size * 0.05),
          width: micWidth,
          height: micHeight,
        ),
        Radius.circular(micWidth / 2),
      ),
      micPaint,
    );

    // Microphone stand
    final standPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.02
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCenter(
      center: Offset(center, center + size * 0.08),
      width: micWidth * 1.5,
      height: micHeight * 0.6,
    );

    canvas.drawArc(
      arcRect,
      0,
      3.14159,
      false,
      standPaint,
    );

    // Microphone base
    canvas.drawLine(
      Offset(center, center + size * 0.15),
      Offset(center, center + size * 0.22),
      standPaint,
    );

    canvas.drawLine(
      Offset(center - size * 0.08, center + size * 0.22),
      Offset(center + size * 0.08, center + size * 0.22),
      standPaint,
    );

    // Convert to image
    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static Future<Uint8List> generateSplashIcon({int size = 512}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw glow effect
    for (int i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = Color(0xFF6C63FF).withOpacity(0.2 / i)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30.0 * i);

      canvas.drawCircle(
        Offset(size / 2, size / 2),
        size * 0.25 * (1 + i * 0.1),
        glowPaint,
      );
    }

    // Main icon circle
    final iconPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF6C63FF),
          Color(0xFF9C63FF),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size * 0.25,
      iconPaint,
    );

    // Draw "NEO" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'NEO',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 - textPainter.width / 2,
        size / 2 - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size, size);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
