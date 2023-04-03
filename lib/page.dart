// PACKAGE
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'class.dart';
import 'enum.dart';
import 'method.dart';
import 'painter.dart';
import 'provider.dart';
import 'widget.dart';



// PAGE
class LandscapePage extends StatelessWidget {

  // CONSTRUCTOR
  const LandscapePage ({super.key});

  // METHOD
  List <ResultClass> _createList (List <ResultClass> results1) {
    const max = 30;

    final scores = <int> [];

    var results2 = <ResultClass> [];

    if (results1.length > max) {
      for (var i = 0; i < max; i ++) {
        results2.add (results1 [results1.length - i - 1]);
      }

      results2.sort ((ResultClass a, ResultClass b) => a.date.compareTo (b.date));
    } else {
      results2 = results1;
    }

    for (final result in results2) {
      scores.add (result.score);
    }

    print ('[${scores.join ('.')}]');

    return results2;
  }



  // MAIN
  @override
  Widget build (BuildContext context) => Scaffold (body: Container (
    alignment: Alignment.bottomCenter,
    height: MediaQuery.of (context).size.height,
    width: MediaQuery.of (context).size.width,
    child: Consumer <DatabaseProvider> (builder: (_, DatabaseProvider provider, __) => Stack (children: _createList (provider.results).map ((ResultClass result) {
      final length = MediaQuery.of (context).size.shortestSide * 0.5;

      return CustomPaint (
        painter: TreePainter (result.index, result.score),
        size: Size (length, length),
      );
    }).toList (),),),
  ),);
}

class PortraitPage extends StatefulWidget {

  // CONSTRUCTOR
  const PortraitPage (this.index, {super.key});

  // PROPERTY
  final int index;



  // MAIN
  @override
  State <PortraitPage> createState () => _PortraitPageState ();
}
class _PortraitPageState extends State <PortraitPage> {

  // METHOD
  BinEnum _createEnum (String bin) {
    switch (bin) {
      case 'organics':
        return BinEnum.organics;

      case 'recycling':
        return BinEnum.recycling;

      default:
        return BinEnum.garbage;
    }
  }

  Color _createColor (BinEnum bin) {
    switch (bin) {
      case BinEnum.garbage:
        return const Color (0xFF4b4b4b);

      case BinEnum.organics:
        return const Color (0xFF008750);

      case BinEnum.recycling:
        return const Color (0xFF005a9b);
    }
  }



  // PROPERTY
  AnswerEnum _answer = AnswerEnum.other;
  bool _loaded = false;
  final List <bool> _answers = [];
  final List <WasteClass> _wastes = [];



  // MAIN
  @override
  void initState () {
    super.initState ();

    rootBundle.loadString ('asset/json/wastes.json').then ((String wastes) {
      for (final waste in jsonDecode (wastes) ['wastes'] as List <dynamic>) {
        _wastes.add (WasteClass (_createEnum ((waste ['bin'] ?? '') as String), (waste ['name'] ?? '') as String, (waste ['path'] ?? '') as String));
      }

      _wastes.shuffle ();

      if (_wastes.length >= 10) {
        setState (() => _loaded = true);
      }
    });
  }

  @override
  Widget build (_) => Scaffold (body: _loaded ? Stack (
    alignment: Alignment.center,
    children: [
      ListView (
        padding: EdgeInsets.symmetric (horizontal: MediaQuery.of (_).size.width * 0.05),
        children: [
          for (final text in ['Scroll screen down.', 'As you may know...', 'Many people are\nthrowing wastes away\nin Incorrect Bins.', 'Can you\ndispose of wastes below\ncorrectly?']) MessageContainer (text),
          Container (
            alignment: Alignment.center,
            height: MediaQuery.of (_).size.height,
            child: Column (
              mainAxisSize: MainAxisSize.min,
              children: [
                Container (
                  alignment: Alignment.center,
                  height: MediaQuery.of (_).size.width * 0.9,
                  padding: EdgeInsets.all (MediaQuery.of (_).size.shortestSide * 0.05),
                  width: MediaQuery.of (_).size.width * 0.9,
                  decoration: BoxDecoration (
                    borderRadius: BorderRadius.circular (10),
                    color: Colors.white,
                  ),
                  child: Column (
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset ('asset/svg/${_wastes [_answers.length].path}.svg', width: MediaQuery.of (_).size.width * 0.5),
                      Text (_wastes [_answers.length].name,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.75,
                        style: const TextStyle (
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox (height: MediaQuery.of (_).size.height * 0.025),
                LinearProgressIndicator (
                  backgroundColor: TreeClass.colors [widget.index].withOpacity (0.25),
                  color: TreeClass.colors [widget.index],
                  value: _answers.length / 10,
                ),
                SizedBox (height: MediaQuery.of (_).size.height * 0.05),
                Table (
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [TableRow (children: <BinEnum> [BinEnum.recycling, BinEnum.organics, BinEnum.garbage].map ((BinEnum bin) => Consumer <DatabaseProvider> (builder: (_, DatabaseProvider provider, __) => GestureDetector (
                    onTap: () {
                      if (_answer == AnswerEnum.other) {
                        setState (() => _answer = bin == _wastes [_answers.length].bin ? AnswerEnum.correct : AnswerEnum.incorrect);

                        Future <void>.delayed (const Duration (seconds: 1), () {
                          setState (() {
                            _answer = AnswerEnum.other;

                            _answers.add (_wastes [_answers.length].bin == bin);
                          });

                          if (_answers.length >= 10) {
                            provider.publishResult (widget.index, _answers.where ((bool value) => value == true).length).whenComplete (() => Navigator.of (context).pushReplacementNamed ('/score', arguments: ScoreClass (_answers, widget.index, _wastes)));
                          }
                        });
                      }
                    },
                    child: AspectRatio (
                      aspectRatio: 1 / 1,
                      child: Container (
                        alignment: Alignment.center,
                        margin: EdgeInsets.all (MediaQuery.of (_).size.height * 0.0125),
                        padding: EdgeInsets.all (MediaQuery.of (_).size.shortestSide * 0.005),
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular (10),
                          color: _createColor (bin),
                        ),
                        child: FittedBox (child: Text ('${createName (bin)}\nBin',
                          style: const TextStyle (color: Colors.white),
                          textAlign: TextAlign.center,
                        ),),
                      ),
                    ),
                  ),),).toList (),)],
                ),
              ],
            ),
          ),
        ],
      ),
      if (_answer != AnswerEnum.other) SvgPicture.asset ('asset/svg/${_answer.name}.svg', width: MediaQuery.of (_).size.width * 0.75),
    ],
  ) : const SizedBox.shrink (),);
}

class ScorePage extends StatelessWidget {

  // CONSTRUCTOR
  const ScorePage (this.score, {super.key});

  // METHOD
  String _createPercentage (double value) => (value * 100).toStringAsFixed (2);

  // PROPERTY
  final ScoreClass score;



  // MAIN
  @override
  Widget build (BuildContext context) => Scaffold (body: Consumer <DatabaseProvider> (builder: (_, DatabaseProvider provider, __) => ListView (
    padding: EdgeInsets.symmetric (horizontal: MediaQuery.of (context).size.width * 0.05),
    children: [
      Builder (builder: (_) {
        final count = score.answers.where ((bool value) => value == false).length;

        return MessageContainer ('You chose\nIncorrect Bins\n$count times (${_createPercentage (count / 10)}%)');
      },),
      if (provider.results.isNotEmpty) Builder (builder: (_) {
        var count = 0;

        for (final result in provider.results) {
          count += 10 - result.score;
        }

        final rate = count / (provider.results.length * 10);

        return Column (
          mainAxisSize: MainAxisSize.min,
          children: ['And\n${provider.results.length} people chose\nIncorrect Bins\n$count times (${_createPercentage (rate)}%).', '${rate > 0.3 ? 'Too much' : 'Keep going'}.'].map (MessageContainer.new).toList (),
        );
      },),
      const ListTile (
        contentPadding: EdgeInsets.zero,
        title: Text ('Your Result',
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle (
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox (height: MediaQuery.of (context).size.height * 0.05),
      for (int i = 0; i < score.answers.length; i ++) ListTile (
        contentPadding: EdgeInsets.zero,
        dense: true,
        subtitle: Text ('${createName (score.wastes [i].bin)} Bin',
          style: const TextStyle (color: Colors.grey),
          textScaleFactor: 0.75,
        ),
        title: Text (score.wastes [i].name,
          style: const TextStyle (color: Colors.white),
          textScaleFactor: 1,
        ),
        trailing: score.answers [i] ? Icon (Icons.check_circle,
          color: TreeClass.colors [score.index],
          size: MediaQuery.of (context).size.shortestSide * 0.025,
        ) : null,
      ),
      SizedBox (height: MediaQuery.of (context).size.height * 0.1),
      ListTile (
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text ('end',
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle (
            color: TreeClass.colors [score.index],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),),);
}

class SplashPage extends StatefulWidget {

  // CONSTRUCTOR
  const SplashPage ({super.key});



  // MAIN
  @override
  State <SplashPage> createState () => _SplashPageState ();
}
class _SplashPageState extends State <SplashPage> {

  // PROPERTY
  int _index = 0;



  // MAIN
  @override
  void initState () {
    super.initState ();

    setState (() => _index = const TreeClass ().createNumber ());

    Future <void>.delayed (const Duration (seconds: 1), () => MediaQuery.of (context).size.height < MediaQuery.of (context).size.width ? Navigator.of (context).pushReplacementNamed ('/landscape') : Navigator.of (context).pushReplacementNamed ('/portrait', arguments: _index));
  }

  @override
  Widget build (_) => Scaffold (
    backgroundColor: TreeClass.colors [_index],
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    body: const Center (child: Text ('Pollute Beauty',
      textAlign: TextAlign.center,
      textScaleFactor: 3,
      style: TextStyle (
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),),
    floatingActionButton: const Text ('KEITA FUJIYAMA',
      textScaleFactor: 1,
      style: TextStyle (
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
