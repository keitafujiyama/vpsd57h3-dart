// PACKAGE
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';

import 'class.dart';



// PROVIDER
class DatabaseProvider with ChangeNotifier {

  // METHOD
  Future <void> connectServer () async {
    _id = Random ().nextInt (1000000000).toString ();

    while (_id.length < 9) {
      _id = '0$_id';
    }

    _id = 'user$_id';

    _server = PubNub (defaultKeyset: Keyset (
      publishKey: 'pub-c-e9ac4af0-4c78-45be-9dd2-2ebcf9d89aee',
      subscribeKey: 'sub-c-887ac1cc-e8cb-4282-87ef-4d17cd57c1e3',
      userId: UserId (_id),
    ),);

    final history = _server.channel (_channel).history ();

    while (history.messages.length % 100 == 0) {
      await history.more ();
    }

    for (final message in history.messages) {
      _addResult (ResultClass.fromMap (message.content as Map <String, dynamic>));

      notifyListeners ();
    }

    print ('CONNECTED');


    _server.subscribe (channels: {_channel}).messages.listen ((Envelope envelope) {
      _addResult (ResultClass.fromMap (envelope.content as Map <String, dynamic>));

      notifyListeners ();
    });
  }

  Future <void> publishResult (int index, int score) async {
    if (results.where ((ResultClass result) => _id == result.id).isEmpty) {
      unawaited (_server.publish (_channel, ResultClass (DateTime.now (), _id, index, score).toMap ()));
    }
  }

  void _addResult (ResultClass result) {
    results
      ..add (result)
      ..sort ((ResultClass a, ResultClass b) => a.date.compareTo (b.date));

    notifyListeners ();
  }

  // PROPERTY
  final String _channel = 'vpsd57h3';
  List <ResultClass> results = [];
  PubNub _server = PubNub ();
  String _id = '';
}
