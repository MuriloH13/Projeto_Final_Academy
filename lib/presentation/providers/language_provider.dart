import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const _localeKey = 'locale_code';

  // Default locale
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  final List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('pt'),
    Locale('es'),
  ];

  LanguageProvider() {
    _loadLocale();
  }

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    _saveLocale(newLocale);
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}