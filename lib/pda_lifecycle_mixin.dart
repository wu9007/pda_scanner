import 'package:flutter/widgets.dart';
import 'package:pda_scanner/pda_source.dart';

/// Auto manage the lifecycle of Pda plugin(PdaSource).
/// Mixin to the state of the root widget.
mixin PdaLifecycleMixin<T extends StatefulWidget> on State<T> {
  void initPdaLifecycle() {
    PdaSource.init();
  }

  void disposePdaLifecycle() {
    PdaSource.dispose();
  }

  @override
  void initState() {
    this.initPdaLifecycle();
    super.initState();
  }

  @override
  void dispose() {
    this.disposePdaLifecycle();
    super.dispose();
  }
}
