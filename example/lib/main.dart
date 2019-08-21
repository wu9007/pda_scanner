import 'package:flutter/material.dart';

import 'package:pda_scanner/pda_source.dart';

import 'page_alpha.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /// You need to initialize it as necessary, when the program starts for the first time.
    PdaSource.init();
  }

  @override
  void dispose() {
    super.dispose();
    /// You need to call this method to release resources when you exit the entire application.
    PdaSource.uninstall();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageAlpha(),
    );
  }
}
