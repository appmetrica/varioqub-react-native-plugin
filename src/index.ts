import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@appmetrica/react-native-varioqub' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const VarioqubNative = NativeModules.Varioqub
  ? NativeModules.Varioqub
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export type OnFetchSuccess = () => void;
export type OnFetchError = (fetchError: FetchError) => void;

export type FetchError =
  | 'EMPTY_RESULT'
  | 'IDENTIFIERS_NULL'
  | 'RESPONSE_PARSE_ERROR'
  | 'REQUEST_THROTTLED'
  | 'NETWORK_ERROR'
  | 'INTERNAL_ERROR'
  | 'UNKNOWN';

export type VarioqubSettings = {
  clientId: string;
  url?: string;
  fetchThrottleIntervalSeconds?: number;
  logs?: boolean;
  activateEvent?: boolean;
  clientFeatures?: Record<string, string>;
};

export default class Varioqub {
  static initVarioqubWithAppMetricaAdapter(settings: VarioqubSettings) {
    VarioqubNative.initVarioqubWithAppMetricaAdapter(settings);
  }

  static fetchConfig(
    onFetchSuccess: OnFetchSuccess,
    onFetchError: OnFetchError
  ) {
    VarioqubNative.fetchConfig((error: String, status: number) => {
      switch (status) {
        case 0: {
          onFetchSuccess();
          break;
        }
        case 1: {
          onFetchError('REQUEST_THROTTLED');
          break;
        }
        case 2: {
          onFetchError(error as FetchError);
          break;
        }
        default: {
          onFetchError('UNKNOWN');
          break;
        }
      }
    });
  }

  static activateConfig() {
    VarioqubNative.activateConfig();
  }

  static async getString(key: string, defaultValue: string): Promise<string> {
    return VarioqubNative.getString(key, defaultValue);
  }

  static async getBoolean(
    key: string,
    defaultValue: boolean
  ): Promise<boolean> {
    return VarioqubNative.getBoolean(key, defaultValue);
  }

  static async getNumber(key: string, defaultValue: number): Promise<number> {
    return VarioqubNative.getNumber(key, defaultValue);
  }

  static async getId(): Promise<string> {
    return VarioqubNative.getId();
  }

  static putClientFeature(key: string, value: string) {
    VarioqubNative.putClientFeature(key, value);
  }

  static clearClientFeatures() {
    VarioqubNative.clearClientFeatures();
  }

  static async getAllKeys(): Promise<Array<string>> {
    return VarioqubNative.getAllKeys();
  }

  static async setDefaults(map: Map<string, any>): Promise<boolean> {
    return VarioqubNative.setDefaults(map);
  }
}
