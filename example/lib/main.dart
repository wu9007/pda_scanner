import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_scanner.dart';

import 'page_alpha.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with PdaLifecycleMixin<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PageAlpha(),
    );
  }
}
