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
 pda_scanner: ^0.2.0
```

## Usage
```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    /// 程序启动时初始化 PdaSource.
    PdaSource.init();
  }

  @override
  void dispose() {
    super.dispose();
    /// 退出应用程序时释放 PdaSource 相关资源.
    PdaSource.uninstall();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageAlpha(),
    );
  }
}

class PageAlpha extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageAlphaState();
}

class PageAlphaState extends PdaListenerState<PageAlpha> {
  var _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageAlpha'),
      ),
      body: Column(
        children: <Widget>[
          Text('Scanning result: $_code\n'),
          RaisedButton(
            child: Text('Got to Beta'),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageBeta())),
          ),
        ],
      ),
    );
  }

  /// 监听扫描事件
  @override
  void onEvent(Object event) {
    if (!ModalRoute.of(context).isCurrent) return;
    setState(() {
      _code = event;
      print("ChannelPage: $event");
    });
  }
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
