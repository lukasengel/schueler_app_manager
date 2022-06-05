import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import './pages/login_page/login_page.dart';

import './bindings.dart';
import './firebase_options.dart';
import './translations.dart';
import './theme.dart';

//TODO: Image Upload improved

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions.fromMap(firebaseOptions),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      popGesture: false,
      defaultTransition: Transition.fade,
      debugShowCheckedModeBanner: false,
      title: "Schüler-App Manager",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      locale: const Locale("de", "DE"),
      translationsKeys: translationKeys,
      home: const LoginPage(),
    );
  }
}
