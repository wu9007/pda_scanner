import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_scanner.dart';

import 'page_beta.dart';

class PageAlpha extends StatefulWidget {
  const PageAlpha({super.key});

  @override
  State<PageAlpha> createState() => PageAlphaState();
}

class PageAlphaState extends State<PageAlpha> with PdaListenerMixin<PageAlpha> {
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageAlpha')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Scanning result: ${_code ?? '-'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const PageBeta()),
              ),
              child: const Text('Go to Beta'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onEvent(Object event) {
    setState(() => _code = event.toString());
  }

  @override
  void onError(Object error) {}
}
