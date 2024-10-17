package com.varioqub.reactnative;

import android.text.TextUtils;

import com.facebook.react.bridge.ReadableMap;
import com.yandex.varioqub.config.VarioqubSettings;

import java.util.Iterator;
import java.util.Map;

final class MapUtils {

    private MapUtils() {}

    public static VarioqubSettings settingsFromMap(ReadableMap settingsMap) {

        String clientId = settingsMap.getString("clientId");
        if (TextUtils.isEmpty(clientId)) {
            throw new IllegalArgumentException("Client id should not be empty");
        }
        VarioqubSettings.Builder builder = new VarioqubSettings.Builder(clientId);
        if (settingsMap.hasKey("url")) {
            builder.withUrl(settingsMap.getString("url"));
        }
        if (settingsMap.hasKey("fetchThrottleIntervalSeconds")) {
            builder.withThrottleInterval(settingsMap.getInt("fetchThrottleIntervalSeconds"));
        }
        if (settingsMap.hasKey("clientFeatures")) {
            Iterator<Map.Entry<String, Object>> entriesIterator = settingsMap.getMap("clientFeatures").getEntryIterator();

            while (entriesIterator.hasNext()) {
                Map.Entry<String, Object> entry = entriesIterator.next();
                builder.withClientFeature(entry.getKey(), entry.getValue().toString());
            }
        }
        if (settingsMap.hasKey("logs")) {
            builder.withLogs();
        }

        return builder.build();
    }

}
