# PDA Scanner
  
[![License][license-image]][license-url] 
[![Pub](https://img.shields.io/pub/v/pda_scanner.svg?style=flat-square)](https://pub.dartlang.org/packages/pda_scanner)

A Flutter plugin 🛠 to scanning. Ready for PDA 🚀 

[github](https://github.com/leyan95/pda_scanner)

![pda_scanner.gif](https://upload-images.jianshu.io/upload_images/3646846-16ca17b573a765f2.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/320/format/webp)

## Installation

Add this to your package's pubspec.yaml file:

```
dependencies:
 pda_scanner: ^0.1.4
```

## Usage example
```dart
static const scannerPlugin = const EventChannel('com.shinow.pda_scanner/plugin');
StreamSubscription _subscription;
var _code;

@override
void initState() {
super.initState();
if (_subscription == null) {
  _subscription = scannerPlugin
      .receiveBroadcastStream()
      .listen(_onEvent, onError: _onError);
}
}

@override
void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
  }
}

void _onEvent(Object event) {
    setState(() {
      _code = event;
      print("ChannelPage: $event");
    });
}

void _onError(Object error) {
    setState(() {
      _code = "扫描异常";
      print(error);
    });
}
```

## Contribute

We would ❤️ to see your contribution!

## License

Distributed under the MIT license. See ``LICENSE`` for more information.

## About

Created by Shusheng.

[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
