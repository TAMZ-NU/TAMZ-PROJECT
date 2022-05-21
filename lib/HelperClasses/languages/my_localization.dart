import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalization {
  final Locale locale;

  MyLocalization(this.locale);

  static MyLocalization of(BuildContext context) {
    return Localizations.of<MyLocalization>(context, MyLocalization);
  }

  Map<String, String> _localizedValues;

  Future load() async {
    String jasonStringValues = await rootBundle
        .loadString('assets/languages/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = jsonDecode(jasonStringValues);

    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<MyLocalization> delegate =
      _DemoLocalizationDelegate();
}

class _DemoLocalizationDelegate extends LocalizationsDelegate<MyLocalization> {
  const _DemoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<MyLocalization> load(Locale locale) async {
    MyLocalization localization = new MyLocalization(locale);

    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_DemoLocalizationDelegate old) => false;
}
