文档语言: [English](README.md) | [中文简体](README-ZH.md)

# pda_scanner

工业 PDA 硬件扫码枪 Flutter 插件。监听厂商广播 Intent，把条码推到 Dart。

- Dart 3 / Flutter 3.10+ / Android embedding v2
- Android 13+ 使用 `RECEIVER_EXPORTED`
- 多 extra 兜底，新机型不一定要发版
- Activity 脱离时反注册，不再泄漏 Receiver

仅 Android。键盘楔入模式的扫码枪走输入框即可，本插件针对 **广播模式**。

## 安装

```yaml
dependencies:
  pda_scanner: ^0.3.0
```

`minSdk` **21**。

## 支持的机型

SEUIC 小码哥、iData 盈达聚力、优博讯、霍尼韦尔、新大陆、攀凌、Zebra DataWedge、商米、CipherLab、Datalogic、Bluebird、思必达。

缺机型请带 `adb logcat` 里的 action / extra 开 Issue。

## 用法

根组件混入 `PdaLifecycleMixin`，需要收码的页面混入 `PdaListenerMixin`。

```dart
class _RootAppState extends State<RootApp> with PdaLifecycleMixin<RootApp> { /* ... */ }

class _ScanPageState extends State<ScanPage> with PdaListenerMixin<ScanPage> {
  @override
  void onEvent(Object event) { /* 当前路由才会收到 */ }

  @override
  void onError(Object error) {}
}
```

多 mixin 冲突时手动调：

- 根：`initPdaLifecycle()` / `disposePdaLifecycle()`
- 页：`registerPdaListener()` / `unRegisterPdaListener()`

## 从 0.2.x 升级

- SDK `>=3.0.0`
- 仅 embedding v2
- 可 `import 'package:pda_scanner/pda_scanner.dart'`

## License

MIT
