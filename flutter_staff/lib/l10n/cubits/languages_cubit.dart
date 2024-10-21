import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
class LanguagesCubit extends Cubit<Locale?>{
  LanguagesCubit(this.context) : super(null){
    load(context);
  }
  final BuildContext context;
  void load(BuildContext context) async {
    Locale locale = Localizations.localeOf(context);
    emit(locale);
  }
  void change(Locale locale){
    emit(locale);
  }
}