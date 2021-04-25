package com.ammarahmed.rnadmob.nativeads;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeArray;
import com.facebook.react.bridge.WritableMap;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.RequestConfiguration;
import com.google.android.gms.ads.initialization.AdapterStatus;
import com.google.android.gms.ads.initialization.InitializationStatus;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class RNAdmobNativeAdsManager extends ReactContextBaseJavaModule {
    public ReactApplicationContext mContext;
    public RNAdmobNativeAdsManager(ReactApplicationContext context) {
        super(context);
        mContext = context;
    }

    @NonNull
    @Override
    public String getName() {
        return "RNAdmobNativeAdsManager";
    }

    @ReactMethod
    public void setRequestConfiguration(ReadableMap config, Promise promise) {
        RequestConfiguration.Builder configuration = new RequestConfiguration.Builder();

        if (config.hasKey("maxAdContentRating")) {
            if (config.getString("maxAdContentRating") != null) {
                String maxAdContentRating = config.getString("maxAdContentRating");
                if (maxAdContentRating != null) {
                    if (maxAdContentRating.equals("UNSPECIFIED"))
                        maxAdContentRating = "";
                    configuration.setMaxAdContentRating(maxAdContentRating);
                }
            }
        }

        if (config.hasKey("tagForChildDirectedTreatment")) {
            boolean tagForChildDirectedTreatment = config.getBoolean("tagForChildDirectedTreatment");
            configuration.setTagForChildDirectedTreatment(tagForChildDirectedTreatment ? 1 : 0);
        }
        if (config.hasKey("tagForUnderAgeOfConsent")) {
            boolean tagForUnderAgeOfConsent = config.getBoolean("tagForUnderAgeOfConsent");
            configuration.setTagForUnderAgeOfConsent(tagForUnderAgeOfConsent ? 1 : 0);
        }
        if (config.hasKey("testDeviceIds")) {
            ReadableNativeArray nativeArray = (ReadableNativeArray) config.getArray("testDeviceIds");
            if (nativeArray != null) {
                ArrayList<Object> list = nativeArray.toArrayList();
                List<String> testDeviceIds = new ArrayList<>(list.size());
                for (Object object : list) {
                    testDeviceIds.add(object != null ? object.toString() : null);
                }
                configuration.setTestDeviceIds(testDeviceIds);
            }
        }

        MobileAds.setRequestConfiguration(configuration.build());
        MobileAds.initialize(getReactApplicationContext(), (InitializationStatus status) -> {
            WritableMap map = Arguments.createMap();
            for (Map.Entry<String, AdapterStatus> entry: status.getAdapterStatusMap().entrySet()) {
                map.putString(entry.getKey(), entry.getValue().getInitializationState().toString());
            }
            promise.resolve(map);
        });
    }

    @ReactMethod
    public void isTestDevice(Promise promise) {
        AdRequest builder = new AdRequest.Builder().build();
        promise.resolve(builder.isTestDevice(getReactApplicationContext()));
    }

    @ReactMethod
    public void registerRepository(ReadableMap config, Promise promise){
        WritableMap result = CacheManager.instance.registerRepo(mContext, config);
        if (result.hasKey("success") && result.getBoolean("success")){
            CacheManager.instance.requestAds(result.getString("repo"));
        }
        promise.resolve(result);
    }

    @ReactMethod
    public void unRegisterRepository(String id){
        CacheManager.instance.unRegisterRepo(id);
    }

    @ReactMethod
    public void resetCache(){
        CacheManager.instance.resetCache();
    }

    @ReactMethod
    public void hasAd(String repo, Promise promise) {
        promise.resolve(CacheManager.instance.hasAd(repo));
    }

}
