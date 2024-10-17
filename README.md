# @appmetrica/react-native-varioqub

React Native plugin for [Varioqub](https://varioqub.ru) for Android and iOS platforms

## Installation

```sh
npm install @appmetrica/react-native-varioqub
```

## Usage
```js
import Varioqub from '@appmetrica/react-native-varioqub';

// init varioqub
Varioqub.initVarioqubWithAppMetricaAdapter({
  clientId: '<YOUR_CLIENT_ID>',
});

// fetch config with flags
Varioqub.fetchConfig(
  () => {
    // activate config with flags
    Varioqub.activateConfig();
  },
  () => {
    console.log('Something went wrong');
  },
);

// use flags from config
Varioqub.getString("key", "default_value")

```
