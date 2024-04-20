import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';
import 'package:schueler_app_manager/providers/providers.dart';

class ArticleElementDialog extends ConsumerStatefulWidget {
  final ArticleElement? initial;
  final ArticleElementType type;

  const ArticleElementDialog({
    required this.initial,
    required this.type,
    super.key,
  });

  @override
  ConsumerState<ArticleElementDialog> createState() => _ArticleElementDialogState();
}

class _ArticleElementDialogState extends ConsumerState<ArticleElementDialog> {
  final _dataController = TextEditingController();
  var _valid = false;

  @override
  void initState() {
    if (widget.initial != null) {
      _dataController.text = widget.initial!.data;
      _validate();
    }

    super.initState();
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  /// Validate the input and enable/disable the save button
  void _validate() {
    setState(() {
      _valid = _dataController.text.trim().isNotEmpty;
    });
  }

  /// Close the dialog and return the edited or new element
  void _onSave() {
    final result = ArticleElement(
      type: widget.type,
      data: _dataController.text.trim(),
    );

    Navigator.of(context).pop(result);
  }

  /// Close the dialog without saving
  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate(widget.initial == null ? "newElement" : "editElement"),
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          child: Text(
            AppLocalizations.of(context).translate("cancel"),
          ),
        ),
        FilledButton(
          onPressed: _valid ? _onSave : null,
          child: Text(
            AppLocalizations.of(context).translate("save"),
          ),
        ),
      ],
      content: Container(
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 600,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dataController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("content"),
                    ),
                    minLines: 1,
                    maxLines: widget.type == ArticleElementType.CONTENT ? 10 : 1,
                    onChanged: (input) => _validate(),
                    onSubmitted: (input) => _valid ? _onSave() : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageArticleElementDialog extends ConsumerStatefulWidget {
  final ImageArticleElement? initial;
  final String identifier;

  const ImageArticleElementDialog({
    required this.initial,
    required this.identifier,
    super.key,
  });

  @override
  ConsumerState<ImageArticleElementDialog> createState() => _ImageArticleElementDialogState();
}

class _ImageArticleElementDialogState extends ConsumerState<ImageArticleElementDialog> {
  // Data
  final _imageUrlController = TextEditingController();
  final _imageCopyrightController = TextEditingController();
  final _imageDescriptionController = TextEditingController();
  var _externalImage = true;
  var _dark = false;

  // State
  var _valid = false;
  var _uploading = false;

  @override
  void initState() {
    if (widget.initial != null) {
      _imageUrlController.text = widget.initial!.data;
      _imageDescriptionController.text = widget.initial!.description ?? "";
      _imageCopyrightController.text = widget.initial!.imageCopyright ?? "";
      _externalImage = widget.initial!.externalImage;
      _dark = widget.initial!.dark;
      _validate();
    }

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageDescriptionController.dispose();
    _imageCopyrightController.dispose();
    super.dispose();
  }

  /// Validate the input and enable/disable the save button
  void _validate() {
    setState(() {
      _valid = _imageUrlController.text.trim().isNotEmpty;
    });
  }

  /// Close the dialog and return the edited or new element
  void _onSave() {
    final result = ImageArticleElement(
      data: _imageUrlController.text.trim(),
      externalImage: _externalImage,
      description: _imageDescriptionController.text.trim().isNotEmpty ? _imageDescriptionController.text.trim() : null,
      imageCopyright: _imageCopyrightController.text.trim().isNotEmpty ? _imageCopyrightController.text.trim() : null,
      dark: _dark,
    );

    Navigator.of(context).pop(result);
  }

  /// Close the dialog without saving
  void _onCancel() {
    Navigator.of(context).pop();
  }

  /// Change the image type between external and file
  void _onChangeImageType(bool? externalImage) {
    // Only change the state if the image URL is empty
    if (_imageUrlController.text.isEmpty) {
      setState(() {
        _externalImage = externalImage ?? true;
      });
    }
  }

  /// Change the color scheme between light and dark
  void _onChangeColorScheme(bool? dark) {
    setState(() {
      _dark = dark ?? true;
    });
  }

  /// Upload an image from the file system and set the URL
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
              widget.identifier,
              selection.files.single.bytes!,
            );

        _imageUrlController.text = url;
      }
    });

    setState(() {
      _uploading = false;
    });

    _validate();
  }

  /// Clear the image URL
  void _onClearImage() {
    setState(() {
      _imageUrlController.clear();
    });

    _validate();
  }

  Widget _buildEditorRadio<T>({
    required String label,
    required (String, String) radioLabels,
    required (T, T) values,
    required T groupValue,
    required void Function(T?) onChanged,
  }) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(label),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: values.$1,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              Text(radioLabels.$1),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: values.$2,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              Text(radioLabels.$2),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate(widget.initial == null ? "newElement" : "editElement"),
      ),
      actions: [
        TextButton(
          onPressed: !_uploading ? _onCancel : null,
          child: Text(
            AppLocalizations.of(context).translate("cancel"),
          ),
        ),
        FilledButton(
          onPressed: _valid && !_uploading ? _onSave : null,
          child: Text(
            AppLocalizations.of(context).translate("save"),
          ),
        ),
      ],
      content: Container(
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 600,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditorRadio(
              label: AppLocalizations.of(context).translate("imageType"),
              radioLabels: (
                AppLocalizations.of(context).translate("external"),
                AppLocalizations.of(context).translate("file"),
              ),
              values: (true, false),
              groupValue: _externalImage,
              onChanged: _onChangeImageType,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).translate("imageUrl"),
                      suffixIcon: _imageUrlController.text.isNotEmpty && _externalImage
                          ? IconButton(
                              tooltip: AppLocalizations.of(context).translate("clear"),
                              icon: const Icon(Icons.clear),
                              onPressed: _onClearImage,
                            )
                          : null,
                    ),
                    enabled: _externalImage,
                    onChanged: (input) => _validate(),
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
                              indicatorType: Indicator.ballPulseSync,
                              colors: [Theme.of(context).colorScheme.primary],
                            ),
                          )
                        : IconButton(
                            onPressed: _imageUrlController.text.isEmpty ? _onUploadImage : _onClearImage,
                            icon: Icon(_imageUrlController.text.isEmpty ? Icons.upload : Icons.clear),
                            tooltip: AppLocalizations.of(context).translate(
                              _imageUrlController.text.isEmpty ? "uploadImage" : "clearImage",
                            ),
                          ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageCopyrightController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate("imageCopyright"),
              ),
            ),
            const SizedBox(height: 10),
            _buildEditorRadio(
              label: AppLocalizations.of(context).translate("colorScheme"),
              radioLabels: (
                AppLocalizations.of(context).translate("light"),
                AppLocalizations.of(context).translate("dark"),
              ),
              values: (false, true),
              groupValue: _dark,
              onChanged: _onChangeColorScheme,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageDescriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate("imageDescription"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
