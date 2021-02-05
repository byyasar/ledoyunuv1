import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  var dateTime = DateTime.now();
  //60 sec 360-

  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var fillBrush = Paint()..color = Color(0xFF444974);
    var outlineBrush = Paint()
      ..color = Color(0xFFE6E7F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;
    var dashBrush = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;
    var dashBrush2 = Paint()..color = Colors.red;
    var centerFillBrush = Paint()..color = Colors.blue;
    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Colors.pinkAccent, Colors.pink[50]])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16;
    var minHandBrush = Paint()
      ..shader =
          RadialGradient(colors: [Colors.orangeAccent, Colors.orange[50]])
              .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    var secHandBrush = Paint()
      ..shader = RadialGradient(colors: [Colors.blue, Colors.lightBlue[50]])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);

    var hourHandX = centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * .5) * pi / 180);
    var hourHandY = centerX +
        60 * sin((dateTime.hour * 30 + dateTime.minute * .5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + 70 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + 70 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + 85 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerX + 85 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 12, centerFillBrush);

    var outerCircleRadius = radius - 35;
    var innerCircleRadius = radius - 40;
    for (double i = 0; i < 360; i += 30) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);
      var x2 = centerX + (innerCircleRadius - 5) * cos(i * pi / 180);
      var y2 = centerY + (innerCircleRadius - 5) * sin(i * pi / 180);
      //canvas.drawCircle(Offset(x2, y2), 5, dashBrush);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
    for (double i = 0; i < 360; i += 6) {
      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerY + innerCircleRadius * sin(i * pi / 180);
      canvas.drawCircle(Offset(x2, y2), 2, dashBrush2);
      //canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//06:52
//
