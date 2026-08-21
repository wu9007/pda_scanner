import 'package:flutter/widgets.dart';
import 'package:pda_scanner/pda_source.dart';

/// Mixin on the root widget [State] to start and stop the PDA event channel.
mixin PdaLifecycleMixin<T extends StatefulWidget> on State<T> {
  void initPdaLifecycle() {
    PdaSource.init();
  }

  void disposePdaLifecycle() {
    PdaSource.dispose();
  }

  @override
  void initState() {
    initPdaLifecycle();
    super.initState();
  }

  @override
  void dispose() {
    disposePdaLifecycle();
    super.dispose();
  }
}
