import 'dart:ui';

typedef void LocaleChangeCallback(Locale locale);

class AppManager {
  // List of supported languages
  final List<String> supportedLanguages = [
    'en',
    'fr',
    'de',
    'es',
    'ja',
    'ko',
    'zh',
    'HK',
    'TW',
    'hk',
    'tw',
    'zh_hk',
    'zh_tw'
  ];

  // Returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // Function to be invoked when changing the working language
  LocaleChangeCallback onLocaleChanged;

  ///
  /// Internals
  ///
  static final AppManager _applic = new AppManager._internal();

  factory AppManager() {
    return _applic;
  }

  AppManager._internal();
}

AppManager appManager = new AppManager();
