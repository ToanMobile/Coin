import 'dart:ui';

import 'package:get/get.dart';
import 'package:wefinex/languages/en_us.dart';
import 'package:wefinex/languages/vi_vn.dart';

class LocalizationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'vi_VN': viVN
  };

  // Default locale
  static final locale = Locale('vi', 'VN');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('vi', 'VN');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'Vietnamese',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}