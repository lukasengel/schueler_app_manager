import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/exceptions/exceptions.dart';
import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';
import 'package:schueler_app_manager/types/types.dart';

/// Implementation of [AuthenticationRepository] using Firebase Authentication.
class FirebaseAuthenticationRepository extends AuthenticationRepository {
  // Make class a singleton
  FirebaseAuthenticationRepository._();
  static final instance = FirebaseAuthenticationRepository._();

  UserProfile? _currentUserProfile;

  @override
  String? get currentDisplayName => _currentUserProfile?.displayName;

  @override
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  bool get isAdministrator => _currentUserProfile?.privileges == UserPrivilege.ADMINISTRATOR;

  @override
  Future<AuthResult> login(String username, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "$username@example.com",
        password: password,
      );

      _currentUserProfile = await FirebasePersistenceRepository.instance.loadUserProfile(currentUserId!);

      if (_currentUserProfile!.passwordResetNeeded) {
        return AuthResult.PASSWORD_RESET_NEEDED;
      }

      if (_currentUserProfile!.privileges.index < 1) {
        await FirebaseAuth.instance.signOut();
        return AuthResult.MISSING_PRIVILEGES;
      }

      return AuthResult.SUCCESS;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
        case "user-not-found":
        case "user-disabled":
          return AuthResult.INVALID_USERNAME;
        case "wrong-password":
        case "invalid-credential":
          return AuthResult.INVALID_PASSWORD;
        default:
          rethrow;
      }
    } catch (e) {
      AppLogger.instance.e("Error while logging in: $e");
      throw AuthException("Error while logging in", e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (currentUserId != null) {
        await FirebaseAuth.instance.signOut();
        _currentUserProfile = null;
      }
    } catch (e) {
      AppLogger.instance.e("Error while logging out: $e");
      throw AuthException("Error while logging out", e);
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      await PersistenceRepository.instance.updateUserProfile(_currentUserProfile!.copyWith(
        passwordResetNeeded: false,
      ));
    } catch (e) {
      AppLogger.instance.e("Error while changing password: $e");
      throw AuthException("Error while changing password", e);
    }
  }
}
