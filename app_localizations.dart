import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {'app_title': 'Shorts Challenge', 'record': 'Record', 'streak': 'Streak', 'challenges': 'Challenges'},
    'ar': {'app_title': 'تحدي الشورتس', 'record': 'تصوير', 'streak': 'الحماس اليومي', 'challenges': 'التحديات'},
    'hi': {'app_title': 'المشاهدات القصيرة', 'record': 'تسجيل', 'streak': 'التتابع', 'challenges': 'التحديات'},
    'ku': {'app_title': 'شۆرتس چاڵنج', 'record': 'تۆمارکردن', 'streak': 'بەردەوامی', 'challenges': 'بەرەنگارییەکان'},
    'tr': {'app_title': 'Shorts Challenge', 'record': 'Kaydet', 'streak': 'Seri', 'challenges': 'Meydan Okumalar'},
    'ru': {'app_title': 'Shorts Challenge', 'record': 'Запись', 'streak': 'Серия', 'challenges': 'Челленджи'},
    'zh': {'app_title': '短视频挑战', 'record': '录制', 'streak': '连续', 'challenges': '挑战'},
    'ja': {'app_title': 'ショートチャレンジ', 'record': '録画', 'streak': 'ストリーク', 'challenges': 'チャレンジ'},
    'vi': {'app_title': 'Thử Thách Shorts', 'record': 'Ghi', 'streak': 'Chuỗi', 'challenges': 'Thử thách'},
    'ko': {'app_title': '쇼츠 챌린지', 'record': '녹화', 'streak': '스트릭', 'challenges': '챌린지'},
    'pt': {'app_title': 'Desafio Shorts', 'record': 'Gravai', 'streak': 'Sequência', 'challenges': 'Desafios'},
    'fr': {'app_title': 'Défi Shorts', 'record': 'Enregistrer', 'streak': 'Série', 'challenges': 'Défis'},
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key]!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        'en', 'ar', 'hi', 'ku', 'tr', 'ru', 'zh', 'ja', 'vi', 'ko', 'pt', 'fr'
      ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
