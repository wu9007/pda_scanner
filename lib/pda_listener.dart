import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_source.dart';

/// If you want to listen for scavenging events, you need to extends PdaListenerState<T extends StatefulWidget> instead of State<T extends StatefulWidget>
abstract class PdaListenerState<T extends StatefulWidget> extends State<T> {
  /// You need to override this callback method to listen for scanned events.
  void onEvent(Object code);

  /// If u wanna custom on error callback, u need to override this method.
  void onError(Object error) {
    throw new Exception(error);
  }

  void checkRouteAndFireEvent(Object code) {
    if (!ModalRoute.of(context).isCurrent) return;
    this.onEvent(code);
  }

  @override
  void initState() {
    super.initState();
    PdaSource.registerListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    PdaSource.unRegisterListener(this);
  }
}
