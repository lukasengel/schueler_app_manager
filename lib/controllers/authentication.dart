import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/credentials.dart';

import './web_data.dart';

class Authentication extends GetxController {
  late Credentials session;
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
    super.onInit();
  }

  void changeState(User? user) {
    update();
  }

  Future<void> login(String username, String password) async {
    final webData = Get.find<WebData>();
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
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? e);
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      if (firebaseUser.value != null) {
        await firebaseUser.value!.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      throw (e.message ?? e);
    }
  }

  Future<void> signOut() async {
    if (firebaseUser.value != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
