import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pda_scanner/pda_scanner.dart';

void main() {
  const MethodChannel channel = MethodChannel('pda_scanner');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PdaScanner.platformVersion, '42');
  });
}
