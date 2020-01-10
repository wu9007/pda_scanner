import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_lifecycle_mixin.dart';

import 'page_alpha.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with PdaLifecycleMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageAlpha(),
    );
  }
}
