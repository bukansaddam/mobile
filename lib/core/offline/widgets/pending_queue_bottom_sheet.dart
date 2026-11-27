import 'package:akar/core/di/injection_container.dart' as di;
import 'package:akar/core/offline/offline_queue_item.dart';
import 'package:akar/core/offline/offline_queue_local_datasource.dart';
import 'package:akar/core/offline/offline_sync_coordinator.dart';
import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_dialogs.dart';
import 'package:akar/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:material_ui/material_ui.dart';

class PendingQueueBottomSheet extends StatefulWidget {
  final OfflineQueueLocalDatasource? queueDatasource;
  final OfflineSyncCoordinator? coordinator;
  final String Function()? userIdResolver;

  const PendingQueueBottomSheet({
    super.key,
    this.queueDatasource,
    this.coordinator,
    this.userIdResolver,
  });

  static Future<void> show(
    BuildContext context, {
    OfflineQueueLocalDatasource? queueDatasource,
    OfflineSyncCoordinator? coordinator,
    String Function()? userIdResolver,
  }) {
    final colors = context.appColors;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.78,
        child: PendingQueueBottomSheet(
          queueDatasource: queueDatasource,
          coordinator: coordinator,
          userIdResolver: userIdResolver,
        ),
      ),
    );
  }

  @override
  State<PendingQueueBottomSheet> createState() =>
      _PendingQueueBottomSheetState();
}

class _PendingQueueBottomSheetState extends State<PendingQueueBottomSheet> {
  List<OfflineQueueItem> _items = const [];
  bool _loading = true;

  OfflineQueueLocalDatasource? get _queue =>
      widget.queueDatasource ??
      (di.sl.isRegistered<OfflineQueueLocalDatasource>()
          ? di.sl<OfflineQueueLocalDatasource>()
          : null);

  OfflineSyncCoordinator? get _coordinator =>
      widget.coordinator ??
      (di.sl.isRegistered<OfflineSyncCoordinator>()
          ? di.sl<OfflineSyncCoordinator>()
          : null);

  String _resolveUserId() {
    if (widget.userIdResolver != null) return widget.userIdResolver!();
    if (di.sl.isRegistered<AuthLocalDatasource>()) {
      return di.sl<AuthLocalDatasource>().getCachedUserId() ?? '';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _queue?.revision.addListener(_loadItems);
    _coordinator?.isSyncingNotifier.addListener(_onSyncChanged);
    _loadItems();
  }

  void _onSyncChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadItems() async {
    final queue = _queue;
    if (queue == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final userId = _resolveUserId();
    final items = userId.isNotEmpty
        ? await queue.getPending(userId)
        : <OfflineQueueItem>[];
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _queue?.revision.removeListener(_loadItems);
    _coordinator?.isSyncingNotifier.removeListener(_onSyncChanged);
    super.dispose();
  }

  String _featureLabel(OfflineFeatureType type) {
    switch (type) {
      case OfflineFeatureType.jagaTanah:
        return 'Jaga Tanahku';
      case OfflineFeatureType.complaint:
        return 'Pengaduan';
      case OfflineFeatureType.ronda:
        return 'Ronda Malam';
      case OfflineFeatureType.bankSampah:
        return 'Bank Sampah';
      case OfflineFeatureType.activation:
        return 'Aktivasi';
    }
  }

  String _itemTitle(OfflineQueueItem item) {
    final payload = item.payload;
    final candidates = [
      payload['title'],
      payload['activity_title'],
      payload['waste_type'],
      payload['keterangan'],
    ];
    for (final c in candidates) {
      if (c is String && c.trim().isNotEmpty) return c.trim();
    }
    return _featureLabel(item.featureType);
  }

  (String label, Color bg, Color fg) _statusStyle(
    BuildContext context,
    OfflineQueueItem item,
  ) {
    final colors = context.appColors;
    switch (item.status) {
      case OfflineItemStatus.pending:
        return ('Menunggu Koneksi', colors.primaryLight, colors.primaryDark);
      case OfflineItemStatus.waitingApproval:
        return (
          'Menunggu Persetujuan Seluler',
          colors.warningLight,
          colors.warningDark,
        );
      case OfflineItemStatus.syncing:
        return ('Mengirim...', colors.infoLight, colors.info);
      case OfflineItemStatus.failedRetryable:
        return (
          'Coba Ulang (#${item.retryCount})',
          colors.warningLight,
          colors.warningDark,
        );
      case OfflineItemStatus.failedPermanent:
        return ('Gagal Permanen', colors.errorLight, colors.errorDark);
    }
  }

  Future<void> _confirmDelete(OfflineQueueItem item) async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus Antrean?',
      message: 'Laporan ini akan dihapus permanen dari perangkat dan tidak akan dikirim ke server.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      await _queue?.remove(item.id);
      await _loadItems();
    }
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isSyncing = _coordinator?.isSyncingNotifier.value ?? false;

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.borderStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Antrean Laporan Offline',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (_items.isNotEmpty)
                  TextButton.icon(
                    onPressed: isSyncing ? null : () => _coordinator?.syncNow(),
                    icon: const Icon(Icons.sync_rounded, size: 18),
                    label: const Text('Sinkronkan'),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.divider),
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  )
                : _items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_done_outlined,
                            size: 44,
                            color: colors.success,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada antrean laporan offline.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final (statusLabel, badgeBg, badgeFg) = _statusStyle(
                        context,
                        item,
                      );
                      final totalBytes = item.attachments.fold<int>(
                        0,
                        (sum, a) => sum + a.sizeBytes,
                      );

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: colors.border),
                                  ),
                                  child: Text(
                                    _featureLabel(item.featureType),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    statusLabel,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: badgeFg,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _itemTitle(item),
                              style: AppTextStyles.titleMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.attachments.length} lampiran'
                              '${totalBytes > 0 ? ' • ${_formatBytes(totalBytes)}' : ''}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                            if (item.lastError != null &&
                                item.lastError!.trim().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                item.lastError!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.errorDark,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                if (item.status ==
                                    OfflineItemStatus.waitingApproval)
                                  ElevatedButton(
                                    onPressed: () => _coordinator?.retryItem(
                                      item,
                                      approveCellular: true,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.primary,
                                      foregroundColor: colors.onPrimary,
                                    ),
                                    child: const Text('Setujui & Kirim'),
                                  )
                                else if (item.status !=
                                    OfflineItemStatus.syncing)
                                  OutlinedButton(
                                    onPressed: () =>
                                        _coordinator?.retryItem(item),
                                    child: const Text('Coba Lagi'),
                                  ),
                                IconButton(
                                  tooltip: 'Hapus antrean',
                                  onPressed: () => _confirmDelete(item),
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    color: colors.errorDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
