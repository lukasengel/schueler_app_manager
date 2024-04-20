import 'package:flutter/material.dart';

class LocalSettings {
  final Locale locale;
  final ThemeMode themeMode;
  final String username;
  final String password;

  LocalSettings({
    required this.locale,
    required this.themeMode,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      "locale": [locale.languageCode, locale.countryCode],
      "themeMode": themeMode.name,
      "username": username,
      "password": password,
    };
  }

  factory LocalSettings.fromMap(Map<String, dynamic> map) {
    return LocalSettings(
      locale: Locale(map["locale"][0], map["locale"][1]),
      themeMode: ThemeMode.values.firstWhere((element) => element.name == map["themeMode"]),
      username: map["username"],
      password: map["password"],
    );
  }

  LocalSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    String? username,
    String? password,
  }) {
    return LocalSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
