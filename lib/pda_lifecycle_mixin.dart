import 'package:flutter/widgets.dart';
import 'package:pda_scanner/pda_source.dart';

/// Auto manage the lifecycle of Pda plugin(PdaSource).
/// Mixin to the state of the root widget.
mixin PdaLifecycleMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    PdaSource.init();
    super.initState();
  }

  @override
  void dispose() {
    PdaSource.dispose();
    super.dispose();
  }
}
