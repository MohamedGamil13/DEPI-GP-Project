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

  /// `Forgot Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Reset link sent to your email`
  String get resetLinkSentMessage {
    return Intl.message(
      'Reset link sent to your email',
      name: 'resetLinkSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a link to reset your password and get back to ServiMarket.`
  String get forgotPasswordDescription {
    return Intl.message(
      'Enter your email address and we\'ll send you a link to reset your password and get back to ServiMarket.',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLinkButton {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLinkButton',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the email?`
  String get didNotReceiveEmail {
    return Intl.message(
      'Didn\'t receive the email?',
      name: 'didNotReceiveEmail',
      desc: '',
      args: [],
    );
  }

  /// `Check your spam`
  String get checkSpamText {
    return Intl.message(
      'Check your spam',
      name: 'checkSpamText',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgainText {
    return Intl.message('Try again', name: 'tryAgainText', desc: '', args: []);
  }

  /// `ServiMarket`
  String get watermarkText {
    return Intl.message(
      'ServiMarket',
      name: 'watermarkText',
      desc: '',
      args: [],
    );
  }

  /// `ServiMarket`
  String get appName {
    return Intl.message('ServiMarket', name: 'appName', desc: '', args: []);
  }

  /// `Forgotten Password?`
  String get forgottenPasswordText {
    return Intl.message(
      'Forgotten Password?',
      name: 'forgottenPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signInButton {
    return Intl.message('Sign In', name: 'signInButton', desc: '', args: []);
  }

  /// `OR`
  String get orText {
    return Intl.message('OR', name: 'orText', desc: '', args: []);
  }

  /// `Continue with `
  String get continueWithText {
    return Intl.message(
      'Continue with ',
      name: 'continueWithText',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAccountText {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccountText',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccountTitle {
    return Intl.message(
      'Create Account',
      name: 'createAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Join ServiMarket today and find the best local services.`
  String get createAccountSubtitle {
    return Intl.message(
      'Join ServiMarket today and find the best local services.',
      name: 'createAccountSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullNameLabel {
    return Intl.message('Full Name', name: 'fullNameLabel', desc: '', args: []);
  }

  /// `John Doe`
  String get fullNameHint {
    return Intl.message('John Doe', name: 'fullNameHint', desc: '', args: []);
  }

  /// `Name is required`
  String get nameRequiredError {
    return Intl.message(
      'Name is required',
      name: 'nameRequiredError',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddressLabel {
    return Intl.message(
      'Email Address',
      name: 'emailAddressLabel',
      desc: '',
      args: [],
    );
  }

  /// `john@example.com`
  String get emailHint {
    return Intl.message(
      'john@example.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Create a password`
  String get createPasswordHint {
    return Intl.message(
      'Create a password',
      name: 'createPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpText {
    return Intl.message('Sign Up', name: 'signUpText', desc: '', args: []);
  }

  /// `Already have an account? `
  String get alreadyHaveAccountText {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAccountText',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginText {
    return Intl.message('Login', name: 'loginText', desc: '', args: []);
  }

  /// `OR CONTINUE WITH`
  String get orContinueWithText {
    return Intl.message(
      'OR CONTINUE WITH',
      name: 'orContinueWithText',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get googleText {
    return Intl.message('Google', name: 'googleText', desc: '', args: []);
  }

  /// `By signing up, you agree to our `
  String get termsAgreementText {
    return Intl.message(
      'By signing up, you agree to our ',
      name: 'termsAgreementText',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfServiceText {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfServiceText',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get andText {
    return Intl.message(' and ', name: 'andText', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicyText {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicyText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
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
