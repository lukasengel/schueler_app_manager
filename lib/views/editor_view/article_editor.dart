import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/widgets/widgets.dart';

import 'article_editor_element.dart';

/// Simple editor for articles added to a SchoolLifeItem.
///
/// Allows to add, edit, delete and reorder article elements.
/// Possible elements are: Headline, Subheadline, Paragraph Title, Content and Image.
///
/// [onEdited] expects the parent widget to rebuild.
class ArticleEditor extends StatefulWidget {
  final List<ArticleElement> articleElements;
  final ImageArticleElement? leadingImage;
  final Function(List<ArticleElement>) onEdited;
  final String identifier;

  const ArticleEditor({
    required this.articleElements,
    required this.onEdited,
    required this.identifier,
    this.leadingImage,
    super.key,
  });

  @override
  State<ArticleEditor> createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
  final _focusNode = FocusNode();
  List<ArticleElement> _articleElements = [];
  final List<List<ArticleElement>> _editHistory = [];

  @override
  void initState() {
    _articleElements = [...widget.articleElements];
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Opens a dialog to create or edit an article element.
  void _onNewOrEditElement(ArticleElement? initial, ArticleElementType type) async {
    final input = await showDialog<ArticleElement?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return type == ArticleElementType.IMAGE
            ? ImageArticleElementDialog(
                initial: initial as ImageArticleElement?,
                identifier: widget.identifier,
              )
            : ArticleElementDialog(
                initial: initial,
                type: type,
              );
      },
    );

    if (input != null) {
      _editHistory.add([..._articleElements]);

      if (initial == null) {
        _articleElements.add(input);
      } else {
        final index = _articleElements.indexOf(initial);
        _articleElements[index] = input;
      }

      widget.onEdited(_articleElements);
    }
  }

  /// Deletes the given [element] from the current list of article elements.
  void _onDeleteElement(ArticleElement element) {
    _editHistory.add([..._articleElements]);
    _articleElements.remove(element);
    widget.onEdited(_articleElements);
  }

  /// Moves the given [element] one position up in the list of article elements.
  void _onMoveUp(ArticleElement element) {
    final index = _articleElements.indexOf(element);
    if (index > 0) {
      _editHistory.add([..._articleElements]);

      final previousElement = _articleElements[index - 1];
      _articleElements[index - 1] = element;
      _articleElements[index] = previousElement;
      widget.onEdited(_articleElements);
    }
  }

  /// Moves the given [element] one position down in the list of article elements.
  void _onMoveDown(ArticleElement element) {
    final index = _articleElements.indexOf(element);
    if (index < _articleElements.length - 1) {
      _editHistory.add([..._articleElements]);

      final nextElement = _articleElements[index + 1];
      _articleElements[index + 1] = element;
      _articleElements[index] = nextElement;
      widget.onEdited(_articleElements);
    }
  }

  /// Undoes the last action.
  void _undo() {
    _articleElements = _editHistory.removeLast();
    widget.onEdited(_articleElements);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1200,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _editHistory.isNotEmpty ? _undo : null,
                    icon: const Icon(Icons.undo),
                    tooltip: AppLocalizations.of(context).translate("undo"),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: () => _onNewOrEditElement(null, ArticleElementType.HEADER),
                        child: Text(
                          AppLocalizations.of(context).translate("headline"),
                          style: ArticleEditorElement.headlineTextStyle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      MaterialButton(
                        onPressed: () => _onNewOrEditElement(null, ArticleElementType.SUBHEADER),
                        child: Text(
                          AppLocalizations.of(context).translate("subheadline"),
                          style: ArticleEditorElement.subheadlineTextStyle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      MaterialButton(
                        onPressed: () => _onNewOrEditElement(null, ArticleElementType.CONTENT_HEADER),
                        child: Text(
                          AppLocalizations.of(context).translate("contentHeader"),
                          style: ArticleEditorElement.boldTextStyle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      MaterialButton(
                        onPressed: () => _onNewOrEditElement(null, ArticleElementType.CONTENT),
                        child: Text(
                          AppLocalizations.of(context).translate("content"),
                          style: ArticleEditorElement.textStyle,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _onNewOrEditElement(null, ArticleElementType.IMAGE),
                    icon: const Icon(Icons.image_outlined),
                    tooltip: AppLocalizations.of(context).translate("image"),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Card.outlined(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: _articleElements.isEmpty
                        ? Text(AppLocalizations.of(context).translate("noContent"))
                        : ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 1100,
                            ),
                            child: Column(
                              children: [
                                if (widget.leadingImage != null)
                                  Row(
                                    children: [
                                      const SizedBox(width: 150),
                                      Expanded(
                                        child: ArticleEditorImage(widget.leadingImage!),
                                      ),
                                      const SizedBox(width: 150),
                                    ],
                                  ),
                                ..._articleElements
                                    .map((e) => ArticleEditorElement(
                                          element: e,
                                          onEdit: _onNewOrEditElement,
                                          onDelete: _onDeleteElement,
                                          onMoveDown: _onMoveDown,
                                          onMoveUp: _onMoveUp,
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
