// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appName => Intl.getCurrentLocale().startsWith('ar') ? 'سيرفي ماركت' : 'ServiMarket';
  String get favorites => Intl.getCurrentLocale().startsWith('ar') ? 'المفضلة' : 'Favorites';
  String get noFavoritesYet => Intl.getCurrentLocale().startsWith('ar') ? 'لا توجد عناصر مفضلة بعد.' : 'No favorites yet.';
  String get allReviews => Intl.getCurrentLocale().startsWith('ar') ? 'كل المراجعات' : 'All Reviews';
  String get noReviewsYet => Intl.getCurrentLocale().startsWith('ar') ? 'لا توجد مراجعات بعد.' : 'No reviews yet.';
  String get seeAll => Intl.getCurrentLocale().startsWith('ar') ? 'عرض الكل' : 'See All';
  String get serviceDescription => Intl.getCurrentLocale().startsWith('ar') ? 'وصف الخدمة' : 'Service Description';
  String get review => Intl.getCurrentLocale().startsWith('ar') ? 'مراجعة' : 'Review';
  String get reviews => Intl.getCurrentLocale().startsWith('ar') ? 'المراجعات' : 'Reviews';
  String get messagePoster => Intl.getCurrentLocale().startsWith('ar') ? 'مراسلة البائع' : 'Message Poster';
  String get submitReview => Intl.getCurrentLocale().startsWith('ar') ? 'إرسال المراجعة' : 'Submit Review';
  String get writeReview => Intl.getCurrentLocale().startsWith('ar') ? 'اكتب مراجعة' : 'Write a Review';
  String get shareExperienceOptional => Intl.getCurrentLocale().startsWith('ar') ? 'شارك تجربتك (اختياري)' : 'Share your experience (optional)';
  String get viewProfile => Intl.getCurrentLocale().startsWith('ar') ? 'عرض الملف الشخصي' : 'View Profile';
  String get ratingSummary => Intl.getCurrentLocale().startsWith('ar') ? 'تقييمات' : 'ratings';
  String get language => Intl.getCurrentLocale().startsWith('ar') ? 'اللغة' : 'Language';
  String get english => Intl.getCurrentLocale().startsWith('ar') ? 'الإنجليزية' : 'English';
  String get arabic => Intl.getCurrentLocale().startsWith('ar') ? 'العربية' : 'Arabic';
  String get signOut => Intl.getCurrentLocale().startsWith('ar') ? 'تسجيل الخروج' : 'Sign Out';
  String get contactDevelopers => Intl.getCurrentLocale().startsWith('ar') ? 'تواصل مع المطورين' : 'Contact Developers';
  String get profile => Intl.getCurrentLocale().startsWith('ar') ? 'الملف الشخصي' : 'Profile';
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
