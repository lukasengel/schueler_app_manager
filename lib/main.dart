import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './pages/login_page/login_page.dart';
import './pages/home_page/home_page.dart';
import './controllers/authentication.dart';

import './firebase_options.dart';
import './translations.dart';
import './theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions.fromMap(firebaseOptions),
  );
  //TODO: Remove auto-login
  //TODO: Password change
  //TODO: Schulleben
  //TODO: Rundnachrichten-Tab
  //TODO: Leere Page Daten in Benachrichtigung
  await Get.put(Authentication()).login("bass", "JustusStinkt");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Schüler-App Manager",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: const Locale("de", "DE"),
      translationsKeys: translationKeys,
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: ()=>  LoginPage()),
        GetPage(name: "/home", page: ()=> const HomePage()),
      ],
    );
  }
}
