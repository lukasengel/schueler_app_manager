import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/providers/providers.dart';
import 'package:schueler_app_manager/types/types.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';

/// Provides a form for the login.
class LoginForm extends ConsumerStatefulWidget {
  final Future<AuthResult> Function(String username, String passwordHash, bool staySignedIn) onLogin;
  final void Function() onSuccessfulLogin;
  final void Function() onPasswordResetNeeded;
  final String? usernameError;
  final String? passwordError;

  const LoginForm({
    required this.onLogin,
    required this.onSuccessfulLogin,
    required this.onPasswordResetNeeded,
    this.usernameError,
    this.passwordError,
    super.key,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var _staySignedIn = true;
  var _hidePassword = true;
  var _working = false;

  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    _usernameError = widget.usernameError;
    _passwordError = widget.passwordError;
    super.initState();
    // Wait until widget is built.
    // Then auto-fill username and password if they are saved in local settings and login.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localSettings = ref.read(settingsProvider).localSettings;

      if (localSettings.username.isNotEmpty && localSettings.password.isNotEmpty) {
        _usernameController.text = localSettings.username;
        _passwordController.text = localSettings.password;
        _login(passwordHash: localSettings.password, staySignedIn: false);
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleStaySignedIn() async {
    setState(() {
      _staySignedIn = !_staySignedIn;
    });
  }

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  /// Callback for login button
  void _login({String? passwordHash, bool? staySignedIn}) async {
    setState(() {
      _working = true;
    });

    if (_validateInput()) {
      await executeWithErrorSnackbar(context, function: () async {
        final result = await widget.onLogin(
          _usernameController.text.trim(),
          passwordHash ?? _passwordController.text.trim(),
          staySignedIn ?? _staySignedIn,
        );

        switch (result) {
          case AuthResult.INVALID_USERNAME:
          case AuthResult.INVALID_PASSWORD:
            if (mounted) {
              showErrorSnackBar(
                context: context,
                error: AppLocalizations.of(context).translate("invalidCredentials"),
              );
            }
            break;
          case AuthResult.PASSWORD_RESET_NEEDED:
            widget.onPasswordResetNeeded();
            break;
          case AuthResult.MISSING_PRIVILEGES:
            if (mounted) {
              showErrorSnackBar(
                context: context,
                error: AppLocalizations.of(context).translate("missingPrivileges"),
              );
            }
            break;
          case AuthResult.SUCCESS:
            widget.onSuccessfulLogin();
            break;
        }
      });
    }

    setState(() {
      _working = false;
    });
  }

  /// Validate user input. In case of invalid input, set error message.
  bool _validateInput() {
    _clearErrors();

    if (_usernameController.text.trim().isEmpty) {
      _usernameError = "requiredField";
    }

    if (_passwordController.text.trim().isEmpty) {
      _passwordError = "requiredField";
    }

    // If all error messages are null, input must be valid, thus return true
    return _usernameError == null && _passwordError == null;
  }

  /// Set all error messages to null.
  void _clearErrors() {
    _usernameError = null;
    _passwordError = null;
  }

  @override
  Widget build(BuildContext context) {
    String? usernameErrorMsg = _usernameError != null ? AppLocalizations.of(context).translate(_usernameError!) : null;
    String? passwordErrorMsg = _passwordError != null ? AppLocalizations.of(context).translate(_passwordError!) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageIcon(
          const AssetImage("assets/images/icon.png"),
          color: Theme.of(context).colorScheme.onBackground,
          size: 120,
        ),
        Text(
          "Schüler-App Manager",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 5),
        Text(AppLocalizations.of(context).translate("loginMessage")),
        const SizedBox(height: 10),
        AutofillGroup(
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.username,
                ],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate("username"),
                  errorText: usernameErrorMsg,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: _hidePassword,
                onSubmitted: (_) => _login(),
                autofillHints: const [
                  AutofillHints.password,
                ],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).translate("password"),
                  suffixIcon: IconButton(
                    icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                    tooltip: AppLocalizations.of(context).translate(_hidePassword ? "showPassword" : "hidePassword"),
                    onPressed: _toggleHidePassword,
                    focusNode: FocusNode(skipTraversal: true),
                  ),
                  errorText: passwordErrorMsg,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    onChanged: (_) => _toggleStaySignedIn(),
                    value: _staySignedIn,
                  ),
                  Text(AppLocalizations.of(context).translate("staySignedIn")),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: FilledButton(
                  onPressed: _login,
                  child: _working
                      ? LoadingIndicator(
                          indicatorType: Indicator.ballPulseSync,
                          colors: [Theme.of(context).colorScheme.onPrimary],
                        )
                      : Text(AppLocalizations.of(context).translate("login")),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Gnadenthal-Gynasium Ingolstadt".toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                letterSpacing: 1,
              ),
        ),
      ],
    );
  }
}
