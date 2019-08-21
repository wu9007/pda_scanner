# pda_scanner_example

```dart
import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_source.dart';
import 'package:pda_scanner/pda_listener.dart';

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

class PageBeta extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageBetaState();
}

class PageBetaState extends PdaListenerState<PageBeta> {
  var _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageBeta'),
      ),
      body: Column(
        children: <Widget>[
          Text('Scanning result: $_code\n'),
          RaisedButton(child: Text('Back to Alhpa'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

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
