// PACKAGE
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'class.dart';



// PAINTER
class TreePainter extends CustomPainter {

  // CONSTRUCTOR
  const TreePainter (this.index, this.score);

  // METHOD
  void drawTree (Canvas canvas, double angle, double length, int width, PointClass start) {
    if (width > 0) {
      final end = PointClass (length * math.cos (angle) + start.x, length * math.sin (angle) + start.y);

      final paint = Paint ()
        ..color = (score > 3 ? TreeClass.colors [index] : Colors.black).withOpacity (width * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.bevel
        ..strokeWidth = width.toDouble ();

      final path = Path ()
        ..moveTo (start.x, start.y)
        ..lineTo (end.x, end.y);

      canvas.drawPath (path, paint);

      const pi = math.pi * 0.425;

      for (var i = 0; i < (math.Random ().nextBool () ? 3 : 2); i ++) {
        drawTree (canvas, angle + math.Random ().nextDouble () * pi - pi * 0.5, length * (math.Random ().nextDouble () * 0.5 + 0.5), width - 1, end);
      }
    }
  }

  // PROPERTY
  final int index;
  final int score;



  // MAIN
  @override
  void paint (Canvas canvas, Size size) => drawTree (canvas, -math.pi / 2, size.height / 3, 10, PointClass (size.width / 2, size.height));

  @override
  bool shouldRepaint (CustomPainter oldDelegate) => true;
}
