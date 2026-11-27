import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/bank_sampah/domain/entities/bank_sampah_location_entity.dart';
import 'package:akar/features/linmas/bank_sampah/presentation/bloc/bank_sampah_bloc/bank_sampah_bloc.dart';

class BankSampahSearchSheet extends StatefulWidget {
  final BankSampahLocationEntity? initialSelected;
  final bool allowAll;

  const BankSampahSearchSheet({
    super.key,
    this.initialSelected,
    this.allowAll = false,
  });

  static Future<BankSampahLocationEntity?> show(
    BuildContext context, {
    BankSampahLocationEntity? initialSelected,
    bool allowAll = false,
  }) {
    final colors = context.appColors;
    return showModalBottomSheet<BankSampahLocationEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => BankSampahSearchSheet(
        initialSelected: initialSelected,
        allowAll: allowAll,
      ),
    );
  }

  @override
  State<BankSampahSearchSheet> createState() => _BankSampahSearchSheetState();
}

class _BankSampahSearchSheetState extends State<BankSampahSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BankSampahBloc>().add(
        const UpdateBankSampahUserLocationEvent(silent: true),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankSampahBloc, BankSampahState>(
      builder: (context, state) {
        final colors = context.appColors;
        final allLocations = context.read<BankSampahBloc>().listLocations;

        final filtered = allLocations.where((loc) {
          if (_searchQuery.isEmpty) return true;
          return loc.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              loc.alamat.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              loc.kelurahan.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.borderStrong,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.recycling_rounded,
                          color: colors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pilih Bank Sampah',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: colors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.borderStrong),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari nama bank sampah / lokasi...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textHint,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colors.textMuted,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: colors.textMuted,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Divider(height: 1, color: colors.divider),

                Flexible(
                  child:
                      filtered.isEmpty &&
                          (!widget.allowAll || _searchQuery.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off_rounded,
                                size: 48,
                                color: colors.textHint,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Bank Sampah Tidak Ditemukan',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _searchQuery.isEmpty
                                    ? 'Belum ada bank sampah terdaftar.'
                                    : 'Tidak ada bank sampah dengan kata kunci "$_searchQuery"',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : Builder(
                          builder: (context) {
                            final showAllOption =
                                widget.allowAll && _searchQuery.isEmpty;
                            final totalCount =
                                filtered.length + (showAllOption ? 1 : 0);

                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 12.0,
                              ),
                              itemCount: totalCount,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                if (showAllOption && index == 0) {
                                  final isAllSelected =
                                      widget.initialSelected == null ||
                                      widget.initialSelected?.id == 'ALL';
                                  return Material(
                                    color: isAllSelected
                                        ? colors.primaryLight
                                        : colors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () => Navigator.pop(
                                        context,
                                        const BankSampahLocationEntity(
                                          id: 'ALL',
                                          nama: 'Semua Lokasi',
                                          alamat: 'Tampilkan laporan dari seluruh lokasi bank sampah',
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isAllSelected
                                                ? colors.primary
                                                : colors.border,
                                            width: isAllSelected ? 1.5 : 1.0,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: isAllSelected
                                                    ? colors.primary.withValues(
                                                        alpha: 0.15,
                                                      )
                                                    : colors.surfaceElevated,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.account_balance_rounded,
                                                color: isAllSelected
                                                    ? colors.primary
                                                    : colors.textSecondary,
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Semua Lokasi Bank Sampah',
                                                    style: AppTextStyles
                                                        .bodyMedium
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colors
                                                              .textPrimary,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Tampilkan laporan dari semua bank sampah terdaftar',
                                                    style: AppTextStyles.caption
                                                        .copyWith(
                                                          color: colors
                                                              .textSecondary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (isAllSelected)
                                              Icon(
                                                Icons.check_circle_rounded,
                                                color: colors.primary,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final itemIndex = showAllOption
                                    ? index - 1
                                    : index;
                                final item = filtered[itemIndex];
                                final isSelected =
                                    widget.initialSelected?.id == item.id ||
                                    (widget.initialSelected != null &&
                                        widget.initialSelected?.nama ==
                                            item.nama);

                                return Material(
                                  color: isSelected
                                      ? colors.primaryLight
                                      : colors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context, item),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? colors.primary
                                              : colors.border,
                                          width: isSelected ? 1.5 : 1.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        item.nama,
                                                        style: AppTextStyles
                                                            .bodyLarge
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: colors
                                                                  .textPrimary,
                                                            ),
                                                      ),
                                                    ),
                                                    if (item
                                                        .formattedDistance
                                                        .isNotEmpty) ...[
                                                      const SizedBox(width: 6),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: colors.info
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          border: Border.all(
                                                            color: colors.info
                                                                .withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .near_me_rounded,
                                                              size: 11,
                                                              color:
                                                                  colors.info,
                                                            ),
                                                            const SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              item.formattedDistance,
                                                              style: TextStyle(
                                                                color:
                                                                    colors.info,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.alamat,
                                                  style: AppTextStyles.bodySmall
                                                      .copyWith(
                                                        color: colors
                                                            .textSecondary,
                                                      ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
