import 'package:flutter/material.dart';

import 'pda_source.dart';

/// Mixin on a page [State] to receive hardware scan events while the route is current.
mixin PdaListenerMixin<T extends StatefulWidget> on State<T> {
  void onEvent(Object code);

  void onError(Object error);

  void checkRouteAndFireEvent(Object? code) {
    if (code == null) {
      return;
    }
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      return;
    }
    onEvent(code);
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
    registerPdaListener();
  }

  @override
  void dispose() {
    unRegisterPdaListener();
    super.dispose();
  }
}
