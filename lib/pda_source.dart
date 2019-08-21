import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pda_scanner/pda_listener.dart';

class PdaSource {
  static const String channelName = 'com.shinow.pda_scanner/plugin';
  static EventChannel _scannerPlugin;
  static StreamSubscription _subscription;

  static List<PdaListenerState> listeners = [];

  static void init() {
    if (_scannerPlugin == null) _scannerPlugin = const EventChannel(channelName);
    if (_subscription == null) _subscription = _scannerPlugin.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  static void registerListener(PdaListenerState listener) {
    if (!listeners.contains(listener)) listeners.add(listener);
  }

  static void _onEvent(Object code) {
    listeners.forEach((listener) => listener.onEvent(code));
  }

  static void unRegisterListener(PdaListenerState listener) {
    if (listeners.contains(listener)) listeners.remove(listener);
  }

  static void _onError(Object error) {
    listeners.forEach((listener) => listener.onError(error));
  }

  /// You need to call this method to release resources when you exit the entire application.
  static void uninstall() {
    listeners.clear();
    assert(_subscription != null);
    _subscription.cancel();
  }
}
