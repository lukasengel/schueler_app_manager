import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'web_data.dart';

enum AuthState { LOGGED_IN, LOGGED_OFF }

class Authentication extends GetxController {
  AuthState authState = AuthState.LOGGED_OFF;
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }

  void changeState(User? user) {
    authState = user != null ? AuthState.LOGGED_IN : AuthState.LOGGED_OFF;
    update();
  }

  Future<void> login(String username, String password) async {
    final webData =   Get.put(WebData());
    try {
      if (username.isEmpty || password.isEmpty) {
        throw ("login/errors/empty_credentials".tr);
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.trim() + "@example.com",
        password: password.trim(),
      );
      ever(firebaseUser, changeState);
      await webData.fetchData();
      authState = AuthState.LOGGED_IN;
    } on FirebaseAuthException catch (e) {
      throw(e.message ?? e.toString());
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
