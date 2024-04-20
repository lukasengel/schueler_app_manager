import 'package:schueler_app_manager/models/models.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final bool passwordResetNeeded;
  final UserPrivilege privileges;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.passwordResetNeeded,
    required this.privileges,
  });

  factory UserProfile.fromMapEntry(MapEntry<String, dynamic> entry) {
    return UserProfile(
      uid: entry.key,
      displayName: entry.value['displayName'],
      passwordResetNeeded: entry.value['passwordResetNeeded'],
      privileges: UserPrivilege.fromString(entry.value['privileges']),
    );
  }

  MapEntry<String, dynamic> toMapEntry() {
    return MapEntry(uid, {
      'displayName': displayName,
      'passwordResetNeeded': passwordResetNeeded,
      'privileges': privileges.toString(),
    });
  }

  UserProfile copyWith({
    String? displayName,
    bool? passwordResetNeeded,
    UserPrivilege? privileges,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      passwordResetNeeded: passwordResetNeeded ?? this.passwordResetNeeded,
      privileges: privileges ?? this.privileges,
    );
  }
}
