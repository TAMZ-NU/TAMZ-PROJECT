import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'languages.dart';

class Utils {
  static Future<void> changeLanguages(Languages language, context) async {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, '');
        break;
      case 'ar':
        _temp = Locale(language.languageCode, '');
        break;
    }
    MyHomePage.setLocale(context, _temp);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("isEn", language.languageCode);
  }
}
