import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';

class ResetPasswordForm extends StatefulWidget {
  final Future<void> Function(String) onChangePassword;
  final Function() onSucessfulPasswordChange;

  const ResetPasswordForm({
    required this.onChangePassword,
    required this.onSucessfulPasswordChange,
    super.key,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  var _hidePassword = true;
  var _working = false;

  String? _passwordError;
  String? _cpasswordError;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  /// Callback for "change password" button
  void _changePassword() async {
    setState(() {
      _working = true;
    });

    // Check if input is valid, i.e. the passwords match and are not empty
    if (_validateInput()) {
      await executeWithErrorSnackbar(context, function: () async {
        await widget.onChangePassword(_passwordController.text.trim());

        widget.onSucessfulPasswordChange();
      });
    }

    setState(() {
      _working = false;
    });
  }

  /// Validate user input. In case of invalid input, set error message.
  bool _validateInput() {
    _clearErrors();

    if (_passwordController.text.trim().isEmpty) {
      _passwordError = "requiredField";
    }

    if (_cpasswordController.text.trim().isEmpty) {
      _cpasswordError = "requiredField";
    } else if (_passwordController.text.trim() != _cpasswordController.text.trim()) {
      _cpasswordError = "passwordsDoNotMatch";
    } else if (_passwordController.text.trim().length < 6) {
      _passwordError = "passwordTooShort";
    }

    // If all error messages are null, input must be valid, thus return true
    return _passwordError == null && _cpasswordError == null;
  }

  /// Set all error messages to null.
  void _clearErrors() {
    _passwordError = null;
    _cpasswordError = null;
  }

  /// Toggle the visibility of the password
  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? passwordErrorMsg = _passwordError != null ? AppLocalizations.of(context).translate(_passwordError!) : null;
    String? cpasswordErrorMsg =
        _cpasswordError != null ? AppLocalizations.of(context).translate(_cpasswordError!) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context).translate("passwordReset"),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(AppLocalizations.of(context).translate("chooseNewPassword")),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: _hidePassword,
          onEditingComplete: FocusScope.of(context).nextFocus,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate("newPassword"),
            suffixIcon: IconButton(
              icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
              tooltip: AppLocalizations.of(context).translate(_hidePassword ? "showPassword" : "hidePassword"),
              onPressed: _toggleHidePassword,
              focusNode: FocusNode(skipTraversal: true),
            ),
            border: const OutlineInputBorder(),
            errorText: passwordErrorMsg,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _cpasswordController,
          onSubmitted: (_) => _changePassword(),
          obscureText: _hidePassword,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate("confirmPassword"),
            suffixIcon: IconButton(
              icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
              tooltip: AppLocalizations.of(context).translate(_hidePassword ? "showPassword" : "hidePassword"),
              onPressed: _toggleHidePassword,
              focusNode: FocusNode(skipTraversal: true),
            ),
            border: const OutlineInputBorder(),
            errorText: cpasswordErrorMsg,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 45,
          width: double.infinity,
          child: FilledButton(
            onPressed: _changePassword,
            child: _working
                ? LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: [Theme.of(context).colorScheme.onPrimary],
                  )
                : Text(AppLocalizations.of(context).translate("confirm")),
          ),
        )
      ],
    );
  }
}
