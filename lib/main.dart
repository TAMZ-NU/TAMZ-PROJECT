import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/home.dart';
import 'package:tamz/pay.dart';

import 'HelperClasses/languages/my_localization.dart';



void main() async {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  static void setLocale(BuildContext context, Locale locale) {
    _MyHomePageState state =
        context.findAncestorStateOfType<_MyHomePageState>();
    state.setLocale(locale);
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale _locale;

  getInitialLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("isEn") == "en") {
      setState(() {
        _locale = const Locale('en', '');
      });
    } else {
      setState(() {
        _locale = const Locale('ar', '');
      });
    }
  }

  @override
  void initState() {
    getInitialLanguage();
    super.initState();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          MyLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        localeResolutionCallback: (currentLocate, supportedLocates) {
          if (currentLocate != null) {
            for (Locale locale in supportedLocates) {
              if (currentLocate.languageCode == locale.languageCode) {
                return currentLocate;
              }
            }
          }
          return supportedLocates.first;
        },
        home: const Home());
  }
}

