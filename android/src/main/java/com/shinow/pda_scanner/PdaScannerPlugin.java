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
    private static final String CHANNEL = "com.shinow.pda_scanner/plugin";
    private static final String XM_SCAN_ACTION = "com.android.server.scannerservice.broadcast";
    private static final String IDATA_SCAN_ACTION = "android.intent.action.SCANRESULT";
    private static final String YBX_SCAN_ACTION = "android.intent.ACTION_DECODE_DATA";
    private static final String BARCODE_DATA_ACTION = "com.ehsy.warehouse.action.BARCODE_DATA";

    private static EventChannel.EventSink eventSink;

    private static final BroadcastReceiver scanReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (XM_SCAN_ACTION.equals(intent.getAction())) {
                eventSink.success(intent.getStringExtra("scannerdata"));
            } else if (IDATA_SCAN_ACTION.equals(intent.getAction())) {
                eventSink.success(intent.getStringExtra("value"));
            } else if (YBX_SCAN_ACTION.equals(intent.getAction())) {
                eventSink.success(intent.getStringExtra("barcode"));
            } else if (BARCODE_DATA_ACTION.equals(intent.getAction())) {
                eventSink.success(intent.getStringExtra("data"));
            } else {
                Log.i("PdaScannerPlugin", "NoSuchAction");
            }
        }
    };

    private PdaScannerPlugin(Activity activity) {
        IntentFilter xmIntentFilter = new IntentFilter();
        xmIntentFilter.addAction(XM_SCAN_ACTION);
        xmIntentFilter.setPriority(Integer.MAX_VALUE);
        activity.registerReceiver(scanReceiver, xmIntentFilter);

        IntentFilter iDataIntentFilter = new IntentFilter();
        iDataIntentFilter.addAction(IDATA_SCAN_ACTION);
        iDataIntentFilter.setPriority(Integer.MAX_VALUE);
        activity.registerReceiver(scanReceiver, iDataIntentFilter);

        IntentFilter yBoXunIntentFilter = new IntentFilter();
        yBoXunIntentFilter.addAction(IDATA_SCAN_ACTION);
        yBoXunIntentFilter.setPriority(Integer.MAX_VALUE);
        activity.registerReceiver(scanReceiver, yBoXunIntentFilter);

        IntentFilter honeyIntentFilter = new IntentFilter();
        honeyIntentFilter.addAction(BARCODE_DATA_ACTION);
        honeyIntentFilter.setPriority(Integer.MAX_VALUE);
        activity.registerReceiver(scanReceiver, honeyIntentFilter);
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
        Log.i("PdaScannerPlugin", "PdaScannerPlugin:onCancel");
    }
}
