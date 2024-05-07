import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class AdministrationTable extends StatelessWidget {
  final Credentials? credentials;
  final List<(String, String)> allImages;
  final List<UserProfile> userProfiles;
  final List<String> referencedImages;
  final Map<String, bool> functionFlags;
  final Function(Credentials) onUpdateCredentials;
  final Function(UserProfile) onResetPassword;
  final Function((String, String)) onDeleteImage;
  final Function(String, bool) onToggleFunctionFlag;

  const AdministrationTable({
    required this.credentials,
    required this.userProfiles,
    required this.allImages,
    required this.referencedImages,
    required this.functionFlags,
    required this.onUpdateCredentials,
    required this.onResetPassword,
    required this.onDeleteImage,
    required this.onToggleFunctionFlag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CredentialsTile(
          credentials: credentials,
          onUpdateCredentials: onUpdateCredentials,
        ),
        const Divider(height: 0),
        ExpansionTile(
          title: Text(AppLocalizations.of(context).translate("userManagement")),
          initiallyExpanded: true,
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          collapsedShape: const Border(),
          shape: const Border(),
          childrenPadding: const EdgeInsets.only(bottom: 5),
          maintainState: true,
          children: List.generate(userProfiles.length, (index) {
            final userProfile = userProfiles[index];

            return ListTile(
              key: ValueKey(userProfile.uid),
              title: Text(userProfile.displayName),
              subtitle: Text(userProfile.uid),
              trailing: TextButton(
                onPressed: !userProfile.passwordResetNeeded ? () => onResetPassword(userProfile) : null,
                child: Text(AppLocalizations.of(context).translate("resetPassword")),
              ),
            );
          }),
        ),
        const Divider(height: 0),
        ExpansionTile(
          title: Text(AppLocalizations.of(context).translate("cloudFunctions")),
          initiallyExpanded: true,
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          collapsedShape: const Border(),
          shape: const Border(),
          childrenPadding: const EdgeInsets.only(bottom: 5),
          maintainState: true,
          children: List.generate(functionFlags.entries.length, (index) {
            final entry = functionFlags.entries.elementAt(index);

            return SwitchListTile(
              key: ValueKey(entry.key),
              title: Text(entry.key),
              onChanged: (value) => onToggleFunctionFlag(entry.key, value),
              value: entry.value,
            );
          }),
        ),
        const Divider(height: 0),
        ExpansionTile(
          title: Text(AppLocalizations.of(context).translate("imageManagement")),
          initiallyExpanded: true,
          expandedCrossAxisAlignment: CrossAxisAlignment.end,
          expandedAlignment: Alignment.topLeft,
          collapsedShape: const Border(),
          shape: const Border(),
          childrenPadding: const EdgeInsets.all(10),
          maintainState: true,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 10,
              runSpacing: 10,
              children: List.generate(allImages.length, (index) {
                final image = allImages[index];
                final isReferenced = referencedImages.contains(image.$1);

                return Container(
                  key: ValueKey(image.$1),
                  height: 200,
                  width: 200,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        image.$2,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, child, stacktrace) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context).translate("invalidImage"),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: !isReferenced ? () => onDeleteImage(image) : null,
                            tooltip: AppLocalizations.of(context).translate(isReferenced ? "inUse" : "delete"),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.6),
                              disabledBackgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.4),
                              foregroundColor: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}

class CredentialsTile extends StatefulWidget {
  final Credentials? credentials;
  final Function(Credentials) onUpdateCredentials;

  const CredentialsTile({
    required this.credentials,
    required this.onUpdateCredentials,
    super.key,
  });

  @override
  State<CredentialsTile> createState() => _CredentialsTileState();
}

class _CredentialsTileState extends State<CredentialsTile> {
  var _changed = false;
  var _hidePassword = true;
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _loadCredentials();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CredentialsTile oldWidget) {
    _loadCredentials();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadCredentials() {
    _urlController.text = widget.credentials?.url ?? "";
    _usernameController.text = widget.credentials?.username ?? "";
    _passwordController.text = widget.credentials?.password ?? "";
    _onChanged();
  }

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void _onSave() {
    widget.onUpdateCredentials(
      Credentials(
        url: _urlController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  void _onChanged() {
    setState(() {
      _changed = _urlController.text != widget.credentials?.url ||
          _usernameController.text != widget.credentials?.username ||
          _passwordController.text != widget.credentials?.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: ExpansionTile(
        title: Text(AppLocalizations.of(context).translate("credentials")),
        initiallyExpanded: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.end,
        expandedAlignment: Alignment.topCenter,
        collapsedShape: const Border(),
        shape: const Border(),
        childrenPadding: const EdgeInsets.all(10),
        children: [
          TextField(
            controller: _urlController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _onChanged(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate("url"),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _onChanged(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate("username"),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => _onChanged(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate("password"),
              suffixIcon: IconButton(
                icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: _toggleHidePassword,
                focusNode: FocusNode(skipTraversal: true),
              ),
            ),
            obscureText: _hidePassword,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _changed ? _onSave : null,
            child: Text(AppLocalizations.of(context).translate("save")),
          ),
        ],
      ),
    );
  }
}
