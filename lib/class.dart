// PACKAGE
import 'dart:math';

import 'package:flutter/material.dart';

import 'enum.dart';



// CLASS
class PointClass {

  // CONSTRUCTOR
  PointClass (this.x, this.y);

  // PROPERTY
  final double x;
  final double y;
}

class ResultClass {

  // CONSTRUCTOR
  ResultClass (this.date, this.id, this.index, this.score);

  ResultClass.fromMap (Map <String, dynamic> map) {
    date = DateTime.fromMillisecondsSinceEpoch ((map ['date'] ?? 0) as int);
    id = (map ['id'] ?? '') as String;
    index = (map ['index'] ?? 0) as int;
    score = (map ['score'] ?? 0) as int;
  }

  // METHOD
  Map <String, dynamic> toMap () => <String, dynamic> {
    'date': date.millisecondsSinceEpoch,
    'id': id,
    'index': index,
    'score': score,
  };

  // PROPERTY
  DateTime date = DateTime.now ();
  int index = 0;
  int score = 0;
  String id = '';
}

class ScoreClass {

  // CONTRACTOR
  const ScoreClass (this.answers, this.index, this.wastes);

  // PROPERTY
  final int index;
  final List <bool> answers;
  final List <WasteClass> wastes;
}

class TreeClass {

  // CONSTRUCTOR
  const TreeClass ();

  // METHOD
  int createNumber () => Random ().nextInt (colors.length);


  // PROPERTY
  static const colors = <Color> [Colors.amber, Colors.amberAccent, Colors.brown, Colors.deepOrange, Colors.deepOrangeAccent, Colors.green, Colors.greenAccent, Colors.grey, Colors.lightGreen, Colors.lightGreenAccent, Colors.lime, Colors.limeAccent, Colors.orange, Colors.orangeAccent, Colors.pink, Colors.pinkAccent, Colors.red, Colors.redAccent, Colors.teal, Colors.tealAccent, Colors.white, Colors.white, Colors.yellowAccent];
}

class WasteClass {

  // CONSTRUCTOR
  const WasteClass (this.bin, this.name, this.path);

  // PROPERTY
  final BinEnum bin;
  final String name;
  final String path;
}
