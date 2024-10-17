import Foundation
import Varioqub
import MetricaAdapterReflection

@objc(RNVarioqub)
class RNVarioqub: NSObject {
    
    @objc(initVarioqubWithAppMetricaAdapter:)
    func initVarioqubWithAppMetricaAdapter(_ settingsDict: NSDictionary) {
        let clientId = settingsDict["clientId"] as! String
        let vqConfig = getVarioqubConfigFromDict(dict: settingsDict)
        
        let adapter = AppmetricaAdapter()
        
        VarioqubFacade.shared.initialize(clientId: clientId, config: vqConfig, idProvider: adapter, reporter: adapter)
    }
    
    @objc
    func fetchConfig(_ callback: @escaping RCTResponseSenderBlock) {
        
        let varioqub = VarioqubFacade.shared
        
        varioqub.fetchConfig({ status in
            switch status {
            case .success, .cached: callback([NSNull(), 0])
            case .throttled: callback([NSNull(), 1])
            case .error(let e):
                switch e {
                case .emptyResult: callback(["EMPTY_RESULT", 2])
                case .nullIdentifiers: callback(["IDENTIFIERS_NULL", 2])
                case .request: callback(["INTERNAL_ERROR", 2])
                case .response(_): callback(["NETWORK_ERROR", 2])
                case .parse(_): callback(["RESPONSE_PARSE_ERROR", 2])
                case .network(_): callback(["NETWORK_ERROR", 2])
                case .underlying(_): callback(["INTERNAL_ERROR", 2])
                @unknown default:
                    callback(["UNKNOWN", 2])
                }
            @unknown default:
                callback(["UNKNOWN", 2])
            }
        })
        
    }
    
    @objc(activateConfig)
    func activateConfig() {
        VarioqubFacade.shared.activateConfigAndWait()
    }
    
    @objc(getNumber:defaultValue:resolver:rejecter:)
    func getNumber(key: String, defaultValue: Double, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(VarioqubFacade.shared.getDouble(for: VarioqubFlag(rawValue: key), defaultValue: defaultValue))
    }
    
    @objc(getBoolean:defaultValue:resolver:rejecter:)
    func getBoolean(key: String, defaultValue: Bool, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(VarioqubFacade.shared.getBool(for: VarioqubFlag(rawValue: key), defaultValue: defaultValue))
    }
    
    @objc(getString:defaultValue:resolver:rejecter:)
    func getString(key: String, defaultValue: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(VarioqubFacade.shared.getString(for: VarioqubFlag(rawValue: key), defaultValue: defaultValue))
    }
    
    @objc(putClientFeature:value:)
    func putClientFeature(_ key: String, value: String) {
        VarioqubFacade.shared.clientFeatures.setFeature(value, forKey: key)
    }
    
    @objc(clearClientFeatures)
    func clearClientFeatures() {
        VarioqubFacade.shared.clientFeatures.clearFeatures()
    }
    
    @objc(getAllKeys:rejecter:)
    func getAllKeys(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(Array(VarioqubFacade.shared.allKeys.map({"\($0.rawValue)"})) as NSArray)
    }
    
    @objc(getId:rejecter:)
    func getId(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        resolve(VarioqubFacade.shared.varioqubId ?? "")
    }
    
    @objc(setDefaults:resolver:rejecter:)
    func setDefaults(_ defaultsMap: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        
        var defaultFlagsMap = [Varioqub.VarioqubFlag : String]()
        
        for (key, value) in defaultsMap {
            defaultFlagsMap[VarioqubFlag(rawValue: key as! String)] = String(describing: value)
        }
        
        VarioqubFacade.shared.setDefaults(defaultFlagsMap, callback: {
            resolve(true)
        })
    }
    
    private func getVarioqubConfigFromDict(dict: NSDictionary) -> VarioqubConfig {
        var vqConfig = VarioqubConfig.default
        
        let features = ClientFeatures(dictionary: dict["clientFeatures"] as? [String: String] ?? [:])

        if let url = dict["url"] as? String {
            vqConfig.baseURL = URL(string: url)
        }
        vqConfig.initialClientFeatures = features
        vqConfig.fetchThrottle = dict["fetchThrottleIntervalSeconds"] as? TimeInterval
        
        return vqConfig
    }
}
