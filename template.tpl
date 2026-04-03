___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Heytag PII Flow (Web)",
  "categories": ["CONVERSIONS", "MARKETING", "LEAD_GENERATION"],
  "description": {
    "text": "Securely normalize and hash PII (Email/Phone) for Meta CAPI \u0026 Google Enhanced Conversions. Features: E.164 phone cleaning and SHA-256 hashing to boost match rates and ensure privacy compliance.",
    "translations": [
      {
        "locale": "de",
        "text": "PII (E-Mail/Telefon) sicher normalisieren \u0026 hashen für Meta CAPI \u0026 Google Enhanced Conversions. Inkl. E.164-Bereinigung \u0026 SHA-256 für höhere Match-Rates und DSGVO-konformes Tracking."
      }
    ]
  },
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "inputString",
    "displayName": {
      "text": "Input String",
      "translations": [
        {
          "locale": "de",
          "text": "Eingabewert"
        }
      ]
    },
    "simpleValueType": true,
    "help": {
      "text": "Select the variable containing the raw data (e.g., an email address or phone number).",
      "translations": [
        {
          "locale": "de",
          "text": "Wähle die Variable aus, die die Rohdaten enthält (z. B. eine E-Mail-Adresse oder Telefonnummer)."
        }
      ]
    },
    "alwaysInSummary": true,
    "notSetText": {
      "text": "Please select a variable or enter a value.",
      "translations": [
        {
          "locale": "de",
          "text": "Bitte wählen Sie eine Variable aus oder geben Sie einen Wert ein."
        }
      ]
    }
  },
  {
    "type": "CHECKBOX",
    "name": "lowercase",
    "checkboxText": {
      "text": "Convert to Lowercase",
      "translations": [
        {
          "locale": "de",
          "text": "In Kleinbuchstaben umwandeln"
        }
      ]
    },
    "simpleValueType": true,
    "defaultValue": true,
    "help": {
      "text": "Converts all characters to lowercase. This is a mandatory requirement for valid SHA-256 hashing.",
      "translations": [
        {
          "locale": "de",
          "text": "Wandelt alle Zeichen in Kleinbuchstaben um. Dies ist eine zwingende Voraussetzung für korrektes SHA-256 Hashing (z. B. für Meta CAPI oder Google Enhanced Conversions)."
        }
      ]
    }
  },
  {
    "type": "CHECKBOX",
    "name": "trim",
    "checkboxText": {
      "text": "Trim Whitespace",
      "translations": [
        {
          "locale": "de",
          "text": "Leerzeichen entfernen"
        }
      ]
    },
    "simpleValueType": true,
    "defaultValue": true,
    "help": {
      "text": "Automatically removes leading and trailing spaces to prevent hashing errors caused by accidental user input.",
      "translations": [
        {
          "locale": "de",
          "text": "Entfernt automatisch führende und abschließende Leerzeichen, um Hashing-Fehler durch fehlerhafte Nutzereingaben zu vermeiden."
        }
      ]
    }
  },
  {
    "type": "CHECKBOX",
    "name": "isPhoneNumber",
    "checkboxText": {
      "text": "Is Phone Number",
      "translations": [
        {
          "locale": "de",
          "text": "Ist Telefonnummer"
        }
      ]
    },
    "simpleValueType": true,
    "help": {
      "text": "Enable this if the input is a phone number. This activates the E.164 normalization logic, which removes special characters and fixes country code formats.",
      "translations": [
        {
          "locale": "de",
          "text": "Aktivieren, wenn der Eingabewert eine Telefonnummer ist. Dies aktiviert die E.164-Normalisierungslogik, die Sonderzeichen entfernt und Länderkürzel korrigiert."
        }
      ]
    }
  },
  {
    "type": "TEXT",
    "name": "defaultCountryCode",
    "displayName": {
      "text": "Default Country Code",
      "translations": [
        {
          "locale": "de",
          "text": "Standard-Ländervorwahl"
        }
      ]
    },
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "isPhoneNumber",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "help": {
      "text": "The numerical country prefix (without the \u0027+\u0027) applied if a phone number starts with a single \u00270\u0027 (e.g., \u002749\u0027 for Germany).",
      "translations": [
        {
          "locale": "de",
          "text": "Die numerische Ländervorwahl (ohne \u0027+\u0027), die angewendet wird, wenn eine Telefonnummer mit einer einzelnen \u00270\u0027 beginnt (z. B. \u002749\u0027 für Deutschland)."
        }
      ]
    },
    "defaultValue": 49,
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^\\d{2}$"
        ]
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "enableHashing",
    "checkboxText": {
      "text": "Enable Hashing (SHA-256)",
      "translations": [
        {
          "locale": "de",
          "text": "Hashing aktivieren (SHA-256)"
        }
      ]
    },
    "simpleValueType": true,
    "defaultValue": true,
    "help": {
      "text": "When enabled, the output is a SHA-256 hex string. When disabled, it returns the plain text.",
      "translations": [
        {
          "locale": "de",
          "text": "Wenn aktiviert, wird der Wert als SHA-256-Hash ausgegeben. Wenn deaktiviert, wird der normalisierte Klartext ausgegeben – ideal für die sichere serverseitige Verarbeitung im Heytag-Ökosystem."
        }
      ]
    },
    "alwaysInSummary": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const sha256 = require('sha256');
const getType = require('getType');

let input = data.inputString;

// 1. Grundlegende Typ-Prüfung
if (getType(input) !== 'string') return undefined;

// 2. Trimmen
if (data.trim) {
  input = input.trim();
}

// 3. Telefonnummern-Logik
if (data.isPhoneNumber) {
  var allowedChars = '0123456789+';
  var filtered = '';
  for (var i = 0; i < input.length; i++) {
    if (allowedChars.indexOf(input[i]) !== -1) {
      filtered += input[i];
    }
  }
  input = filtered;

  if (input.indexOf('00') === 0) {
    input = '+' + input.substring(2);
  }

  if (input.indexOf('0') === 0 && input.indexOf('00') !== 0) {
    var cc = data.defaultCountryCode || '49';
    input = '+' + cc + input.substring(1);
  }
  
  if (input.indexOf('+') !== 0 && input.length > 0) {
    input = '+' + input;
  }

  var countryCode = data.defaultCountryCode || '49';
  var prefixWithZero = '+' + countryCode + '0';
  if (input.indexOf(prefixWithZero) === 0) {
    input = '+' + countryCode + input.substring(prefixWithZero.length);
  }
}

// 4. Lowercase
if (data.lowercase) {
  input = input.toLowerCase();
}

// 5. Validitäts-Check
if (!input || input === '+' || input.length < 3) {
  return undefined;
}

// 6. Hashing ODER Klartext-Ausgabe
if (data.enableHashing) {
  return sha256(input, function(digest) {
    return digest;
  }, function(error) {
    return undefined;
  });
}

// Wenn Hashing deaktiviert ist: Klartext zurückgeben
return input;


___TESTS___

scenarios:
- name: Volle Normalisierung (E-Mail)
  code: |-
    let data1 = {
      inputString: '  John.Doe@Example.com  ',
      trim: true,
      lowercase: true,
      isPhoneNumber: false,
      enableHashing: false // Wir testen erst den Klartext-Output
    };
    assertThat(runCode(data1)).isEqualTo('john.doe@example.com');
- name: Nur Kleinschreibung (E-Mail)
  code: |-
    let data2 = {
      inputString: 'John.Doe@Example.com',
      trim: false,
      lowercase: true,
      isPhoneNumber: false,
      enableHashing: false
    };
    assertThat(runCode(data2)).isEqualTo('john.doe@example.com');
- name: Nur Trim
  code: |-
    let data3 = {
      inputString: '  John.Doe@Example.com  ',
      trim: true,
      lowercase: false,
      isPhoneNumber: false,
      enableHashing: false
    };
    assertThat(runCode(data3)).isEqualTo('John.Doe@Example.com');
- name: Schutz vor undefined
  code: |-
    let data5 = {
      inputString: undefined,
      trim: true,
      lowercase: true
    };
    assertThat(runCode(data5)).isUndefined();
- name: Telefonnummer mit führender 0 und Leerzeichen
  code: |-
    let data4 = {
      inputString: ' 0170 1234567 ',
      isPhoneNumber: true,
      trim: true,
      defaultCountryCode: '49',
      enableHashing: false
    };
    assertThat(runCode(data4)).isEqualTo('+491701234567');
- name: Telefonnummer mit +49, Klammern, Leerzeichen, Bindestrichen
  code: |-
    let data5 = {
      inputString: '+49 (170) 123 - 45 67',
      isPhoneNumber: true,
      trim: true,
      enableHashing: false
    };
    assertThat(runCode(data5)).isEqualTo('+491701234567');
- name: Telefonnummer mit 0049, Klammern, Leerzeichen, Bindestrichen
  code: |-
    let data6 = {
      inputString: '0049 (170) 123-4567',
      isPhoneNumber: true,
      trim: true,
      enableHashing: false
    };
    assertThat(runCode(data6)).isEqualTo('+491701234567');
- name: Telefonnummer normalisiert und als Hash
  code: |-
    let data7 = {
      inputString: ' 0170 1234567 ',
      isPhoneNumber: true,
      trim: true,
      defaultCountryCode: '49',
      enableHashing: true
    };
    assertThat(runCode(data7)).isEqualTo(expectedPhoneHash);
- name: E-Mail-Adresse normalisiert als Hash
  code: |-
    let data8 = {
      inputString: '  John.Doe@Example.com  ',
      trim: true,
      lowercase: true,
      isPhoneNumber: false,
      enableHashing: true
    };
    assertThat(runCode(data8)).isEqualTo(expectedEmailHash);
setup: "// --- SETUP ---\nconst expectedEmailHash = '8093933c0429a39775986877477174693a1005a76c026048590c88bc66710712';\n\
  const expectedPhoneHash = '646b97645f06636733f3801280336214376c66d2f3473f324422e1b6f005273d';\n\
  \n// Mocking der sha256 API (Strikte Einhaltung der Callback-Signatur)\nmock('sha256',\
  \ function(str, success, fail) {\n  var result = 'other_hash';\n  if (str === 'john.doe@example.com')\
  \ result = expectedEmailHash;\n  if (str === '+491701234567') result = expectedPhoneHash;\n\
  \  \n  // Die API verlangt, dass wir den Erfolg-Callback mit dem Ergebnis aufrufen\n\
  \  if (typeof success === 'function') {\n    return success(result);\n  }\n  return\
  \ result;\n});"


___NOTES___

Created on 3.4.2026, 20:43:35


