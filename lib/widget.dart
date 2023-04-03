// PACKAGE
import 'package:flutter/material.dart';



// WIDGET
class MessageContainer extends StatelessWidget {

  // CONSTRUCTOR
  const MessageContainer (this.text, {super.key});

  // PROPERTY
  final String text;



  // MAIN
  @override
  Widget build (BuildContext context) => Container (
    alignment: Alignment.center,
    height: MediaQuery.of (context).size.height,
    child: Text (text,
      textAlign: TextAlign.center,
      textScaleFactor: 1.5,
      style: const TextStyle (
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
