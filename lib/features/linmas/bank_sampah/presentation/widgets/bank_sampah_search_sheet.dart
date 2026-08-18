import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/bank_sampah_location_entity.dart';
import '../provider/bank_sampah_provider.dart';

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
    return showModalBottomSheet<BankSampahLocationEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
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
      context.read<BankSampahProvider>().updateDistancesWithCurrentLocation(
        silent: true,
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
    final provider = context.watch<BankSampahProvider>();
    final allLocations = provider.locations;

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
                  color: AppColors.grey300,
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
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.recycling_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pilih Bank Sampah',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.grey600),
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
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama bank sampah / lokasi...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.grey500,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            Flexible(
              child:
                  filtered.isEmpty &&
                      (!widget.allowAll || _searchQuery.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_off_rounded,
                            size: 48,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bank Sampah Tidak Ditemukan',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tidak ada bank sampah dengan kata kunci "$_searchQuery"',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
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
                                    ? AppColors.primaryLight
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () => Navigator.pop(
                                    context,
                                    const BankSampahLocationEntity(
                                      id: 'ALL',
                                      nama: 'Semua Lokasi',
                                      alamat:
                                          'Tampilkan laporan dari seluruh lokasi bank sampah',
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isAllSelected
                                            ? AppColors.primary
                                            : AppColors.grey200,
                                        width: isAllSelected ? 1.5 : 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isAllSelected
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.15,
                                                  )
                                                : AppColors.grey100,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_rounded,
                                            color: isAllSelected
                                                ? AppColors.primary
                                                : AppColors.grey600,
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
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Tampilkan laporan dari semua bank sampah terdaftar',
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isAllSelected)
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            final itemIndex = showAllOption ? index - 1 : index;
                            final item = filtered[itemIndex];
                            final isSelected =
                                widget.initialSelected?.id == item.id ||
                                (widget.initialSelected != null &&
                                    widget.initialSelected?.nama == item.nama);

                            return Material(
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : AppColors.white,
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
                                          ? AppColors.primary
                                          : AppColors.grey200,
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
                                                              FontWeight.bold,
                                                          color: AppColors
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
                                                      color: const Color(
                                                        0xFF0284C7,
                                                      ).withValues(alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            const Color(
                                                              0xFF0284C7,
                                                            ).withValues(
                                                              alpha: 0.3,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.near_me_rounded,
                                                          size: 11,
                                                          color: Color(
                                                            0xFF0284C7,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          item.formattedDistance,
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xFF0284C7,
                                                                ),
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
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
  }
}
