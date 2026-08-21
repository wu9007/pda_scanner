package com.shinow.pda_scanner;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;

/**
 * Forwards hardware scan-gun broadcasts from industrial PDAs to Flutter.
 * Channel: {@code com.shinow.pda_scanner/plugin}.
 *
 * Android 13+ registers with {@link Context#RECEIVER_EXPORTED} because the
 * intents originate from manufacturer scanner services, not this app.
 */
public class PdaScannerPlugin implements FlutterPlugin, ActivityAware, EventChannel.StreamHandler {
    private static final String TAG = "PdaScannerPlugin";
    static final String CHANNEL = "com.shinow.pda_scanner/plugin";

    static final String[] ACTIONS = new String[]{
            "com.android.server.scannerservice.broadcast",
            "com.android.server.scannerservice.shinow",
            "android.intent.action.SCANRESULT",
            "android.intent.ACTION_DECODE_DATA",
            "scan.rcv.message",
            "com.ehsy.warehouse.action.BARCODE_DATA",
            "com.honeywell.decode.intent.action.EDIT_DATA",
            "com.honeywell.intent.action.SCAN_RESULT",
            "com.android.scanner.service_settings",
            "com.android.scanner.broadcast",
            "com.seuic.scanner.action.SCANNER_RESULT",
            "nlscan.action.SCANNER_RESULT",
            "com.symbol.datawedge.api.RESULT_ACTION",
            "com.symbol.datawedge.api.NOTIFICATION_ACTION",
            "com.sunmi.scanner.ACTION_DATA_CODE_RECEIVED",
            "com.cipherlab.barcodebaseapi.PASS_DATA_2_APP",
            "com.datalogic.decodewedge.decode_action",
            "kr.co.bluebird.android.bbkey.BARCODE",
            "com.spd.action.SCAN_CALLBACK",
            "android.intent.ACTION_SCAN_OUTPUT"
    };

    static final String[] EXTRA_KEYS = new String[]{
            "scannerdata",
            "value",
            "barcode_string",
            "data",
            "SCAN_BARCODE1",
            "com.symbol.datawedge.data_string",
            "com.sunmi.scanner.data",
            "barcode",
            "BARCODE",
            "Decoder_Data",
            "decode_data",
            "SCAN_DECODE_DATA",
            "data_string",
            "scan_data",
            "SCAN_BARCODE",
            "EXTRA_BARCODE_DECODING_DATA",
            "com.datalogic.decode.intentwedge.barcode_string",
            "barcode_display_data",
            "SCAN_RESULT"
    };

    private EventChannel eventChannel;
    @Nullable
    private EventChannel.EventSink eventSink;
    @Nullable
    private Context appContext;
    @Nullable
    private Activity activity;
    @Nullable
    private Context registerContext;
    @Nullable
    private BroadcastReceiver scanReceiver;
    private boolean registered = false;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        appContext = binding.getApplicationContext();
        eventChannel = new EventChannel(binding.getBinaryMessenger(), CHANNEL);
        eventChannel.setStreamHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (eventChannel != null) {
            eventChannel.setStreamHandler(null);
            eventChannel = null;
        }
        unregister();
        appContext = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        register();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        register();
    }

    @Override
    public void onDetachedFromActivity() {
        unregister();
        activity = null;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        register();
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    @Nullable
    private Context host() {
        if (activity != null) {
            return activity;
        }
        return appContext;
    }

    private synchronized void register() {
        Context context = host();
        if (context == null || registered) {
            return;
        }
        scanReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context ctx, Intent intent) {
                String code = extract(intent);
                if (code == null || code.isEmpty()) {
                    Log.i(TAG, "No payload for action " + intent.getAction());
                    return;
                }
                EventChannel.EventSink sink = eventSink;
                if (sink != null) {
                    sink.success(code);
                }
            }
        };
        IntentFilter filter = new IntentFilter();
        filter.setPriority(Integer.MAX_VALUE);
        for (String action : ACTIONS) {
            filter.addAction(action);
        }
        try {
            if (Build.VERSION.SDK_INT >= 33) {
                context.registerReceiver(scanReceiver, filter, Context.RECEIVER_EXPORTED);
            } else {
                context.registerReceiver(scanReceiver, filter);
            }
            registerContext = context;
            registered = true;
            Log.i(TAG, "Registered " + ACTIONS.length + " scan actions");
        } catch (Exception e) {
            Log.e(TAG, "Failed to register scan receiver", e);
            scanReceiver = null;
        }
    }

    private synchronized void unregister() {
        if (!registered || scanReceiver == null || registerContext == null) {
            registered = false;
            scanReceiver = null;
            registerContext = null;
            return;
        }
        try {
            registerContext.unregisterReceiver(scanReceiver);
        } catch (Exception e) {
            Log.w(TAG, "unregisterReceiver: " + e.getMessage());
        }
        registered = false;
        scanReceiver = null;
        registerContext = null;
    }

    @Nullable
    static String extract(Intent intent) {
        if (intent == null) {
            return null;
        }
        Bundle extras = intent.getExtras();
        if (extras == null) {
            return null;
        }
        for (String key : EXTRA_KEYS) {
            String value = stringify(extras, key);
            if (value != null) {
                return value;
            }
        }
        String fromBytes = fromByteExtra(extras, "barocode");
        if (fromBytes == null) {
            fromBytes = fromByteExtra(extras, "barcode");
        }
        if (fromBytes != null) {
            return fromBytes;
        }
        for (String key : extras.keySet()) {
            String value = stringify(extras, key);
            if (value != null) {
                return value;
            }
        }
        return null;
    }

    @Nullable
    private static String stringify(Bundle extras, String key) {
        if (!extras.containsKey(key)) {
            return null;
        }
        Object value = extras.get(key);
        if (value instanceof String) {
            String s = ((String) value).trim();
            return s.isEmpty() ? null : s;
        }
        if (value instanceof byte[]) {
            return fromBytes(extras, (byte[]) value);
        }
        if (value instanceof CharSequence) {
            String s = value.toString().trim();
            return s.isEmpty() ? null : s;
        }
        return null;
    }

    @Nullable
    private static String fromByteExtra(Bundle extras, String key) {
        byte[] bytes = extras.getByteArray(key);
        if (bytes == null || bytes.length == 0) {
            return null;
        }
        return fromBytes(extras, bytes);
    }

    @Nullable
    private static String fromBytes(Bundle extras, byte[] bytes) {
        int len = extras.getInt("length", bytes.length);
        if (len <= 0) {
            return null;
        }
        if (len > bytes.length) {
            len = bytes.length;
        }
        String s = new String(bytes, 0, len, charsetOf(extras)).trim();
        return s.isEmpty() ? null : s;
    }

    private static Charset charsetOf(Bundle extras) {
        String name = extras.getString("charset");
        if (name == null || name.isEmpty()) {
            return StandardCharsets.UTF_8;
        }
        try {
            return Charset.forName(name);
        } catch (Exception e) {
            return StandardCharsets.UTF_8;
        }
    }
}
