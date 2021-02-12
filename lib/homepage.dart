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
  double ledRadius = 20;
  int rastgele;
  int oankiLed;
  var LedOffColor = [Color(0xFF3C3F58), Color(0xFF3C3F58)];
  var LedOnColor = [Colors.red, Colors.red[800]];
  var LedRandomColor = [Colors.blue, Colors.blue[800]];
  var LedShowColor = [Colors.yellow, Colors.yellow[800]];
  var bgColor = Color(0xFF2D2F41);
  int sayacefekt = 0;

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
        backgroundColor: bgColor,
        body: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 6,
              child: Container(
                  width: genislik,
                  height: yukseklik,
                  alignment: Alignment.center,
                  color: bgColor,
                  child: Transform.rotate(
                      angle: -pi / 2, child: Stack(children: list))),
            ),
            Expanded(
                flex: 2,
                child: Container(
                    child: FlatButton(
                        onPressed: () {
                          sayacefekt == 0 ? BaslaDurdur() : print('Bekle');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomPaint(
                                painter:
                                    CustomLedWidget(0, 30, 60, LedShowColor)),
                            Text(
                              'Başla',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28),
                            ),
                          ],
                        )))),
            Spacer(
              flex: 2,
            )
          ],
        ));
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
              sayacefekt = 0;
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
            painter: CustomLedWidget(listOffset[index].dx, listOffset[index].dy,
                ledRadius, LedOnColor));
      } else {
        list[index] = CustomPaint(
            painter: CustomLedWidget(listOffset[index].dx, listOffset[index].dy,
                ledRadius, LedOffColor));
      }
      list[rastgele] = CustomPaint(
          painter: CustomLedWidget(listOffset[rastgele].dx,
              listOffset[rastgele].dy, ledRadius, LedRandomColor));
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
    bool yak = true;
    int index = 0;
    timer = new Timer.periodic(Duration(milliseconds: 20), (timers) {
      setState(() {
        print('yak tick çalışıyor');
        list[index] = CustomPaint(
            painter: CustomLedWidget(listOffset[index].dx, listOffset[index].dy,
                ledRadius, yak == true ? LedShowColor : LedOffColor));
      });
      if (index < list.length) index++;
      if (yak == false && index == list.length) {
        timer.cancel();
        print('timer durdu');
        if (sayacefekt < 3)
          dondurLedleriyak();
        else if (sayacefekt == 3) {
          sayacefekt = 0;
        }
      }
      if (yak == true && index == list.length) {
        index = 0;
        yak = false;
      }
    });

    sayacefekt++;
    print('sayacefect $sayacefekt');
  }

  List<Widget> ledleriOlustur() {
    rastgele = random.nextInt(ledSayisi);
    var innerCircleRadius = 300;
    double artis = 360 / ledSayisi;
    for (double i = 0; i < 360; i += artis) {
      var x = innerCircleRadius * cos(i * pi / 180);
      var y = innerCircleRadius * sin(i * pi / 180);
      list.add(
          CustomPaint(painter: CustomLedWidget(x, y, ledRadius, LedOffColor)));
      listOffset.add(Offset(x, y));
      listDurum.add(false);
    }
    listDurum[rastgele % 2 + 2] = true;

    print('listDurum: $listDurum');

    return list;
  }

  // ignore: non_constant_identifier_names
  List<Color> get GetColor => [
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
      ];
  //[Colors.yellow, Colors.yellow[800]];
}
