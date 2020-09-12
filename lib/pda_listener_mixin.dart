import 'package:flutter/material.dart';

import 'pda_source.dart';

/// If you want to listen for scavenging events, you need to mixin PdaListenerMixin<T extends StatefulWidget> to State<T extends StatefulWidget>
mixin PdaListenerMixin<T extends StatefulWidget> on State<T> {
  /// You need to override this callback method to listen for scanned events.
  void onEvent(Object code);

  /// If u wanna custom on error callback, u need to implement this method.
  void onError(Object error);

  void checkRouteAndFireEvent(Object code) {
    if (!ModalRoute.of(context).isCurrent) return;
    this.onEvent(code);
  }

  void registerPdaListener() {
    PdaSource.registerListener(this);
  }

  void unRegisterPdaListener() {
    PdaSource.unRegisterListener(this);
  }

  @override
  void initState() {
    super.initState();
    this.registerPdaListener();
  }

  @override
  void dispose() {
    super.dispose();
    this.unRegisterPdaListener();
  }
}
