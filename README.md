Language: [English](README.md) | [中文简体](README-ZH.md)

# pda_scanner

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Pub](https://img.shields.io/pub/v/pda_scanner.svg)](https://pub.dev/packages/pda_scanner)

Flutter plugin that listens to **hardware scan-gun broadcasts** on industrial PDAs.

- Dart 3 / Flutter 3.10+ / Android embedding v2
- Android 13+ `RECEIVER_EXPORTED` (required for manufacturer scanner intents)
- Extra-key fallback so a new OEM does not need a plugin release
- Receivers are unregistered on detach (no leaked listeners)

Android only. Scan guns that type as a keyboard still work through Flutter text fields; this plugin is for **broadcast intent** mode.

## Install

```yaml
dependencies:
  pda_scanner: ^0.3.0
```

`minSdk` **21**.

## Supported manufacturers

| Brand | Typical action | Typical extra |
| --- | --- | --- |
| SEUIC (小码哥) | `com.android.scanner.broadcast` / `com.seuic.scanner.action.SCANNER_RESULT` | `scannerdata` |
| iData (盈达聚力) | `android.intent.action.SCANRESULT` | `value` |
| Urovo (优博讯) | `com.android.server.scannerservice.broadcast` | `scannerdata` |
| Honeywell | `com.honeywell.decode.intent.action.EDIT_DATA` | `data` |
| Newland (新大陆) | `nlscan.action.SCANNER_RESULT` | `SCAN_BARCODE1` |
| Panlian (攀凌) | `scan.rcv.message` | `barocode` + `length` |
| Zebra DataWedge | `com.symbol.datawedge.api.RESULT_ACTION` | `com.symbol.datawedge.data_string` |
| Sunmi | `com.sunmi.scanner.ACTION_DATA_CODE_RECEIVED` | `data` |
| CipherLab | `com.cipherlab.barcodebaseapi.PASS_DATA_2_APP` | `Decoder_Data` |
| Datalogic | `com.datalogic.decodewedge.decode_action` | `com.datalogic.decode.intentwedge.barcode_string` |
| Bluebird | `kr.co.bluebird.android.bbkey.BARCODE` | `EXTRA_BARCODE_DECODING_DATA` |
| Speedata | `com.spd.action.SCAN_CALLBACK` | `scannerdata` |

Unknown OEM? The plugin still tries a list of common extras, then the first non-empty string extra. Open an issue with `adb logcat` of the intent if yours is missing.

## Usage

Init once on the **root** widget, listen on each page that should receive scans.

```dart
import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_scanner.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});
  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with PdaLifecycleMixin<RootApp> {
  @override
  Widget build(BuildContext context) => const MaterialApp(home: ScanPage());
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with PdaListenerMixin<ScanPage> {
  String? code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(code ?? 'Scan a barcode')),
    );
  }

  @override
  void onEvent(Object event) => setState(() => code = event.toString());

  @override
  void onError(Object error) {}
}
```

If the `State` already mixes in another type and you cannot use the mixins as-is, call the methods yourself:

- Root: `initPdaLifecycle()` / `disposePdaLifecycle()`
- Page: `registerPdaListener()` / `unRegisterPdaListener()`

`PdaListenerMixin` only fires when the route is current, so a covered page does not steal the scan.

```dart
PdaSource.latest;       // last payload
PdaSource.isListening;  // event channel is open
PdaSource.manufacturers;
```

## Migrating from 0.2.x

- SDK `>=3.0.0 <4.0.0`
- Import `package:pda_scanner/pda_scanner.dart` (barrel) or the same three files as before
- Android embedding **v2 only** — `registerWith` is gone
- `RaisedButton` in the example is now `ElevatedButton`

## License

MIT
