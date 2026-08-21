import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_scanner.dart';

class PageBeta extends StatefulWidget {
  const PageBeta({super.key});

  @override
  State<PageBeta> createState() => PageBetaState();
}

class PageBetaState extends State<PageBeta> with PdaListenerMixin<PageBeta> {
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageBeta')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Scanning result: ${_code ?? '-'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Alpha'),
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
