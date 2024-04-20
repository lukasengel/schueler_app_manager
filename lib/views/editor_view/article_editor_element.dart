import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

/// Represents a single element of an article in the ArticleEditor.
/// Provides editing, deleting and reordering functionality.
///
/// Possible types are: Headline, Subheadline, Paragraph Title, Content and Image.
class ArticleEditorElement extends StatefulWidget {
  final ArticleElement element;
  final Function(ArticleElement, ArticleElementType) onEdit;
  final Function(ArticleElement) onDelete;
  final Function(ArticleElement) onMoveUp;
  final Function(ArticleElement) onMoveDown;

  const ArticleEditorElement({
    required this.element,
    required this.onEdit,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    super.key,
  });

  static const headlineTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const subheadlineTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  State<ArticleEditorElement> createState() => _ArticleEditorElementState();
}

class _ArticleEditorElementState extends State<ArticleEditorElement> {
  var _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 100),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => widget.onEdit(widget.element, widget.element.type),
            onHover: (hovering) => setState(() => _hovering = hovering),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: _hovering ? const Icon(Icons.edit_outlined) : null,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: widget.element is ImageArticleElement
                        ? ArticleEditorImage(widget.element as ImageArticleElement)
                        : Text(
                            widget.element.data,
                            textAlign: TextAlign.justify,
                            style: switch (widget.element.type) {
                              ArticleElementType.HEADER => ArticleEditorElement.headlineTextStyle,
                              ArticleElementType.SUBHEADER => ArticleEditorElement.subheadlineTextStyle,
                              ArticleElementType.CONTENT_HEADER => ArticleEditorElement.boldTextStyle,
                              _ => ArticleEditorElement.textStyle,
                            },
                          ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: _hovering
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              tooltip: AppLocalizations.of(context).translate("moveUp"),
                              icon: const Icon(Icons.arrow_upward),
                              onPressed: () => widget.onMoveUp(widget.element),
                              visualDensity: VisualDensity.compact,
                            ),
                            IconButton(
                              tooltip: AppLocalizations.of(context).translate("moveDown"),
                              icon: const Icon(Icons.arrow_downward),
                              onPressed: () => widget.onMoveDown(widget.element),
                              visualDensity: VisualDensity.compact,
                            ),
                            IconButton(
                              tooltip: AppLocalizations.of(context).translate("delete"),
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Theme.of(context).colorScheme.error,
                              onPressed: () => widget.onDelete(widget.element),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Represents an image element in the ArticleEditor.
/// Displays an image with a description and optional copyright.
/// The copyright notice background can be darkened to improve readability of the description.
///
/// Used in the ArticleEditorElement widget.
class ArticleEditorImage extends StatelessWidget {
  final ImageArticleElement element;

  const ArticleEditorImage(this.element, {super.key});

  static const imageDescriptionStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 400,
            width: 800,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: Theme.of(context).colorScheme.outlineVariant),
                Image.network(
                  element.data,
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
                    return Center(child: Text(AppLocalizations.of(context).translate("invalidImage")));
                  },
                ),
                if (element.imageCopyright != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: element.dark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
                      child: Text(
                        "${AppLocalizations.of(context).translate("imageCopyright")}: ${element.imageCopyright}",
                        maxLines: 1,
                        style: TextStyle(
                          color: element.dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (element.description != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              element.description!,
              style: imageDescriptionStyle,
            ),
          ),
      ],
    );
  }
}
