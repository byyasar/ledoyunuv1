import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:ledoyunu/core/extension/color_constant.dart';
import 'package:ledoyunu/core/extension/context_extension.dart';
import 'package:ledoyunu/custom_widget/custom_led.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class OyunHomePage extends StatelessWidget {
  static final String pageRoute = 'Home';
  @override
  Widget build(BuildContext context) {
    double gen = context.dynamicWidth(1);
    double yuk = context.dynamicHeight(1);

    return Container(
      width: context.dynamicWidth(1),
      height: context.dynamicHeight(1),
      child: HomePage(
        genislik: gen,
        yukseklik: yuk,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final double genislik;
  final double yukseklik;
  //static final String pageRoute = 'Home';
  HomePage({Key key, @required this.genislik, this.yukseklik})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(genislik, yukseklik);
}

class _HomePageState extends State<HomePage> {
  double yukseklik;
  double genislik;
  _HomePageState(this.genislik, this.yukseklik);

  List<Widget> list = List();
  List<Offset> listOffset = List();
  List<bool> listDurum = List();

  Timer timer;
  bool durum = false;

  Random random = Random();
  int ledSayisi = 20;
  double ledRadius = 20;
  int innerCircleRadius;

  //int innerCircleRadius = (widget.genislik~/ 3);
  int sayac = 0;
  int rastgele;
  int oankiLed;
  int sayacefekt = 0;
  int level = 1;
  int puan = 0;
  int hata = 0;
  int hiz = 50;
  static AudioCache player = AudioCache();

  @override
  void initState() {
    print('genislik $genislik');
    innerCircleRadius = (widget.genislik ~/ 1.2);
    list = ledleriOlustur();
    print('rastgele $rastgele');
    // or as a local variable
    //final player = AudioCache();
    // call this method when desired

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('genişlik $genislik * $yukseklik $innerCircleRadius');
   // player.play('/sesler/Coin.wav');
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.instance.bgColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(flex: 1, child: skorContainer()),
                Expanded(flex: 8, child: ledContainer()),
                Expanded(flex: 2, child: btnContainer()),
              ],
            ),
          )),
    );
  }

  Widget skorContainer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.amber[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Level :$level',
                style:
                    context.textTheme.headline6.copyWith(color: Colors.black)),
            Text('Hız :$hiz',
                style:
                    context.textTheme.headline6.copyWith(color: Colors.black)),
            Text('Puan :$puan',
                style:
                    context.textTheme.headline6.copyWith(color: Colors.black)),
            Text('Hata :$hata',
                style:
                    context.textTheme.headline6.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget btnContainer() {
    return Container(
        child: FlatButton(
            onPressed: () {
              sayacefekt == 0 ? baslaDurdur() : print('Bekle');
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomPaint(
                    painter: CustomLedWidget(
                        0, 25, 50, ColorConstants.instance.ledShowColor)),
                Text('Başla',
                    style: context.textTheme.headline5
                        .copyWith(color: Colors.black)),
              ],
            )));
  }

  Widget ledContainer() {
    return Container(
        width: genislik,
        height: yukseklik,
        alignment: Alignment.center,
        color: ColorConstants.instance.bgColor,
        child: Transform.rotate(angle: -pi / 2, child: Stack(children: list)));
  }

  void baslaDurdur() {
    //print(durum);
    durum = !durum;
    if (durum) {
      rastgele = random.nextInt(ledSayisi);
      timer = new Timer.periodic(Duration(milliseconds: (500 - hiz)), (timers) {
        setState(() {
    

          kontrolEt();
          if (durum == false) {
            timer.cancel();
            if (oankiLed == rastgele) {
              
              print('o anki led $oankiLed rastgele seçilen $rastgele');
              sayacefekt = 0;
              dondurLedleriyak();
              level++;
              puan += level * (5 - hata);
              if (hiz < 300) {
                hiz += 100;
              } else {
                hiz += 10;
              }
              hata = 0;
              // add it to your class as a static member

            } else {
              print('o anki led $oankiLed rastgele seçilen $rastgele');
              player.play('/sesler/Glug.wav');
              sayacefekt = 0;
              dondurKirmiziyak();
              hata++;
              if (hata == 3) {
                print('Puanınız $puan');
                print('oyun bitti');
                showAnimatedDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ClassicGeneralDialogWidget(
                      titleText: 'Oyun Bitti',
                      contentText: 'Puanınız $puan',
                      onPositiveClick: () {
                        Navigator.of(context).pop();
                        setState(() {
                          hata = 0;
                          level = 1;
                          puan = 0;
                          hiz = 50;
                        });
                      },
                    );
                  },
                  animationType: DialogTransitionType.size,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 1),
                );
              }
            }
          }

          yenile();
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
                ledRadius, ColorConstants.instance.ledOnColor));
      } else {
        list[index] = CustomPaint(
            painter: CustomLedWidget(listOffset[index].dx, listOffset[index].dy,
                ledRadius, ColorConstants.instance.ledOffColor));
      }
      list[rastgele] = CustomPaint(
          painter: CustomLedWidget(
              listOffset[rastgele].dx,
              listOffset[rastgele].dy,
              ledRadius,
              ColorConstants.instance.ledRandomColor));
    });
  }

  void kontrolEt() {
    var yer = listDurum.indexWhere((element) => element == true);
    oankiLed = yer;
    if (yer == ledSayisi - 1) {
      listDurum[yer] = !listDurum[yer];
      listDurum[0] = !listDurum[0];
    } else if (yer < ledSayisi - 1) {
      listDurum[yer] = !listDurum[yer];
      listDurum[yer + 1] = !listDurum[yer + 1];
    }
    //print(listDurum);
  }

  void dondurLedleriyak() {
     player.play('/sesler/Coin.wav');
    bool yak = true;
    int index = 0;
    timer = new Timer.periodic(Duration(milliseconds: 20), (timers) {
      setState(() {
       
        //print('yak tick çalışıyor');
        list[index] = CustomPaint(
            painter: CustomLedWidget(
                listOffset[index].dx,
                listOffset[index].dy,
                ledRadius,
                yak == true
                    ? ColorConstants.instance.ledShowColor
                    : ColorConstants.instance.ledOffColor));
      });
      if (index < list.length) index++;
      if (yak == false && index == list.length) {
        timer.cancel();
        //print('timer durdu');
        if (sayacefekt < 1)
          dondurLedleriyak();
        else if (sayacefekt == 1) {
          sayacefekt = 0;
        }
      }
      if (yak == true && index == list.length) {
        index = 0;
        yak = false;
      }
    });

    sayacefekt++;
    //print('sayacefect $sayacefekt');
  }

  void dondurKirmiziyak() {
    bool yak = true;
    int index = 0;
    timer = new Timer.periodic(Duration(milliseconds: 20), (timers) {
      setState(() {
        //print('yak tick çalışıyor');
        list[index] = CustomPaint(
            painter: CustomLedWidget(
                listOffset[index].dx,
                listOffset[index].dy,
                ledRadius,
                yak == true
                    ? ColorConstants.instance.ledOnColor
                    : ColorConstants.instance.ledOffColor));
      });
      if (index < list.length) index++;
      if (yak == false && index == list.length) {
        timer.cancel();
        //print('timer durdu');
        if (sayacefekt < 1)
          dondurKirmiziyak();
        else if (sayacefekt == 1) {
          sayacefekt = 0;
        }
      }
      if (yak == true && index == list.length) {
        index = 0;
        yak = false;
      }
    });

    sayacefekt++;
    //print('sayacefect $sayacefekt');
  }

  List<Widget> ledleriOlustur() {
    rastgele = random.nextInt(ledSayisi);

    double artis = 360 / ledSayisi;
    for (double i = 0; i < 360; i += artis) {
      var x = innerCircleRadius * cos(i * pi / 180);
      var y = innerCircleRadius * sin(i * pi / 180);
      list.add(CustomPaint(
          painter: CustomLedWidget(
              x, y, ledRadius, ColorConstants.instance.ledOffColor)));
      listOffset.add(Offset(x, y));
      listDurum.add(false);
    }
    listDurum[rastgele % 2 + 2] = true;

    //print('listDurum: $listDurum');

    return list;
  }

  List<Color> get getColor => [
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
      ];
}
