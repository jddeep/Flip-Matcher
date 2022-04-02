import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'card_item.dart';

class CardBoard extends StatefulWidget {
  final Function()? onWin;
  final BuildContext? context;

  //const CardBoard({Key key, this.onWin}) : super(key: key);
  CardBoard({Key? key, this.onWin, this.context}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CardBoardState();
  }
}

class CardBoardState extends State<CardBoard> {
  List<int> openedCards = [];
  late List<CardModel> cards;
  late int a;
  int score = 0;
  int time = 0;

  @override
  void initState() {
    super.initState();
    a = 1;
    cards = createCards();
  }

  List<CardModel> createCards() {
    List<String> asset = [];
    List.filled(10, null, growable: false)
        .forEach((f) => asset.add('0${(asset.length + 1)}.png'));
    List.filled(10, null, growable: false)
        .forEach((f) => asset.add('0${(asset.length - 10 + 1)}.png'));
    return List.filled(20, null, growable: false).map((f) {
      int index = Random().nextInt(1000) % asset.length;
      String _image =
          'assets/' + asset[index].substring(asset[index].length - 6);
      asset.removeAt(index);
      return CardModel(
          id: 20 - asset.length - 1, image: _image, key: UniqueKey());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.zero,
        //  physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 4,
        childAspectRatio: 322 / 400,
        children: cards
            .map((f) =>
                CardItem(key: f.key, model: f, onFlipCard: handleFlipCard))
            .toList());
  }

  handleFlipCard(bool isOpened, int? id) {
    cards[id!].isNeedCloseEffect = false;

    checkOpenedCard(isOpened);

    if (isOpened) {
      setCardOpened(id);
      openedCards.add(id);
    } else {
      setCardNone(id);
      openedCards.remove(id);
    }

    checkWin();
    checkOver();
  }

  void checkOver() {
    if (a >= 11) {
      a = 1;
      BuildContext context = widget.context!;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Congratulations!"),
              content: Text("You WIN !"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    cards = createCards();
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(score: 0, time: 0)));
                  },
                  child: Text("Play Again"),
                ),
              ],
            );
          });
    }
  }

  // void resetTimer(){
  //   Timer(Duration(seconds: 1), (){
  //     setState(() {
  //             this.time+=1;
  //             resetTimer();
  //           });
  //   });
  // }

  void checkOpenedCard(bool isOpened) {
    if (openedCards.length == 2 && isOpened) {
      cards[openedCards[0]].isNeedCloseEffect = true;
      setCardNone(openedCards[0]);
      cards[openedCards[1]].isNeedCloseEffect = true;
      setCardNone(openedCards[1]);
      openedCards.clear();
    }
  }

  void checkWin() {
    if (openedCards.length == 2) {
      if (cards[openedCards[0]].image == cards[openedCards[1]].image) {
        setCardWin(openedCards[0]);
        setCardWin(openedCards[1]);
        openedCards.clear();
        a++;
        widget.onWin!();
      }
    }
  }

  void setCardNone(int id) {
    setState(() {
      cards[id].status = ECardStatus.None;
      cards[id].key = UniqueKey();
    });
  }

  void setCardOpened(int id) {
    setState(() {
      cards[id].status = ECardStatus.Opened;
      cards[id].key = UniqueKey();
    });
  }

  void setCardWin(int id) {
    setState(() {
      cards[id].status = ECardStatus.Win;
      cards[id].key = UniqueKey();
    });
  }
}
