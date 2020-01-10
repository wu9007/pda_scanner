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
 pda_scanner: ^0.2.4
```

## Supported

-  [x] SEUIC(小码哥)-PDA
-  [x] IData(盈达聚力)-PDA
-  [x] UROVO(优博讯)-PDA
-  [x] HONEYWELL(霍尼韦尔) PDA

## Usage
```dart
/// 导入依赖
import 'package:pda_scanner/pda_source.dart';
import 'package:pda_scanner/pda_listener_mixin.dart';
import 'package:pda_scanner/pda_lifecycle_mixin.dart';

/// 自动管理pda生命周期(自动初始化和自动释放)，使用PdaLifecycleMixin混入app根组件状态。
class RootWidgetState extends State<RootWidget> with PdaLifecycleMixin {
  @override
  Widget build(BuildContext context) {
    //TODO
  }
}

/// 手动初始化 PdaSource.
PdaSource.init();

/// 手动释放 PdaSource 相关资源.
PdaSource.dispose();

class PageAlpha extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageAlphaState();
}

/// 混入 PdaListenerMixin 监听扫码事件
class PageAlphaState extends State<PageAlpha> with PdaListenerMixin {
  var _code;

  @override
  Widget build(BuildContext context) {
    return null;
  }

  @override
  void onEvent(Object event) {
      // TODO: implement onEvent
  }
  
    @override
  void onError(Object error) {
      // TODO: implement onError
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
