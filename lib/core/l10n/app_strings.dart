import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('de')];

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ?? AppStrings(const Locale('en'));
  }

  static const _values = <String, Map<String, String>>{
    'en': {
      'home': 'Home',
      'scan': 'Scan',
      'stats': 'Stats',
      'settings': 'Settings',
      'addProduct': 'Add product',
      'expiring': 'Expiring soon',
      'expired': 'Expired',
      'all': 'All',
      'byCategory': 'By category',
      'save': 'Save',
      'scanExpiryDate': 'Scan expiry date',
      'pickDate': 'Pick date',
      'consumed': 'Consumed',
      'wasted': 'Wasted',
    },
    'de': {
      'home': 'Start',
      'scan': 'Scannen',
      'stats': 'Statistik',
      'settings': 'Einstellungen',
      'addProduct': 'Produkt hinzufügen',
      'expiring': 'Läuft bald ab',
      'expired': 'Abgelaufen',
      'all': 'Alle',
      'byCategory': 'Nach Kategorie',
      'save': 'Speichern',
      'scanExpiryDate': 'Ablaufdatum scannen',
      'pickDate': 'Datum wählen',
      'consumed': 'Verbraucht',
      'wasted': 'Verschwendet',
    },
  };

  String t(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}
