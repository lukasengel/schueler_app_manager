import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:schueler_app_manager/repositories/repositories.dart';
import 'package:schueler_app_manager/providers/providers.dart';
import 'package:schueler_app_manager/types/types.dart';

final authenticationProvider = ChangeNotifierProvider((ref) => AuthenticationProvider(ref));

class AuthenticationProvider extends ChangeNotifier {
  // Store ref for accessing other providers
  final Ref _ref;
  AuthenticationProvider(this._ref);

  String? _currentDisplayName;
  String? _currentUserId;
  bool _isAdministrator = false;

  String? get currentDisplayName => _currentDisplayName;
  String? get currentUserId => _currentUserId;
  bool get isAdministrator => _isAdministrator;

  /// Attempt to log in using given credentials.
  ///
  /// Make sure to catch possible [AuthException]s.
  Future<AuthResult> login(String username, String password, bool staySignedIn) async {
    final result = await AuthenticationRepository.instance.login(
      username,
      password,
    );

    if (result == AuthResult.SUCCESS && staySignedIn) {
      _ref.read(settingsProvider).updateCredentials(username, password);
    }

    _update();
    return result;
  }

  /// Log out current user. That includes clearing local settings and data.
  ///
  /// Make sure to catch possible [AuthException]s.
  Future<void> logout() async {
    await AuthenticationRepository.instance.logout();
    await _ref.read(settingsProvider).clearLocalSettings();
    _ref.read(persistenceProvider).clearData();
    _update();
  }

  /// Change password of current user.
  ///
  /// Make sure to catch possible [AuthException]s.
  Future<void> changePassword(String newPassword) async {
    await AuthenticationRepository.instance.changePassword(newPassword);

    _update();
  }

  /// Ensure that current user is up-to-date.
  /// Then notify listeners.
  void _update() {
    _currentDisplayName = AuthenticationRepository.instance.currentDisplayName;
    _currentUserId = AuthenticationRepository.instance.currentUserId;
    _isAdministrator = AuthenticationRepository.instance.isAdministrator;
    notifyListeners();
  }
}
