import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pda_scanner/pda_listener.dart';

class PdaSource {
  static const scannerPlugin = const EventChannel('com.shinow.pda_scanner/plugin');
  static StreamSubscription _subscription = scannerPlugin.receiveBroadcastStream().listen(_onEvent, onError: _onError);

  static List<PdaListenerState> listeners = [];

  static void registerListener(PdaListenerState listener) {
    listeners.add(listener);
  }

  static void _onEvent(Object code) {
    listeners.forEach((listener) => listener.onEvent(code));
  }

  static void unRegisterListener(PdaListenerState listener) {
    listeners.remove(listener);
  }

  static void _onError(Object error) {
    listeners.forEach((listener) => listener.onError(error));
  }

  /// You need to call this method to release resources when you exit the entire application.
  static void uninstall() {
    assert(_subscription != null);
    _subscription.cancel();
  }
}
