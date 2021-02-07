import 'dart:async';
import 'dart:io';
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
  List<bool> listDurum = List();
  int sayac = 0;
  Offset eskiOffset = Offset(0, 0);
  Offset yeniOffset = Offset(0, 0);
  CustomPaint yeniPaint = CustomPaint();
  CustomPaint eskiPaint = CustomPaint();
  Timer timer;
  bool durum = false;
  double genislik;
  double yukseklik;
  Random random = Random();
  int ledSayisi = 15;
  int rastgele;
  int oankiLed;

  @override
  void initState() {
    list = ledleriOlustur();
    print('rastgele $rastgele');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    genislik = MediaQuery.of(context).size.width.toDouble();
    yukseklik = MediaQuery.of(context).size.height.toDouble();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
            
              BaslaDurdur();
              print('sayac $sayac');
            }),
        body: Container(
            width: genislik,
            height: yukseklik,
            alignment: Alignment.center,
            color: Color(0xFF2D2F41),
            child: Transform.rotate(
                angle: -pi / 2, child: Stack(children: list))));
  }

  void BaslaDurdur() {
    //RastgeleLediYak();
    
    print(durum);
    durum = !durum;
    if (durum) {
      rastgele = random.nextInt(ledSayisi);
      timer = new Timer.periodic(Duration(milliseconds: 200), (timers) {
        setState(() {
          
          //print('tick çalışıyor');
          yenile();
          kontrolEt();

          if (durum == false) {
            timer.cancel();
            if (oankiLed == rastgele) {
              print('o anki led $oankiLed rastgele seçilen $rastgele');
              dondurLedleriyak();
            }
          }
        });
      });
    }
  }

  void yenile() {
    Iterable<int>.generate(listDurum.length).forEach((index) {
      //print('index $index deger '+listDurum[index].toString())
      if (listDurum[index] == true) {
        list[index] = CustomPaint(
            painter: CustomLedWidget(
                listOffset[index].dx, listOffset[index].dy, 15, Colors.yellow));
      } else {
        list[index] = CustomPaint(
            painter: CustomLedWidget(
                listOffset[index].dx, listOffset[index].dy, 15, Colors.red));
      }
      list[rastgele] = CustomPaint(
          painter: CustomLedWidget(listOffset[rastgele].dx,
              listOffset[rastgele].dy, 15, Colors.blue));
    });
  }

  void kontrolEt() {
    var yer = listDurum.indexWhere((element) => element == true);
    oankiLed = yer;
    //listDurum[yer] = !listDurum[yer];
    if (yer == ledSayisi - 1) {
      listDurum[yer] = !listDurum[yer];
      listDurum[0] = !listDurum[0];
    } else if (yer < ledSayisi - 1) {
      listDurum[yer] = !listDurum[yer];
      listDurum[yer + 1] = !listDurum[yer + 1];
    }
    //oankiLed= listDurum.indexWhere((element) => element == true);
    print(listDurum);
  }

  void dondurLedleriyak() {
    
    Iterable<int>.generate(listDurum.length).forEach((index) => {
          //print('index $index deger '+listDurum[index].toString())
          list[index] = CustomPaint(
              painter: CustomLedWidget(listOffset[index].dx,
                  listOffset[index].dy, 15, Colors.yellow))
        });
      
        
  }

/*
  void calistir() {
    if (sayac > 0 && sayac != rastgele) {
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
*/
  List<Widget> ledleriOlustur() {
    rastgele = random.nextInt(ledSayisi);
    var innerCircleRadius = 300;
    double artis = 360 / ledSayisi;
    for (double i = 0; i < 360; i += artis) {
      var x = innerCircleRadius * cos(i * pi / 180);
      var y = innerCircleRadius * sin(i * pi / 180);
      list.add(CustomPaint(painter: CustomLedWidget(x, y, 15, Colors.pink)));
      listOffset.add(Offset(x, y));
      listDurum.add(false);
    }
    listDurum[rastgele % 2 + 2] = true;

    print('listDurum: $listDurum');

    return list;
  }

  // ignore: non_constant_identifier_names
  Color get GetColor =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
