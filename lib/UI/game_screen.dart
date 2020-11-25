import 'package:card_matcher_game/controller/game_controller.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameScreen extends HookWidget {
  final int level;

  GameScreen({this.level = 8});

  @override
  Widget build(BuildContext context) {
    final vm = useProvider(gameProvider);
    useEffect(() {
      Future.microtask(() => vm.initState(level));
    });
    return Scaffold(
        backgroundColor: Color(0xFFeff1f5),
        body: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Card Matcher",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Make a move in less time",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${vm.time} Seconds",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return FlipCard(
                            key: vm.cardStateKeys[index],
                            direction: FlipDirection.HORIZONTAL,
                            flipOnTouch: vm.cardFlips[index],
                            onFlip: () => vm.matchCard(index, context),
                            front: Container(
                              margin: EdgeInsets.all(4),
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, 3))
                                  ]),
                            ),
                            back: Container(
                                margin: EdgeInsets.all(4),
                                height: 20,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF50a026),
                                          Color(0xFF72c837)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [0.2, 1]),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: Offset(0, 3))
                                    ]),
                                child: Center(
                                    child: Text(
                                  '${vm.data[index]}',
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ))),
                          );
                        },
                        itemCount: level,
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
