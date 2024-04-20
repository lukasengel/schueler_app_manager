import 'package:schueler_app_manager/types/types.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

/// Interface definition for an authentication repository.
/// An AuthenticationRepository is responsible for managing user sessions.
///
/// This class is meant to be extended by platform-specific implementations.
abstract class AuthenticationRepository {
  // Define which implementation should be used througout the application
  static AuthenticationRepository get instance {
    return FirebaseAuthenticationRepository.instance;
  }

  /// If logged in, return display name.
  String? get currentDisplayName;

  /// If logged in, return username.
  String? get currentUserId;

  /// Returns true if user is logged in and has administrator privileges.
  bool get isAdministrator;

  /// Log in using username and password and start session.
  ///
  /// Throws [AuthException] upon failure.
  Future<AuthResult> login(String username, String password);

  /// Log out and clear session.
  ///
  /// Throws [AuthException] upon failure.
  Future<void> logout();

  /// Change password of current user.
  ///
  /// Throws [AuthException] upon failure.
  Future<void> changePassword(String newPassword);
}
