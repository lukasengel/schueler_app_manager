import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/providers/providers.dart';
import 'package:schueler_app_manager/views/views.dart';

import 'init.dart';

// TODO: Testing
// TODO: Cleanup (Code and Lang files)
// TODO: Language

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GoRouter? router;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(settingsProvider.select((value) => value.localSettings.themeMode));
    final locale = ref.watch(settingsProvider.select((value) => value.localSettings.locale));
    AppLogger.instance.d("Rebuilding MaterialApp");

    return MaterialApp.router(
      title: "Schüler-App Manager",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      themeMode: themeMode,
      routerConfig: router ??= GoRouter(
        redirect: (context, state) {
          return ref.read(authenticationProvider).currentUserId != null ? state.path : "/login";
        },
        initialLocation: "/home",
        routes: [
          GoRoute(
            path: "/login",
            builder: (context, state) => const LoginView(),
          ),
          GoRoute(
            path: "/home",
            builder: (context, state) => HomeView(admin: ref.read(authenticationProvider).isAdministrator),
          ),
        ],
      ),
    );
  }
}
