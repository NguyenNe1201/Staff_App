import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
class LanguagesCubit extends Cubit<Locale?> {
  LanguagesCubit() : super(null); // Không cần context trong constructor

  void load(BuildContext context) async {
    Locale locale = Localizations.localeOf(context);
    emit(locale);
  }

  void change(Locale locale) {
    emit(locale);
  }
}