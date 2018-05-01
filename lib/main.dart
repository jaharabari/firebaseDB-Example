import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

final FirebaseApp app = new FirebaseApp(
  name: 'healthtips-e5f8b',
  options: Platform.isIOS
      ? const FirebaseOptions(
          googleAppID: '1:201270209376:ios:c9141861637ad7f4',
          gcmSenderID: '201270209376',
          databaseURL: 'https://healthtips-e5f8b.firebaseio.com',
        )
      : const FirebaseOptions(
          googleAppID: '1:201270209376:android:c9141861637ad7f4',
          apiKey: 'AIzaSyAuzQJATf1xSmM7UKlrEgp1p9LaTBYEU-M',
          databaseURL: 'https://healthtips-e5f8b.firebaseio.com',
        ),
);

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Database Example',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference _tipsRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  bool _anchorToBottom = false;

  @override
  void initState() {
    super.initState();
    FirebaseApp.configure(name: app.name, options: app.options);

    final FirebaseDatabase database = new FirebaseDatabase(app: app);

    _tipsRef = database.reference().child('tips');
  }

  @override
  void dispose() {
    super.dispose();
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.body1;
    textStyle = textStyle.copyWith(color: Colors.black);
    textStyle = textStyle.copyWith(fontSize: 18.0);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Health Tips'),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              key: new ValueKey<bool>(_anchorToBottom),
              query: _tipsRef,
              reverse: _anchorToBottom,
              sort: _anchorToBottom
                  ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                  : null,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new SizeTransition(
                    sizeFactor: animation,
                    child: new Card(
                        child: new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new Text(
                        "${snapshot.value.toString()}",
                        style: textStyle,
                      ),
                    )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
