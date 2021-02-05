import 'dart:math';

import 'package:flutter/material.dart';

class CustomLed extends StatelessWidget {
  final Color ledColor;
  final Offset koordinat;
  final int strokeWidth;
  final Radius radius;

  // ignore: non_constant_identifier_names
  const CustomLed(
      {Key key, this.ledColor=Colors.red, this.koordinat, this.strokeWidth, this.radius})
      : super(key: key);
    

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
          painter: ClockPainter(),
                  );
            }
            //canvas.drawCircle(center, radius - 40, outlineBrush);
          }
          
          class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
       var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var dashBrush = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;
    canvas.drawCircle(center, radius - 40, dashBrush);

    }
  
    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
