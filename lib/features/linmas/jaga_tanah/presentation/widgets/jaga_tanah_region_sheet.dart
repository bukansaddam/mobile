import 'package:akar/core/errors/failures.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';
import 'package:akar/features/linmas/jaga_tanah/presentation/models/jaga_tanah_region_matcher.dart';
import 'package:material_ui/material_ui.dart';

typedef JagaTanahRegionLoader =
    Future<Either<Failure, List<JagaTanahRegionEntity>>> Function({
      bool forceRefresh,
    });

/// Bottom sheet pemilih wilayah administratif berjenjang dengan pencarian lokal.
class JagaTanahRegionSheet extends StatefulWidget {
  final String title;
  final String searchHint;
  final String? selectedId;
  final JagaTanahRegionLoader loader;
  final ValueChanged<JagaTanahRegionEntity> onSelected;

  const JagaTanahRegionSheet({
    super.key,
    required this.title,
    required this.searchHint,
    this.selectedId,
    required this.loader,
    required this.onSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String searchHint,
    String? selectedId,
    required JagaTanahRegionLoader loader,
    required ValueChanged<JagaTanahRegionEntity> onSelected,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    final colors = context.appColors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => JagaTanahRegionSheet(
        title: title,
        searchHint: searchHint,
        selectedId: selectedId,
        loader: loader,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<JagaTanahRegionSheet> createState() => _JagaTanahRegionSheetState();
}

class _JagaTanahRegionSheetState extends State<JagaTanahRegionSheet> {
  late final TextEditingController _searchController;
  List<JagaTanahRegionEntity> _allItems = const [];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';
  int _requestSeq = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    final seq = ++_requestSeq;
    if (mounted && (!_isLoading || _errorMessage != null)) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    final result = await widget.loader(forceRefresh: forceRefresh);
    if (!mounted || seq != _requestSeq) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (items) {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
          _allItems = items;
        });
      },
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  Widget _buildStatusState(
    AppColorScheme colors, {
    required IconData icon,
    required Color iconColor,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: iconColor),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(120, 44),
                foregroundColor: colors.primaryDark,
                side: BorderSide(color: colors.borderStrong),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(AppColorScheme colors) {
    if (_isLoading) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Memuat daftar...',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildStatusState(
        colors,
        icon: Icons.error_outline_rounded,
        iconColor: colors.error,
        message: _errorMessage!,
        actionLabel: 'Coba Lagi',
        onAction: () => _load(forceRefresh: true),
      );
    }

    if (_allItems.isEmpty) {
      return _buildStatusState(
        colors,
        icon: Icons.location_off_outlined,
        iconColor: colors.textSecondary,
        message: 'Data wilayah belum tersedia.',
        actionLabel: 'Muat Ulang',
        onAction: () => _load(forceRefresh: true),
      );
    }

    final filtered = JagaTanahRegionMatcher.filterByQuery(_allItems, _query);
    if (filtered.isEmpty) {
      final trimmedQuery = _query.trim();
      return _buildStatusState(
        colors,
        icon: Icons.search_off_rounded,
        iconColor: colors.textSecondary,
        message: 'Tidak ditemukan untuk "$trimmedQuery".',
        actionLabel: 'Reset Pencarian',
        onAction: _clearSearch,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final isSelected = item.id == widget.selectedId;

        return ListTile(
          minVerticalPadding: 12,
          title: Text(
            item.name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? colors.primaryDark : colors.textPrimary,
            ),
          ),
          trailing: isSelected
              ? Icon(Icons.check_circle_rounded, color: colors.primaryDark)
              : null,
          tileColor: isSelected
              ? colors.primaryLight.withValues(alpha: 0.45)
              : null,
          onTap: () {
            widget.onSelected(item);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Tutup',
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) => setState(() => _query = value),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colors.textSecondary,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            onPressed: _clearSearch,
                            tooltip: 'Hapus pencarian',
                            constraints: const BoxConstraints(
                              minWidth: 48,
                              minHeight: 48,
                            ),
                            icon: Icon(
                              Icons.close_rounded,
                              color: colors.textSecondary,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: colors.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colors.primaryDark,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 1, color: colors.divider),
              Flexible(child: _buildBody(colors)),
            ],
          ),
        ),
      ),
    );
  }
}
