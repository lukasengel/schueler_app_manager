import 'package:flutter/material.dart';

/// Menu to select language.
/// If there are only two languages available, a toggle button is rendered.
/// If there are more than two languages available, a menu is rendered.
class LanguageMenu extends StatelessWidget {
  final List<Locale> locales;
  final Map<String, String> localeDisplayNames;
  final Locale currentLocale;
  final Function(Locale) onChanged;
  final bool useTextButton;

  const LanguageMenu({
    required this.locales,
    required this.onChanged,
    required this.localeDisplayNames,
    required this.currentLocale,
    this.useTextButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // If there are only two languages available, render toggle button
    if (locales.length == 2 && !useTextButton) {
      final other = locales.firstWhere((element) => element != currentLocale);

      return FloatingActionButton.extended(
        onPressed: () => onChanged(other),
        label: Text((localeDisplayNames[other.toString()] ?? other.toString()).toUpperCase()),
        icon: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/${other.languageCode}.png"),
            ),
          ),
        ),
      );
    }

    // If there are more than two languages available, render menu.
    return MenuAnchor(
      builder: (context, controller, child) {
        const icon = Icon(Icons.language);
        const label = Text("LANGUAGE");
        final onPressed = controller.isOpen ? controller.close : controller.open;

        return useTextButton
            ? TextButton.icon(
                onPressed: onPressed,
                icon: icon,
                label: label,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            : FloatingActionButton.extended(
                onPressed: onPressed,
                label: label,
                icon: icon,
              );
      },
      menuChildren: locales.map((element) {
        return MenuItemButton(
          leadingIcon: Ink(
            width: 40,
            height: 35,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/${element.languageCode}.png"),
              ),
            ),
          ),
          onPressed: () => onChanged(element),
          child: Text(localeDisplayNames[element.toString()] ?? element.toString()),
        );
      }).toList(),
    );
  }
}
