import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pda_scanner/pda_listener_mixin.dart';

class PdaSource {
  static const String channelName = 'com.shinow.pda_scanner/plugin';
  static const EventChannel _scannerPlugin = EventChannel(channelName);
  static StreamSubscription<dynamic>? _subscription;

  static final List<PdaListenerMixin> listeners = <PdaListenerMixin>[];

  /// Latest raw scan payload, if any.
  static String? latest;

  static bool get isListening => _subscription != null;

  /// Manufacturers whose broadcast intents are registered on Android.
  static const List<String> manufacturers = <String>[
    'SEUIC',
    'iData',
    'Urovo',
    'Honeywell',
    'Newland',
    'Panlian',
    'Zebra DataWedge',
    'Sunmi',
    'CipherLab',
    'Datalogic',
    'Bluebird',
    'Speedata',
  ];

  /// Call once from the root widget (see [PdaLifecycleMixin]).
  static void init() {
    _subscription ??= _scannerPlugin
        .receiveBroadcastStream()
        .listen(_onEvent, onError: _onError);
  }

  static void registerListener(PdaListenerMixin listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  static void unRegisterListener(PdaListenerMixin listener) {
    listeners.remove(listener);
  }

  /// Release the event subscription when the app is disposed.
  static void dispose() {
    listeners.clear();
    _subscription?.cancel();
    _subscription = null;
    latest = null;
  }

  static void _onEvent(dynamic code) {
    if (code != null) {
      latest = code.toString();
    }
    for (final PdaListenerMixin listener in List<PdaListenerMixin>.from(listeners)) {
      listener.checkRouteAndFireEvent(code);
    }
  }

  static void _onError(Object error) {
    for (final PdaListenerMixin listener in List<PdaListenerMixin>.from(listeners)) {
      listener.onError(error);
    }
  }
}
