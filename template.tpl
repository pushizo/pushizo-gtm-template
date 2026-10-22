___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Pushizo Web Push",
  "categories": ["MARKETING", "PERSONALIZATION"],
  "brand": {
    "id": "brand_pushizo",
    "displayName": "Pushizo"
  },
  "description": "Loads the Pushizo Web SDK, initializes web push for your app and sends custom events, tags or the logged-in user's external ID.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "appId",
    "displayName": "App ID",
    "simpleValueType": true,
    "help": "Pushizo dashboard > Integrations > Google Tag Manager (starts with app_).",
    "valueValidators": [
      { "type": "NON_EMPTY" },
      { "type": "REGEX", "args": ["^app_[A-Za-z0-9]{10,40}$"] }
    ]
  },
  {
    "type": "TEXT",
    "name": "apiUrl",
    "displayName": "API URL",
    "simpleValueType": true,
    "defaultValue": "https://api.pushizo.com",
    "help": "Change only for self-hosted Pushizo; also add the URL to the template's 'Injects scripts' permission.",
    "valueValidators": [
      { "type": "REGEX", "args": ["^https://[^\\s]+$"] }
    ]
  },
  {
    "type": "SELECT",
    "name": "action",
    "displayName": "Action",
    "macrosInSelect": false,
    "selectItems": [
      { "value": "init", "displayValue": "Initialize" },
      { "value": "event", "displayValue": "Send event" },
      { "value": "tags", "displayValue": "Add tags" },
      { "value": "login", "displayValue": "Log in (external ID)" }
    ],
    "simpleValueType": true,
    "defaultValue": "init",
    "help": "Every action loads and initializes the SDK first; fire 'Initialize' on Initialization - All Pages."
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event name",
    "simpleValueType": true,
    "enablingConditions": [{ "paramName": "action", "paramValue": "event", "type": "EQUALS" }],
    "valueValidators": [
      { "type": "NON_EMPTY" },
      { "type": "REGEX", "args": ["^[a-zA-Z0-9_.:-]{1,100}$"] }
    ]
  },
  {
    "type": "TEXT",
    "name": "eventValue",
    "displayName": "Event value (optional number)",
    "simpleValueType": true,
    "enablingConditions": [{ "paramName": "action", "paramValue": "event", "type": "EQUALS" }]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "eventProperties",
    "displayName": "Event properties",
    "simpleTableColumns": [
      { "defaultValue": "", "displayName": "Name", "name": "name", "type": "TEXT" },
      { "defaultValue": "", "displayName": "Value", "name": "value", "type": "TEXT" }
    ],
    "enablingConditions": [{ "paramName": "action", "paramValue": "event", "type": "EQUALS" }]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "tags",
    "displayName": "Tags",
    "simpleTableColumns": [
      { "defaultValue": "", "displayName": "Key", "name": "key", "type": "TEXT" },
      { "defaultValue": "", "displayName": "Value", "name": "value", "type": "TEXT" }
    ],
    "enablingConditions": [{ "paramName": "action", "paramValue": "tags", "type": "EQUALS" }]
  },
  {
    "type": "TEXT",
    "name": "externalId",
    "displayName": "External ID",
    "simpleValueType": true,
    "enablingConditions": [{ "paramName": "action", "paramValue": "login", "type": "EQUALS" }],
    "valueValidators": [{ "type": "NON_EMPTY" }]
  },
  {
    "type": "GROUP",
    "name": "initOptions",
    "displayName": "Initialization options",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "slidedown",
        "checkboxText": "Show the slidedown permission prompt",
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "bell",
        "checkboxText": "Show the subscription bell",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "serviceWorkerPath",
        "displayName": "Service worker path",
        "simpleValueType": true,
        "defaultValue": "/PushizoSDKWorker.js",
        "help": "The worker file must be served from your site root (see Pushizo Web SDK docs)."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Pushizo Web SDK tag: load the SDK with injectScript, call Pushizo.init (idempotent), then run the
// selected action (event, tags, or login).
const injectScript = require('injectScript');
const callInWindow = require('callInWindow');
const makeNumber = require('makeNumber');
const makeTableMap = require('makeTableMap');
const logToConsole = require('logToConsole');

const DEFAULT_API = 'https://api.pushizo.com';
let apiUrl = data.apiUrl || DEFAULT_API;
if (apiUrl.charAt(apiUrl.length - 1) === '/') {
  apiUrl = apiUrl.substring(0, apiUrl.length - 1);
}
const sdkUrl = apiUrl + '/sdk-web/PushizoSDK.js';

const initOptions = {
  appId: data.appId,
  apiUrl: apiUrl,
  serviceWorkerPath: data.serviceWorkerPath || '/PushizoSDKWorker.js',
  serviceWorkerScope: '/'
};
if (data.slidedown) {
  initOptions.slidedown = { enabled: true };
}
if (data.bell) {
  initOptions.bell = { enabled: true };
}

const onLoad = () => {
  callInWindow('Pushizo.init', initOptions);
  if (data.action === 'event') {
    const properties = data.eventProperties ? makeTableMap(data.eventProperties, 'name', 'value') : {};
    const value = data.eventValue ? makeNumber(data.eventValue) : undefined;
    callInWindow('Pushizo.Session.sendEvent', data.eventName, properties, value === value ? value : undefined);
  } else if (data.action === 'tags') {
    if (data.tags) {
      callInWindow('Pushizo.User.addTags', makeTableMap(data.tags, 'key', 'value'));
    }
  } else if (data.action === 'login') {
    callInWindow('Pushizo.login', data.externalId);
  }
  data.gtmOnSuccess();
};

const onFailure = () => {
  logToConsole('Pushizo SDK could not be loaded: ' + sdkUrl);
  data.gtmOnFailure();
};

// cacheToken = sdkUrl: multiple tags on the same page load the SDK only once.
injectScript(sdkUrl, onLoad, onFailure, sdkUrl);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.pushizo.com/sdk-web/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "Pushizo.init" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "Pushizo.Session.sendEvent" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "Pushizo.User.addTags" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "Pushizo.login" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Initialize loads the SDK once and calls Pushizo.init
  code: |-
    mock('injectScript', (url, onSuccess, onFailure, cacheToken) => {
      assertThat(url).isEqualTo('https://api.pushizo.com/sdk-web/PushizoSDK.js');
      assertThat(cacheToken).isEqualTo(url);
      onSuccess();
    });
    runCode({ appId: 'app_01JABCDEFGHJKMNPQRS', apiUrl: 'https://api.pushizo.com/', action: 'init', slidedown: true });
    assertApi('callInWindow').wasCalledWith('Pushizo.init', {
      appId: 'app_01JABCDEFGHJKMNPQRS',
      apiUrl: 'https://api.pushizo.com',
      serviceWorkerPath: '/PushizoSDKWorker.js',
      serviceWorkerScope: '/',
      slidedown: { enabled: true }
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Send event with properties and value
  code: |-
    mock('injectScript', (url, onSuccess) => onSuccess());
    runCode({ appId: 'app_01JABCDEFGHJKMNPQRS', action: 'event', eventName: 'purchase', eventValue: '49.9', eventProperties: [{ name: 'sku', value: 'A1' }] });
    assertApi('callInWindow').wasCalledWith('Pushizo.Session.sendEvent', 'purchase', { sku: 'A1' }, 49.9);
    assertApi('gtmOnSuccess').wasCalled();
- name: Script load failure calls gtmOnFailure
  code: |-
    mock('injectScript', (url, onSuccess, onFailure) => onFailure());
    runCode({ appId: 'app_01JABCDEFGHJKMNPQRS', action: 'init' });
    assertApi('gtmOnFailure').wasCalled();
    assertApi('callInWindow').wasNotCalled();


___NOTES___

Pushizo Web Push template. Documentation: https://docs.pushizo.com/docs/integrations - source and issues: https://github.com/pushizo/pushizo-gtm-template
