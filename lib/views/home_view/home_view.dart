import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/providers/providers.dart';
import 'package:schueler_app_manager/views/editor_view/editor_view.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';

import 'school_life_table.dart';
import 'broadcast_table.dart';
import 'teacher_table.dart';
import 'feedback_table.dart';
import 'administration_table.dart';

class HomeView extends ConsumerStatefulWidget {
  final bool admin;

  const HomeView({
    this.admin = false,
    super.key,
  });

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  var _selectedPage = 0;
  var _unlocked = false;
  var _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _loading = true;
    });

    await executeWithErrorSnackbar(context, function: () async {
      await ref.read(persistenceProvider).loadStandardData();

      if (widget.admin) {
        await ref.read(persistenceProvider).loadAdminData();
      }
    });

    _controller.finishRefresh();

    setState(() {
      _loading = false;
    });
  }

  void _onSettings() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SettingsDialog(),
    );
  }

  Future<void> _onLogout() async {
    await executeWithErrorSnackbar(context, function: () async {
      await ref.read(authenticationProvider).logout();

      if (mounted) {
        context.go("/login");
      }
    });
  }

  Future<void> _onNewOrEditSchoolLifeItem(SchoolLifeItem? initial) async {
    final input = await showDialog<SchoolLifeItem?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditorView(initial),
    );

    if (input != null && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        if (!_unlocked && input.identifier.startsWith("item")) {
          throw AppLocalizations.of(context).translate("readOnlyElement");
        }

        // If the school life item was edited delete the old item and insert the updated one
        if (initial != null) {
          await ref.read(persistenceProvider).deleteSchoolLifeItem(initial);
        }

        await ref.read(persistenceProvider).addSchoolLifeItem(input);
      });
    }

    // Reaload even if the dialog was closed without saving
    // Images might have been added or removed
    _controller.callRefresh();
  }

  Future<void> _onDeleteSchoolLifeItem(SchoolLifeItem schoolLifeItem) async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("confirmDeleteTitle"),
      content: AppLocalizations.of(context).translate("confirmDeleteContent"),
    );

    if (input && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        if (!_unlocked && schoolLifeItem.identifier.startsWith("item")) {
          throw AppLocalizations.of(context).translate("readOnlyElement");
        }

        await ref.read(persistenceProvider).deleteSchoolLifeItem(schoolLifeItem);
      });

      _controller.callRefresh();
    }
  }

  Future<void> _onNewOrEditTeacher(Teacher? initial) async {
    final input = await showDialog<Teacher?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TeacherDialog(initial),
    );

    if (input != null && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        if (!_unlocked && initial?.identifier == "gra") {
          throw AppLocalizations.of(context).translate("readOnlyElement");
        }

        // Check if teacher with same identifier already exists
        if (initial == null &&
            ref.read(persistenceProvider).teachers.any((element) => element.identifier == input.identifier)) {
          throw AppLocalizations.of(context).translate("elementAlreadyExists");
        }

        // If the teacher was edited delete the old teacher and insert the updated one
        if (initial != null) {
          await ref.read(persistenceProvider).deleteTeacher(initial);
        }

        await ref.read(persistenceProvider).addTeacher(input);
      });

      _controller.callRefresh();
    }
  }

  Future<void> _onDeleteTeacher(Teacher teacher) async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("confirmDeleteTitle"),
      content: AppLocalizations.of(context).translate("confirmDeleteContent"),
    );

    if (input && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        if (!_unlocked && teacher.identifier == "gra") {
          throw AppLocalizations.of(context).translate("readOnlyElement");
        }

        await ref.read(persistenceProvider).deleteTeacher(teacher);
      });

      _controller.callRefresh(force: true);
    }
  }

  Future<void> _onNewBroadcast() async {
    final input = await showDialog<Broadcast?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BroadcastDialog(),
    );

    if (input != null && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        await ref.read(persistenceProvider).addBroadcast(input);
      });

      _controller.callRefresh();
    }
  }

  Future<void> _onDeleteBroadcast(Broadcast broadcast) async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("confirmDeleteTitle"),
      content: AppLocalizations.of(context).translate("confirmDeleteContent"),
    );

    if (input && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        await ref.read(persistenceProvider).deleteBroadcast(broadcast);
      });

      _controller.callRefresh();
    }
  }

  Future<void> _onDeleteFeedback(FeedbackItem feedback) async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("confirmDeleteTitle"),
      content: AppLocalizations.of(context).translate("confirmDeleteContent"),
    );

    if (input && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        await ref.read(persistenceProvider).deleteFeedback(feedback);
      });

      _controller.callRefresh();
    }
  }

  Future<void> _onUpdateCredentials(Credentials credentials) async {
    await executeWithErrorSnackbar(context, function: () async {
      await ref.read(persistenceProvider).updateCredentials(credentials);
    });

    _controller.callRefresh();
  }

  Future<void> _onMarkUserForPasswordReset(UserProfile userProfile) async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("confirmResetPasswordTitle"),
      content: AppLocalizations.of(context).translate("confirmResetPasswordContent"),
    );

    if (input && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        await ref.read(persistenceProvider).markUserForPasswordReset(userProfile);
      });

      _controller.callRefresh();
    }
  }

  Future<void> _onDeleteImage((String, String) image) async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("confirmDeleteTitle"),
      content: AppLocalizations.of(context).translate("confirmDeleteContent"),
    );

    if (input && mounted) {
      await executeWithErrorSnackbar(context, function: () async {
        await ref.read(persistenceProvider).deleteImage(image);
      });

      _controller.callRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schüler-App Manager"),
        actions: [
          Text(ref.read(authenticationProvider).currentDisplayName ?? ""),
          IconButton(
            onPressed: _controller.callRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context).translate("refresh"),
          ),
          IconButton(
            onPressed: _onSettings,
            icon: const Icon(Icons.settings_outlined),
            tooltip: AppLocalizations.of(context).translate("settings"),
          ),
          IconButton(
            onPressed: _onLogout,
            icon: const Icon(Icons.logout),
            tooltip: AppLocalizations.of(context).translate("logout"),
          ),
        ],
      ),
      floatingActionButton: [
        FloatingActionButton.extended(
          onPressed: () => _onNewOrEditSchoolLifeItem(null),
          label: Text(AppLocalizations.of(context).translate("newEntry")),
          icon: const Icon(Icons.add),
        ),
        FloatingActionButton.extended(
          onPressed: () => _onNewOrEditTeacher(null),
          label: Text(AppLocalizations.of(context).translate("newTeacher")),
          icon: const Icon(Icons.add),
        ),
        FloatingActionButton.extended(
          onPressed: _onNewBroadcast,
          label: Text(AppLocalizations.of(context).translate("newBroadcast")),
          icon: const Icon(Icons.add),
        ),
        null,
        null,
      ][_selectedPage],
      body: Row(
        children: [
          SizedBox(
            width: 130,
            child: NavigationRail(
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.group_outlined),
                  selectedIcon: const Icon(Icons.group),
                  label: Text(AppLocalizations.of(context).translate("schoolLife")),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.school_outlined),
                  selectedIcon: const Icon(Icons.school),
                  label: Text(AppLocalizations.of(context).translate("teachers")),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.campaign_outlined),
                  selectedIcon: const Icon(Icons.campaign),
                  label: Text(AppLocalizations.of(context).translate("broadcasts")),
                ),
                if (widget.admin)
                  NavigationRailDestination(
                    icon: const Icon(Icons.feedback_outlined),
                    selectedIcon: const Icon(Icons.feedback),
                    label: Text(AppLocalizations.of(context).translate("feedback")),
                  ),
                if (widget.admin)
                  NavigationRailDestination(
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    selectedIcon: const Icon(Icons.admin_panel_settings),
                    label: Text(AppLocalizations.of(context).translate("administration")),
                  ),
              ],
              trailing: widget.admin && _selectedPage < 2
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: IconButton(
                          icon: Icon(_unlocked ? Icons.lock_open : Icons.lock),
                          tooltip: _unlocked
                              ? AppLocalizations.of(context).translate("lock")
                              : AppLocalizations.of(context).translate("unlock"),
                          onPressed: () {
                            setState(() {
                              _unlocked = !_unlocked;
                            });
                          },
                        ),
                      ),
                    )
                  : null,
              selectedIndex: _selectedPage,
              onDestinationSelected: (value) {
                setState(() {
                  _selectedPage = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
                  left: BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                ),
              ),
              child: EasyRefresh.builder(
                controller: _controller,
                onRefresh: _onRefresh,
                refreshOnStart: true,
                header: const MaterialHeader(),
                scrollBehaviorBuilder: (physics) => const MaterialScrollBehavior(),
                childBuilder: (context, physics) {
                  return IgnorePointer(
                    ignoring: _loading,
                    child: [
                      SchoolLifeTable(
                        schoolLifeItems: ref.watch(persistenceProvider.select((value) => value.schoolLifeItems)),
                        onEdit: _onNewOrEditSchoolLifeItem,
                        onDelete: _onDeleteSchoolLifeItem,
                        physics: physics,
                      ),
                      TeacherTable(
                        teachers: ref.watch(persistenceProvider.select((value) => value.teachers)),
                        onEdit: _onNewOrEditTeacher,
                        onDelete: _onDeleteTeacher,
                      ),
                      BroadcastTable(
                        broadcasts: ref.watch(persistenceProvider.select((value) => value.broadcasts)),
                        onDelete: _onDeleteBroadcast,
                      ),
                      FeedbackTable(
                        feedbacks: ref.watch(persistenceProvider.select((value) => value.feedbacks)),
                        onDelete: _onDeleteFeedback,
                      ),
                      AdministrationTable(
                        key: ValueKey(ref.watch(persistenceProvider.select((value) => value.credentials.hashCode))),
                        credentials: ref.watch(persistenceProvider.select((value) => value.credentials)),
                        userProfiles: ref.watch(persistenceProvider.select((value) => value.userProfiles)),
                        allImages: ref.watch(persistenceProvider.select((value) => value.allImages)),
                        referencedImages: ref.watch(persistenceProvider.select((value) => value.referencedImages)),
                        onUpdateCredentials: _onUpdateCredentials,
                        onResetPassword: _onMarkUserForPasswordReset,
                        onDeleteImage: _onDeleteImage,
                      ),
                    ][_selectedPage],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
