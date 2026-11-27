import 'package:material_ui/material_ui.dart';

/// Renderer teks terstruktur ringan (pure Dart) untuk **bold**, *italic*, dan bullet list.
class AiChatFormattedText extends StatelessWidget {
  final String text;
  final TextStyle baseStyle;

  const AiChatFormattedText({
    super.key,
    required this.text,
    required this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    final children = <Widget>[];

    for (var i = 0; i < lines.length; i++) {
      final rawLine = lines[i];
      final trimmed = rawLine.trimLeft();

      final bulletMatch = RegExp(r'^(?:[-*]|(\d+)\.)\s+(.*)$')
          .firstMatch(trimmed);
      if (bulletMatch != null) {
        final marker = bulletMatch.group(1) != null
            ? '${bulletMatch.group(1)}.'
            : '•';
        final body = bulletMatch.group(2) ?? '';
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marker,
                  style: baseStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(children: _parseInline(body, baseStyle)),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (trimmed.isEmpty) {
        children.add(const SizedBox(height: 6));
      } else {
        children.add(
          Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 2, bottom: 2),
            child: Text.rich(
              TextSpan(children: _parseInline(rawLine, baseStyle)),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  List<InlineSpan> _parseInline(String input, TextStyle style) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'(\*\*.+?\*\*|\*[^*\n]+?\*)');
    var cursor = 0;

    for (final match in regex.allMatches(input)) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(text: input.substring(cursor, match.start), style: style),
        );
      }
      final token = match.group(0)!;
      if (token.startsWith('**') && token.endsWith('**') && token.length > 4) {
        spans.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: style.copyWith(fontWeight: FontWeight.w700),
          ),
        );
      } else if (token.startsWith('*') &&
          token.endsWith('*') &&
          token.length > 2) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: style.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else {
        spans.add(TextSpan(text: token, style: style));
      }
      cursor = match.end;
    }

    if (cursor < input.length) {
      spans.add(TextSpan(text: input.substring(cursor), style: style));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: input, style: style));
    }
    return spans;
  }
}
