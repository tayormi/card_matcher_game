import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameController extends ChangeNotifier {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];
  List<String> data = [];
  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  Timer timer;

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      time = time + 1;
      notifyListeners();
    });
  }

  void initState(int size) {
    for (var i = 0; i < size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
      notifyListeners();
    }
    for (var i = 0; i < size ~/ 2; i++) {
      data.add(i.toString());
      notifyListeners();
    }
    for (var i = 0; i < size ~/ 2; i++) {
      data.add(i.toString());
      notifyListeners();
    }
    startTimer();
    data.shuffle();
  }

  void matchCard(int index, BuildContext context) {
    if (!flip) {
      flip = true;
      previousIndex = index;
      notifyListeners();
    } else {
      flip = false;
      notifyListeners();
      if (previousIndex != index) {
        if (data[previousIndex] != data[index]) {
          cardStateKeys[previousIndex].currentState.toggleCard();
          previousIndex = index;
          notifyListeners();
        } else {
          cardFlips[previousIndex] = false;
          cardFlips[index] = false;
          notifyListeners();

          if (cardFlips.every((e) => e == false)) {
            print("Won");
            showMessage(context);
          }
        }
      }
    }
  }

  showMessage(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("Won!!!"),
              content: Text('Time $time'),
            ));
  }
}

final gameProvider = ChangeNotifierProvider<GameController>((ref) {
  return GameController();
});
