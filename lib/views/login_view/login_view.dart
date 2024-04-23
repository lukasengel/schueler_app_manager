import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:schueler_app_manager/types/types.dart';
import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';
import 'package:schueler_app_manager/providers/providers.dart';

import 'login_form.dart';
import 'reset_password_form.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  var _resetPassword = false;

  /// Callback for language button/menu
  void _changeLocale(Locale locale) async {
    await executeWithErrorSnackbar(context, function: () async {
      await ref.read(settingsProvider).changeLocale(locale);
    });
  }

  /// Callback for login form
  Future<AuthResult> _onLogin(String username, String password, bool staySignedIn) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return await ref.read(authenticationProvider).login(
          username,
          password,
          staySignedIn,
        );
  }

  /// To be called after successful login or password reset
  void _onSuccessfulLogin() {
    context.go("/home");
  }

  /// To be called when password reset is needed
  void _onPasswordResetNeeded() {
    setState(() {
      _resetPassword = true;
    });
  }

  /// To be called after successful password change
  void _onSuccessfulPasswordChange() async {
    showSnackBar(
      context: context,
      content: Text(
        AppLocalizations.of(context).translate("passwordChangeSuccess"),
      ),
    );

    await ref.read(authenticationProvider).logout();

    setState(() {
      _resetPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.read(settingsProvider.select((value) => value.localSettings.locale));

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: ALLOW_LANGUAGE_CHANGE
          ? LanguageMenu(
              onChanged: _changeLocale,
              locales: AppLocalizations.supportedLocales,
              localeDisplayNames: AppLocalizations.localeDisplayNames,
              currentLocale: locale,
            )
          : null,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 600,
            minWidth: 400,
            maxWidth: 500,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            boxShadow: const [
              BoxShadow(offset: Offset(0.1, 0.1), blurRadius: 2.0),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: _resetPassword
              ? ResetPasswordForm(
                  onChangePassword: ref.read(authenticationProvider).changePassword,
                  onSucessfulPasswordChange: _onSuccessfulPasswordChange,
                )
              : LoginForm(
                  onLogin: _onLogin,
                  onSuccessfulLogin: _onSuccessfulLogin,
                  onPasswordResetNeeded: _onPasswordResetNeeded,
                ),
        ),
      ),
    );
  }
}
