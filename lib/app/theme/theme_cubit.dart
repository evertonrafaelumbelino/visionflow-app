import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themePrefKey = 'visionflow_theme_mode';

/// Cubit para gerenciar o modo de tema (claro/escuro/sistema)
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themePrefKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      emit(ThemeMode.values[index]);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, mode.index);
  }
}

class ThemeState extends Equatable {
  const ThemeState(this.mode);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}
