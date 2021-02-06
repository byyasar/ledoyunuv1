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

  @override
  void initState() {
    // TODO: implement initState
    
    list = ledleriOlustur();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {calistir();});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width.toDouble();
    final double _height = MediaQuery.of(context).size.height.toDouble();

    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            calistir();}),
        body: Container(
            width: _width,
            height: _height,
            alignment: Alignment.center,
            color: Color(0xFF2D2F41),
            child: Transform.rotate(
                angle: -pi / 2, child: Stack(children: list))));
  }

  Function calistir(){
    if (sayac > 0) {
              eskiOffset = listOffset[sayac - 1];
              yeniOffset = listOffset[sayac];
              CustomPaint yeniPaint = CustomPaint(
                  painter: CustomLedWidget(
                      yeniOffset.dx, yeniOffset.dy, 15, Colors.yellow));
              CustomPaint eskiPaint = CustomPaint(
                  painter: CustomLedWidget(
                      eskiOffset.dx, eskiOffset.dy, 15, Colors.pink));
              list[sayac - 1] = eskiPaint;
              list[sayac] = yeniPaint;
              if (sayac == list.length - 1) {
                eskiOffset = listOffset[sayac];
                sayac = 0;
              } else {
                sayac++;
              }
            } else {
              CustomPaint eskiPaint = CustomPaint(
                  painter: CustomLedWidget(
                      eskiOffset.dx, eskiOffset.dy, 15, Colors.pink));
              if (eskiOffset.dx != 0.0) {
                print('sona geldi');
                list[list.length - 1] = eskiPaint;
              }
              Offset yeniOffset = listOffset[sayac];
              CustomPaint yeniPaint = CustomPaint(
                  painter: CustomLedWidget(
                      yeniOffset.dx, yeniOffset.dy, 15, Colors.yellow));
              list[sayac] = yeniPaint;
              sayac++;
            }

            setState(() {
              print(sayac);
            });
          }
  }

  List<Widget> ledleriOlustur() {
    var innerCircleRadius = 400;
    for (double i = 0; i < 360; i += 30) {
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
