import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'card_board.dart';
import 'card_item.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: new MyHomePage(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget? child;
  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.findAncestorStateOfType<_RestartWidgetState>()!;
    // context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    this.setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final score;
  final time;
  MyHomePage({Key? key, this.score, this.time}) : super(key: key);
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int score = 0;
  int time = 0;
  int init = 0;

  @override
  void initState() {
    super.initState();
    init = 1;
    // Timer(Duration(seconds: 2), runTimer);
  }

  void showalert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Welcome to Card Flipper',
              style: TextStyle(
                fontSize: 28.0,
                fontFamily: 'GoogleSans',
                color: Colors.black,
              ),
            ),
            content: Text(
              'Match two cards to score points. 1 pair match = 200 points',
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'GoogleSans',
                color: Colors.grey,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Timer(Duration(seconds: 0), runTimer);
                },
                child: Text(
                  " Let's play !",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'GoogleSans',
                    color: Colors.purple,
                  ),
                ),
              )
            ],
          );
        });
  }

  void runTimer() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        if (this.score == 2000) {
          this.time = -2;
          this.score = 0;
        }
        this.time += 1;
        runTimer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (init == 1) {
      init++;
      Future.delayed(Duration.zero, () => showalert(context));
    }
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(

            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //   Colors.black87,
            //   Colors.black87,
            //   Colors.orange,
            //   Colors.black87,
            //   Colors.black87
            // ])),

            ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 24.0),
            initializeGameScore(),
            initGameBoard(context)
          ],
        ),
      ),
    );
  }

  Widget initializeGameScore() {
    return buildScore();
  }

  Widget initGameBoard(BuildContext bcContext) {
    return buildBoard(bcContext);
  }

  Widget buildScore() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(time.toString() + "s",
              style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontFamily: 'GoogleSans')),
          Text(
            'Score: ' + score.toString(),
            style: TextStyle(
                fontSize: 32.0, color: Colors.black, fontFamily: 'GoogleSans'),
          )
        ],
      ),
    );
  }

  Widget buildBoard(BuildContext bcontext) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: CardBoard(
                onWin: onWin,
                context: bcontext,
              )),

          // buildGradientView()
        ],
      ),
    );
  }

  Widget buildGradientView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 32.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black, Colors.transparent])),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 32.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black])),
        )
      ],
    );
  }

  void onWin() {
    setState(() {
      if (this.score == 2000) {
        this.time = -2;
      }
      this.score += 200;
    });
  }
}
