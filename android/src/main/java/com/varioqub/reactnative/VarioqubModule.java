package com.varioqub.reactnative;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.module.annotations.ReactModule;
import com.yandex.varioqub.appmetricaadapter.AppMetricaAdapter;
import com.yandex.varioqub.config.FetchError;
import com.yandex.varioqub.config.OnFetchCompleteListener;
import com.yandex.varioqub.config.Varioqub;

@ReactModule(name = VarioqubModule.NAME)
public class VarioqubModule extends ReactContextBaseJavaModule {
    public static final String NAME = "Varioqub";
    public static final String TAG = "VarioqubReactNative";

    private static final int FETCH_REQUEST_SUCCESS = 0;
    private static final int FETCH_REQUEST_THROTTLED = 1;
    private static final int FETCH_REQUEST_ERROR = 2;

    public VarioqubModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void initVarioqubWithAppMetricaAdapter(@NonNull ReadableMap settingsMap) {
        try {
            Varioqub.init(MapUtils.settingsFromMap(settingsMap), new AppMetricaAdapter(getActivity()), getActivity());
        } catch (Exception e) {
            Log.e(TAG, "Something went wrong while parsing Varioqub Settings", e);
        }
    }

    @ReactMethod
    public void fetchConfig(@NonNull Callback callback) {
        Varioqub.fetchConfig(new OnFetchCompleteListener() {
            @Override
            public void onSuccess() {
                callback.invoke(null, FETCH_REQUEST_SUCCESS);
            }

            @Override
            public void onError(@NonNull String s, @NonNull FetchError fetchError) {
                switch (fetchError) {
                    case REQUEST_THROTTLED -> callback.invoke(null, FETCH_REQUEST_THROTTLED);
                    case EMPTY_RESULT,
                         IDENTIFIERS_NULL,
                         RESPONSE_PARSE_ERROR,
                         NETWORK_ERROR,
                         INTERNAL_ERROR -> callback.invoke(fetchError.toString(), FETCH_REQUEST_ERROR);
                    default -> Log.e(TAG, "Unknown fetch error: " + fetchError);
                }
            }
        });
    }

    @ReactMethod
    public void activateConfig() {
        Varioqub.activateConfig(null);
    }

    @ReactMethod
    public void setDefaults(@NonNull ReadableMap defaultsMap, Promise promise) {
        Varioqub.setDefaults(defaultsMap.toHashMap());
        promise.resolve(true);
    }

    @ReactMethod
    public void getString(@NonNull String key, @NonNull String defaultValue, Promise promise) {
        promise.resolve(Varioqub.getString(key, defaultValue));
    }

    @ReactMethod
    public void getNumber(@NonNull String key, double defaultValue, Promise promise) {
        promise.resolve(Varioqub.getDouble(key, defaultValue));
    }

    @ReactMethod
    public void getBoolean(@NonNull String key, boolean defaultValue, Promise promise) {
        promise.resolve(Varioqub.getBoolean(key, defaultValue));
    }

    @ReactMethod
    public void getId(Promise promise) {
        promise.resolve(Varioqub.getId());
    }

    @ReactMethod
    public void putClientFeature(@NonNull String key, @NonNull String value) {
        Varioqub.putClientFeature(key, value);
    }

    @ReactMethod
    public void clearClientFeatures() {
        Varioqub.clearClientFeatures();
    }

    @ReactMethod
    public void getAllKeys(Promise promise) {
        WritableArray reactNativeKeysArray = Arguments.createArray();
        for (String key : Varioqub.getAllKeys()) {
            reactNativeKeysArray.pushString(key);
        }
        promise.resolve(reactNativeKeysArray);
    }

    private Activity getActivity() {
        return getCurrentActivity();
    }

}
