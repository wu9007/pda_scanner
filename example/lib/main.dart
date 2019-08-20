import 'package:flutter/material.dart';

import 'package:pda_scanner/pda_listener.dart';
import 'package:pda_scanner/pda_source.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends PdaListenerState<MyApp> {
  var _code;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    /// You need to call this method to release resources when you exit the entire application.
    PdaSource.uninstall();
  }

  @override
  void onEvent(Object event) {
    setState(() {
      _code = event;
      print("ChannelPage: $event");
    });
  }

  @override
  void onError(Object error) {
    setState(() {
      _code = "扫描异常";
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Scanning result: $_code\n'),
        ),
      ),
    );
  }
}
