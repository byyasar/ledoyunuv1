import 'package:flutter/material.dart';

class CustomLedWidget extends CustomPainter {
  CustomLedWidget(this.width, this.height, this.radius, this.color);
  final double width;
  final double height;
  final double radius;
  final List<Color> color;
  //final List<Rect> leds;

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = width / 2;
    var centerY = height / 2;
    var center = Offset(centerX, centerY);
    var fillBrush = Paint()
      ..shader = RadialGradient(colors: color)
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius ;
    canvas.drawCircle(center, radius, fillBrush);
  }

/*
var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Colors.pinkAccent, Colors.pink[50]])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;*/
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
