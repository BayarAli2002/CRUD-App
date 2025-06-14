class Language {
  static const String englishLocale = 'en';
  static const String arabicLocale = 'ar';
  static const String kurdishLocale = 'fa';
  static const String defaultLanguage = 'en';

  /*
  It automatically generates Dart code to help you
  work with translations in your Flutter app using the easy_localization package,
  but without specifying the output filename or format.
  */
  //dart run easy_localization:generate -S assets/languages -O lib/translations

  //this command is used to generate the code for translations with help of easy_localization package
  //flutter pub run easy_localization:generate -h

  //is used to automatically generate a Dart file containing constants (keys) for your translations using the
  //dart run easy_localization:generate -S assets/languages -O lib/translations -o "local_keys.g.dart" -f keys
}