import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ledoyunu/custom_widget/custom_led.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final CustomLedWidget ledPaint;
  List<Widget> list = List();
  List<Offset> listOffset = List();
  int sayac = 0;
  Offset eskiOffset = Offset(0, 0);
  Offset yeniOffset = Offset(0, 0);
  CustomPaint yeniPaint = CustomPaint();
  CustomPaint eskiPaint = CustomPaint();
  Timer timer;
  bool durum = false;

  @override
  void initState() {
    // TODO: implement initState
    list = ledleriOlustur();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width.toDouble();
    final double _height = MediaQuery.of(context).size.height.toDouble();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              BaslaDurdur();
            }),
        body: Container(
            width: _width,
            height: _height,
            alignment: Alignment.center,
            color: Color(0xFF2D2F41),
            child: Transform.rotate(
                angle: -pi / 2, child: Stack(children: list))));
  }

  void BaslaDurdur() {
    print(durum);
    durum = !durum;
    if (durum) {
      timer = new Timer.periodic(Duration(milliseconds: 75), (timers) {
        setState(() {
          print('tick çalışıyor');
          calistir();
          if (durum == false) timer.cancel();
        });
      });
    }
  }

  void calistir() {
    if (sayac > 0) {
      eskiOffset = listOffset[sayac - 1];
      yeniOffset = listOffset[sayac];
      yeniPaint = CustomPaint(
          painter:
              CustomLedWidget(yeniOffset.dx, yeniOffset.dy, 15, Colors.yellow));
      eskiPaint = CustomPaint(
          painter:
              CustomLedWidget(eskiOffset.dx, eskiOffset.dy, 15, Colors.pink));
      list[sayac - 1] = eskiPaint;
      list[sayac] = yeniPaint;
      if (sayac == list.length - 1) {
        eskiOffset = listOffset[sayac];
        sayac = 0;
      } else {
        sayac++;
      }
    } else {
      eskiPaint = CustomPaint(
          painter:
              CustomLedWidget(eskiOffset.dx, eskiOffset.dy, 15, Colors.pink));
      if (eskiOffset.dx != 0.0) {
        print('sona geldi');
        list[list.length - 1] = eskiPaint;
      }
      yeniOffset = listOffset[sayac];
      yeniPaint = CustomPaint(
          painter:
              CustomLedWidget(yeniOffset.dx, yeniOffset.dy, 15, Colors.yellow));
      list[sayac] = yeniPaint;
      sayac++;
    }

    setState(() {
      print(sayac);
    });
  }

  List<Widget> ledleriOlustur() {
    var innerCircleRadius = 400;
    for (double i = 0; i < 360; i += 12) {
      var x = innerCircleRadius * cos(i * pi / 180);
      var y = innerCircleRadius * sin(i * pi / 180);
      list.add(CustomPaint(painter: CustomLedWidget(x, y, 15, Colors.pink)));
      listOffset.add(Offset(x, y));
    }
    return list;
  }

  // ignore: non_constant_identifier_names
  Color get GetColor =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
