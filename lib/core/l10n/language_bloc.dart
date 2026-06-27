import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_typography.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')) {
    AppTypography.setLocale(state);
  }

  void setLocale(Locale locale) {
    if (['km', 'en'].contains(locale.languageCode)) {
      emit(locale);
    }
  }
}
