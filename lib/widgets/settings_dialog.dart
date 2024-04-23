import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/providers/providers.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  void _onChangeThemeMode(int value) async {
    final input = [ThemeMode.light, ThemeMode.system, ThemeMode.dark][value];

    await executeWithErrorSnackbar(context, function: () async {
      await ref.read(settingsProvider).changeThemeMode(input);
    });
  }

  void _onChangeLanguage(Locale locale) async {
    await executeWithErrorSnackbar(context, function: () async {
      await ref.read(settingsProvider).changeLocale(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate("settings"),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(
            AppLocalizations.of(context).translate("close"),
          ),
        ),
      ],
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(builder: (context) {
                final selection = [
                  ref.watch(settingsProvider.select((value) => value.localSettings.themeMode)) == ThemeMode.light,
                  ref.watch(settingsProvider.select((value) => value.localSettings.themeMode)) == ThemeMode.system,
                  ref.watch(settingsProvider.select((value) => value.localSettings.themeMode)) == ThemeMode.dark,
                ];

                return ToggleButtons(
                  borderRadius: BorderRadius.circular(15),
                  isSelected: selection,
                  onPressed: _onChangeThemeMode,
                  children: [
                    Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Icon(selection[0] ? Icons.light_mode : Icons.light_mode_outlined),
                          Text(AppLocalizations.of(context).translate("lightMode")),
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          const Icon(Icons.brightness_6_outlined),
                          Text(AppLocalizations.of(context).translate("systemScheme")),
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Icon(selection[2] ? Icons.dark_mode : Icons.dark_mode_outlined),
                          Text(AppLocalizations.of(context).translate("darkMode")),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            if (ALLOW_LANGUAGE_CHANGE)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: LanguageMenu(
                  onChanged: _onChangeLanguage,
                  locales: AppLocalizations.supportedLocales,
                  localeDisplayNames: AppLocalizations.localeDisplayNames,
                  currentLocale: ref.watch(settingsProvider.select((value) => value.localSettings.locale)),
                  useTextButton: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
