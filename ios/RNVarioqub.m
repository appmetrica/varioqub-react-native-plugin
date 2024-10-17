#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE(Varioqub, RNVarioqub, NSObject)

RCT_EXTERN_METHOD(initVarioqubWithAppMetricaAdapter:(NSDictionary *) settingsDict)

RCT_EXTERN_METHOD(fetchConfig:(RCTResponseSenderBlock *) callback)

RCT_EXTERN_METHOD(activateConfig)

RCT_EXTERN_METHOD(getNumber:(NSString *) key
                  defaultValue:(double) defaultValue
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(getBoolean:(NSString *) key
                  defaultValue:(BOOL) defaultValue
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(getString:(NSString *) key
                  defaultValue:(NSString *) defaultValue
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(putClientFeature:(NSString *) key
                  value:(NSString*) value)

RCT_EXTERN_METHOD(clearClientFeatures)

RCT_EXTERN_METHOD(getAllKeys:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(getId:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(setDefaults:(NSDictionary *) defaultsMap
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)

@end
