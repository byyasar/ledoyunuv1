import 'package:flutter/material.dart';

class CustomLedWidget extends CustomPainter {
  CustomLedWidget(this.width, this.height, this.radius, this.color);
  final double width;
  final double height;
  final double radius;
  final Color color;
  //final List<Rect> leds;

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = width / 2;
    var centerY = height / 2;
    var center = Offset(centerX, centerY);
    var fillBrush = Paint()..color = color;
    canvas.drawCircle(center, radius, fillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
