import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/application/disclaimer_notifier.dart'
    show sharedPreferencesProvider;

const String _themeModeKey = 'theme_mode_v1';

/// `ThemeMode` 영속화. 초기 로딩 동안 `system` 을 디폴트로 노출.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // 비동기 로드는 background 로 진행하면서 일단 system 으로 시작.
    Future.microtask(_load);
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final raw = prefs.getString(_themeModeKey);
    state = _decode(raw);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_themeModeKey, _encode(mode));
  }

  static String _encode(ThemeMode m) => switch (m) {
    ThemeMode.system => 'system',
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
  };

  static ThemeMode _decode(String? raw) => switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
