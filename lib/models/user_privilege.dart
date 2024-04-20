enum UserPrivilege {
  APP,
  MANAGER,
  ADMINISTRATOR;

  factory UserPrivilege.fromString(String data) {
    return UserPrivilege.values.byName(data.toUpperCase());
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}
