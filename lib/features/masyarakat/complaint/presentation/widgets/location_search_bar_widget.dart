import 'package:flutter/material.dart';
import 'package:akar/core/theme/app_color_scheme.dart';

import 'package:akar/features/masyarakat/complaint/domain/entities/location_suggestion.dart';

class LocationSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSearching;
  final bool isLoadingSuggestions;
  final List<LocationSuggestion> suggestions;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<LocationSuggestion> onSelectSuggestion;
  final VoidCallback onClear;

  const LocationSearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isSearching,
    required this.isLoadingSuggestions,
    required this.suggestions,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSelectSuggestion,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.search,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            style: TextStyle(fontSize: 14.5, color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Cari alamat atau nama jalan...',
              hintStyle: TextStyle(color: colors.textHint, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
              suffixIcon: isSearching || isLoadingSuggestions
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.primary,
                          ),
                        ),
                      ),
                    )
                  : (controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: colors.textMuted,
                            ),
                            onPressed: onClear,
                          )
                        : const SizedBox.shrink()),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 0.8,
                  indent: 16,
                  endIndent: 16,
                  color: colors.divider,
                ),
                itemBuilder: (context, index) {
                  final item = suggestions[index];
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.infoLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 18,
                        color: colors.primary,
                      ),
                    ),
                    title: Text(
                      item.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimary,
                      ),
                    ),
                    onTap: () => onSelectSuggestion(item),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
