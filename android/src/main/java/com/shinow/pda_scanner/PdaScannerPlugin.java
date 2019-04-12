package com.shinow.pda_scanner;

import android.content.IntentFilter;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

public class PdaScannerPlugin implements EventChannel.StreamHandler {
  public static final String CHANNEL = "com.shinow.pda_scanner/plugin";
  private static final String SCAN_ACTION = "com.android.server.scannerservice.broadcast";

  private static EventChannel.EventSink eventSink;

  private Activity activity;
  private static final BroadcastReceiver scanReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      if (SCAN_ACTION.equals(intent.getAction())) {
        String code = intent.getStringExtra("scannerdata");
        eventSink.success(code);
      } else {
        Log.i("PdaScannerPlugin", "NoSuchAction");
      }
    }
  };

  private PdaScannerPlugin(Activity activity) {
    this.activity = activity;
    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addAction(SCAN_ACTION);
    intentFilter.setPriority(Integer.MAX_VALUE);
    activity.registerReceiver(scanReceiver, intentFilter);
  }

  public static void registerWith(PluginRegistry.Registrar registrar) {
    EventChannel channel = new EventChannel(registrar.messenger(), CHANNEL);
    PdaScannerPlugin plugin = new PdaScannerPlugin(registrar.activity());
    channel.setStreamHandler(plugin);
  }

  @Override
  public void onListen(Object o, final EventChannel.EventSink eventSink) {
    PdaScannerPlugin.eventSink = eventSink;
  }

  @Override
  public void onCancel(Object o) {
//        this.activity.unregisterReceiver(scanReceiver);
    Log.i("PdaScannerPlugin", "PdaScannerPlugin:onCancel");
  }
}
