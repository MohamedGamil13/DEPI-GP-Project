import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:skillbridge/core/utils/constants/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  Future<void> loadLocale() async {
    final box = Hive.box(AppConstants.appSettingsBox);
    final languageCode = box.get(AppConstants.localeKey) as String?;
    if (languageCode == 'ar' || languageCode == 'en') {
      emit(Locale(languageCode ?? 'en'));
    }
  }

  Future<void> setLocale(Locale locale) async {
    final normalized = locale.languageCode == 'ar' ? 'ar' : 'en';
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(AppConstants.localeKey, normalized);
    emit(Locale(normalized));
  }
}
