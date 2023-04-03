// PACKAGE
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'class.dart';
import 'page.dart';
import 'provider.dart';



// MAIN
void main () {
  runApp (const MyApp ());

  setUrlStrategy (PathUrlStrategy ());
}

class MyApp extends StatelessWidget {

  // CONSTRUCTOR
  const MyApp ({super.key});



  // MAIN
  @override
  Widget build (BuildContext context) => WillPopScope (
    onWillPop: () async => false,
    child: ChangeNotifierProvider <DatabaseProvider> (
      create: (_) => DatabaseProvider ()..connectServer (),
      child: MaterialApp (
        initialRoute: '/',
        title: 'Pollute Beauty',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/landscape':
              return PageRouteBuilder <void> (pageBuilder: (_, __, ___) =>  LandscapePage ());

            case '/portrait':
              return PageRouteBuilder <void> (pageBuilder: (_, __, ___) => PortraitPage (settings.arguments as int));

            case '/score':
              return PageRouteBuilder <void> (pageBuilder: (_, __, ___) => ScorePage (settings.arguments as ScoreClass));

            default:
              return PageRouteBuilder <void> (pageBuilder: (_, __, ___) => const SplashPage ());
          }
        },
        theme: ThemeData (
          brightness: Brightness.light,
          fontFamily: GoogleFonts.inter ().fontFamily,
          scaffoldBackgroundColor: Colors.black,
        ),
      ),
    ),
  );
}
