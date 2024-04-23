import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/providers/providers.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';

import 'article_editor.dart';

/// Editor for SchoolLifeItems.
/// Supported types: Announcement, Event and Article;
class EditorView extends ConsumerStatefulWidget {
  final SchoolLifeItem? initial;

  const EditorView(this.initial, {super.key});

  @override
  ConsumerState<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends ConsumerState<EditorView> {
  // Form State
  var _uploading = false;
  var _showArticleEditor = false;
  SchoolLifeItemType? _type;

  String? _typeError;
  String? _headlineError;
  String? _contentError;
  String? _imageUrlError;
  String? _eventDateError;

  // SchoolLifeItem Data
  late String _identifier;
  late DateTime _datetime;
  final _headlineController = TextEditingController();
  final _contentController = TextEditingController();
  final _hyperlinkController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _imageCopyrightController = TextEditingController();
  DateTime? _eventTime;
  bool _externalImage = true;
  bool _dark = false;
  List<ArticleElement> _articleElements = [];

  @override
  void initState() {
    // Load initial data
    _identifier = widget.initial?.identifier ?? DateTime.now().hashCode.toString();
    _datetime = widget.initial?.datetime ?? DateTime.now();

    if (widget.initial != null) {
      _type = switch (widget.initial.runtimeType) {
        EventSchoolLifeItem => SchoolLifeItemType.EVENT,
        ArticleSchoolLifeItem => SchoolLifeItemType.ARTICLE,
        _ => SchoolLifeItemType.ANNOUNCEMENT,
      };

      _loadSchoolLifeItem(widget.initial!);

      if (_type == SchoolLifeItemType.EVENT) {
        _loadEventSchoolLifeItem(widget.initial as EventSchoolLifeItem);
      } else if (_type == SchoolLifeItemType.ARTICLE) {
        _loadArticleSchoolLifeItem(widget.initial as ArticleSchoolLifeItem);
      }

      if (widget.initial?.articleElements != null) {
        _articleElements = [...widget.initial!.articleElements!];
      }
    }

    super.initState();
  }

  /// Load the data of a SchoolLifeItem into the editor.
  void _loadSchoolLifeItem(SchoolLifeItem item) {
    _identifier = item.identifier;
    _headlineController.text = item.header;
    _contentController.text = item.content;
    _hyperlinkController.text = item.hyperlink ?? "";
  }

  /// Load the data of an EventSchoolLifeItem into the editor.
  void _loadEventSchoolLifeItem(EventSchoolLifeItem item) {
    _eventTime = item.eventTime;
  }

  /// Load the data of an ArticleSchoolLifeItem into the editor.
  void _loadArticleSchoolLifeItem(ArticleSchoolLifeItem item) {
    _imageUrlController.text = item.imageUrl;
    _imageCopyrightController.text = item.imageCopyright ?? "";
    _externalImage = item.externalImage;
    _dark = item.dark;
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _contentController.dispose();
    _hyperlinkController.dispose();
    _imageUrlController.dispose();
    _imageCopyrightController.dispose();
    super.dispose();
  }

  /// Show a dialog to confirm the cancellation of the editor and close it if confirmed.
  void _onCancel() async {
    final input = await showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context).translate("discardChangesTitle"),
      content: AppLocalizations.of(context).translate("discardChangesContent"),
    );

    if (mounted && input) {
      Navigator.of(context).pop();
    }
  }

  /// Perform input validation and save the SchoolLifeItem if the input is valid.
  void _onSave() {
    if (_validateInput()) {
      final item = switch (_type!) {
        SchoolLifeItemType.ANNOUNCEMENT => SchoolLifeItem(
            identifier: _identifier,
            datetime: _datetime,
            header: _headlineController.text.trim(),
            content: _contentController.text.trim(),
            hyperlink: _hyperlinkController.text.trim().isNotEmpty ? _hyperlinkController.text.trim() : null,
            articleElements: _articleElements.isNotEmpty ? _articleElements : null,
          ),
        SchoolLifeItemType.EVENT => EventSchoolLifeItem(
            identifier: _identifier,
            datetime: _datetime,
            header: _headlineController.text,
            content: _contentController.text,
            hyperlink: _hyperlinkController.text.trim().isNotEmpty ? _hyperlinkController.text.trim() : null,
            articleElements: _articleElements.isNotEmpty ? _articleElements : null,
            eventTime: _eventTime!,
          ),
        SchoolLifeItemType.ARTICLE => ArticleSchoolLifeItem(
            identifier: _identifier,
            datetime: _datetime,
            header: _headlineController.text.trim(),
            content: _contentController.text.trim(),
            hyperlink: _hyperlinkController.text.trim().isNotEmpty ? _hyperlinkController.text.trim() : null,
            articleElements: _articleElements.isNotEmpty ? _articleElements : null,
            imageUrl: _imageUrlController.text.trim(),
            imageCopyright:
                _imageCopyrightController.text.trim().isNotEmpty ? _imageCopyrightController.text.trim() : null,
            externalImage: _externalImage,
            dark: _dark,
          ),
      };

      Navigator.of(context).pop(item);
    }
  }

  /// Validate the input of the editor.
  bool _validateInput() {
    setState(() {
      _typeError = null;
      _headlineError = null;
      _contentError = null;
      _imageUrlError = null;
      _eventDateError = null;

      if (_type == null) {
        _typeError = "requiredField";
      }

      if (_headlineController.text.trim().isEmpty) {
        _headlineError = "requiredField";
      }

      if (_contentController.text.trim().isEmpty) {
        _contentError = "requiredField";
      }

      if (_type == SchoolLifeItemType.EVENT && _eventTime == null) {
        _eventDateError = "requiredField";
      }

      if (_type == SchoolLifeItemType.ARTICLE && _imageUrlController.text.trim().isEmpty) {
        _imageUrlError = "requiredField";
      }
    });

    return _typeError == null &&
        _headlineError == null &&
        _contentError == null &&
        _imageUrlError == null &&
        _eventDateError == null;
  }

  /// Show a date picker to choose a date for the event.
  void _onChooseDate() async {
    final input = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (input != null) {
      setState(() {
        _eventTime = input;
      });
    }
  }

  /// Change the type of the image (external or file).
  void _onChangeImageType(bool? externalImage) {
    if (_imageUrlController.text.isEmpty) {
      setState(() {
        _externalImage = externalImage ?? true;
      });
    }
  }

  /// Change the color scheme of the image copyright.
  void _onChangeColorScheme(bool? dark) {
    setState(() {
      _dark = dark ?? true;
    });
  }

  /// Show a file picker to upload an image and set URL in the image URL input field.
  void _onUploadImage() async {
    await executeWithErrorSnackbar(context, function: () async {
      final selection = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        withData: true,
      );

      if (selection != null && mounted) {
        setState(() {
          _uploading = true;
        });

        final url = await ref.read(persistenceProvider).uploadImage(
              selection.files.single.name,
              _identifier,
              selection.files.single.bytes!,
            );

        _imageUrlController.text = url;
      }
    });

    setState(() {
      _uploading = false;
    });
  }

  /// Clear the image URL input field.
  void _onClearImage() {
    setState(() {
      _imageUrlController.clear();
    });
  }

  /// Show or hide the article editor.
  void _onCreateArticle() {
    setState(() {
      _showArticleEditor = !_showArticleEditor;
    });
  }

  /// Callback for the article editor to update the article elements.
  void _onEditArticle(List<ArticleElement> elements) {
    setState(() {
      _articleElements = elements;
    });
  }

  /// Build an editor element with a label and a child widget.
  Widget _buildEditorElement({
    required String label,
    required Widget child,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: errorText != null ? Theme.of(context).colorScheme.error : null,
                    ),
              ),
              child,
            ],
          ),
          if (errorText != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                errorText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build a radio button group with two options.
  Widget _buildEditorRadio<T>({
    required String label,
    required (String, String) radioLabels,
    required (T, T) values,
    required T groupValue,
    required void Function(T?) onChanged,
  }) {
    return _buildEditorElement(
      label: label,
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Radio(
                  value: values.$1,
                  groupValue: groupValue,
                  onChanged: onChanged,
                ),
                Text(radioLabels.$1),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: values.$2,
                  groupValue: groupValue,
                  onChanged: onChanged,
                ),
                Text(radioLabels.$2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? typeErrorMsg = _typeError != null ? AppLocalizations.of(context).translate(_typeError!) : null;
    String? headlineErrorMsg = _headlineError != null ? AppLocalizations.of(context).translate(_headlineError!) : null;
    String? contentErrorMsg = _contentError != null ? AppLocalizations.of(context).translate(_contentError!) : null;
    String? imageUrlErrorMsg = _imageUrlError != null ? AppLocalizations.of(context).translate(_imageUrlError!) : null;
    String? eventDateErrorMsg =
        _eventDateError != null ? AppLocalizations.of(context).translate(_eventDateError!) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate(
            widget.initial == null ? "newEntry" : "editEntry",
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: AppLocalizations.of(context).translate("cancel"),
          onPressed: !_uploading ? _onCancel : null,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.done),
              tooltip: AppLocalizations.of(context).translate("save"),
              onPressed: !_uploading ? _onSave : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: Card(
                child: FocusTraversalGroup(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _headlineController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).translate("headline"),
                                  errorText: headlineErrorMsg,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            DropdownMenu<SchoolLifeItemType>(
                              initialSelection: _type,
                              label: Text(AppLocalizations.of(context).translate("type")),
                              onSelected: (value) {
                                setState(() {
                                  _type = value;
                                });
                              },
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: SchoolLifeItemType.ANNOUNCEMENT,
                                  label: AppLocalizations.of(context).translate("announcement"),
                                ),
                                DropdownMenuEntry(
                                  value: SchoolLifeItemType.EVENT,
                                  label: AppLocalizations.of(context).translate("event"),
                                ),
                                DropdownMenuEntry(
                                  value: SchoolLifeItemType.ARTICLE,
                                  label: AppLocalizations.of(context).translate("article"),
                                ),
                              ],
                              errorText: typeErrorMsg,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).translate("content"),
                            errorText: contentErrorMsg,
                          ),
                          minLines: 1,
                          maxLines: 10,
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _hyperlinkController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).translate("hyperlink"),
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_type == SchoolLifeItemType.EVENT) ...[
                          _buildEditorElement(
                            label: _eventTime != null
                                ? DateFormat.yMd(Localizations.localeOf(context).toString()).format(_eventTime!)
                                : AppLocalizations.of(context).translate("noDate"),
                            child: TextButton.icon(
                              onPressed: _onChooseDate,
                              icon: const Icon(Icons.calendar_month_outlined),
                              label: Text(AppLocalizations.of(context).translate("chooseDate")),
                            ),
                            errorText: eventDateErrorMsg,
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (_type == SchoolLifeItemType.ARTICLE) ...[
                          _buildEditorRadio<bool>(
                            label: AppLocalizations.of(context).translate("imageType"),
                            radioLabels: (
                              AppLocalizations.of(context).translate("external"),
                              AppLocalizations.of(context).translate("file")
                            ),
                            values: (true, false),
                            groupValue: _externalImage,
                            onChanged: _onChangeImageType,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _imageUrlController,
                                  enabled: _externalImage,
                                  onChanged: (_) => setState(() {}),
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context).translate("imageUrl"),
                                    errorText: imageUrlErrorMsg,
                                    suffixIcon: _imageUrlController.text.isNotEmpty && _externalImage
                                        ? IconButton(
                                            tooltip: AppLocalizations.of(context).translate("clear"),
                                            icon: const Icon(Icons.clear),
                                            onPressed: _onClearImage,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              if (!_externalImage)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: _uploading
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(5),
                                          child: LoadingIndicator(
                                            indicatorType: Indicator.ballSpinFadeLoader,
                                            colors: [Theme.of(context).colorScheme.primary],
                                          ),
                                        )
                                      : TextButton.icon(
                                          onPressed: _imageUrlController.text.isEmpty ? _onUploadImage : _onClearImage,
                                          icon: Icon(_imageUrlController.text.isEmpty ? Icons.upload : Icons.clear),
                                          label: Text(
                                            AppLocalizations.of(context).translate(
                                              _imageUrlController.text.isEmpty ? "uploadImage" : "clearImage",
                                            ),
                                          ),
                                        ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _imageCopyrightController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).translate("imageCopyright"),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildEditorRadio<bool>(
                            label: AppLocalizations.of(context).translate("colorScheme"),
                            radioLabels: (
                              AppLocalizations.of(context).translate("dark"),
                              AppLocalizations.of(context).translate("light")
                            ),
                            values: (true, false),
                            groupValue: _dark,
                            onChanged: _onChangeColorScheme,
                          ),
                          const SizedBox(height: 15),
                        ],
                        _buildEditorElement(
                          label: _articleElements.isNotEmpty
                              ? "${_articleElements.length}${AppLocalizations.of(context).translate("pieceArticle")}"
                              : AppLocalizations.of(context).translate("noArticle"),
                          child: TextButton.icon(
                            onPressed: _onCreateArticle,
                            icon: Icon(
                              _showArticleEditor ? Icons.close : Icons.edit,
                            ),
                            label: Text(
                              AppLocalizations.of(context).translate(_showArticleEditor
                                  ? "closeEditor"
                                  : _articleElements.isNotEmpty
                                      ? "editArticle"
                                      : "createArticle"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showArticleEditor) ...[
            const SizedBox(height: 10),
            Center(
              child: ArticleEditor(
                articleElements: _articleElements,
                onEdited: _onEditArticle,
                leadingImage: _type == SchoolLifeItemType.ARTICLE && _imageUrlController.text.isNotEmpty
                    ? ImageArticleElement(
                        data: _imageUrlController.text.trim(),
                        externalImage: _externalImage,
                        dark: _dark,
                        imageCopyright:
                            _imageCopyrightController.text.trim().isNotEmpty ? _imageCopyrightController.text : null,
                        description:
                            DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString()).format(_datetime),
                      )
                    : null,
                identifier: _identifier,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
