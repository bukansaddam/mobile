import 'dart:io';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/utils/file_security_utils.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/fullscreen_image_viewer.dart';
import 'package:akar/core/widgets/fullscreen_video_viewer.dart';
import 'package:akar/features/linmas/activation/domain/entities/activation_activity.dart';
import 'package:akar/features/linmas/activation/presentation/bloc/activation_bloc/activation_bloc.dart';
import 'package:akar/features/linmas/activation/presentation/pages/camera_capture_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddReportBottomSheet extends StatefulWidget {
  final ActivationActivity activity;
  final String initialAttachmentPath;

  const AddReportBottomSheet({
    super.key,
    required this.activity,
    required this.initialAttachmentPath,
  });

  static void show(
    BuildContext context, {
    required ActivationActivity activity,
    required String initialAttachmentPath,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReportBottomSheet(
        activity: activity,
        initialAttachmentPath: initialAttachmentPath,
      ),
    );
  }

  @override
  State<AddReportBottomSheet> createState() => _AddReportBottomSheetState();
}

class _AddReportBottomSheetState extends State<AddReportBottomSheet> {
  static const int _maxAttachments = 5;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late List<String> _attachments;
  bool _isSubmitting = false;

  bool get _hasVideo => _attachments.any(FileSecurityUtils.isVideoPath);

  @override
  void initState() {
    super.initState();
    _attachments = [widget.initialAttachmentPath];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    if (_attachments.length >= _maxAttachments) {
      _showMessage('Maksimal $_maxAttachments lampiran per laporan.');
      return;
    }

    final newPhoto = await CameraCaptureScreen.open(context);
    if (newPhoto != null && mounted) {
      setState(() {
        _attachments.add(newPhoto);
      });
    }
  }

  Future<void> _addVideo() async {
    if (_attachments.length >= _maxAttachments) {
      _showMessage('Maksimal $_maxAttachments lampiran per laporan.');
      return;
    }
    if (_attachments.any(FileSecurityUtils.isVideoPath)) {
      _showMessage('Maksimal 1 video per laporan.');
      return;
    }

    final newVideo = await CameraCaptureScreen.openVideo(context);
    if (newVideo != null && mounted) {
      setState(() {
        _attachments.add(newVideo);
      });
    }
  }

  void _removeAttachment(int index) {
    if (_attachments.length <= 1) {
      _showMessage('Laporan wajib menyertakan minimal 1 lampiran.');
      return;
    }

    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) return;
    if (_attachments.isEmpty) return;

    setState(() => _isSubmitting = true);

    final isDoorToDoor =
        widget.activity.category == ActivationCategory.doorToDoor;

    context.read<ActivationBloc>().add(
      SubmitActivationReportApiEvent(
        participantId: widget.activity.id,
        activityTitle: widget.activity.title,
        attachments: _attachments.map(File.new).toList(),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        receiverNik: isDoorToDoor ? _nikController.text.trim() : null,
        receiverName: isDoorToDoor ? _nameController.text.trim() : null,
        onSuccess: () {
          if (mounted) {
            final colors = context.appColors;
            setState(() => _isSubmitting = false);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Penyerahan laporan berhasil disimpan!',
                  style: TextStyle(color: colors.onPrimary),
                ),
                backgroundColor: colors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onQueued: () {
          if (mounted) {
            final colors = context.appColors;
            setState(() => _isSubmitting = false);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Tidak ada koneksi. Laporan disimpan dan akan dikirim '
                  'otomatis saat internet tersedia.',
                  style: TextStyle(
                    color: colors.isDark
                        ? colors.onSecondary
                        : colors.textPrimary,
                  ),
                ),
                backgroundColor: colors.warning,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onError: (message) {
          if (mounted) {
            final colors = context.appColors;
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: TextStyle(color: colors.onErrorSolid),
                ),
                backgroundColor: colors.errorSolid,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAttachmentTile(String pathOrUrl, int index) {
    final colors = context.appColors;
    const videoOverlayBg = Color(0xFF1E293B); // media-overlay
    const videoOverlayFg = Color(0xFFFFFFFF); // media-overlay
    final isVideo = FileSecurityUtils.isVideoPath(pathOrUrl);

    Widget preview;
    if (isVideo) {
      preview = Container(
        width: 100,
        height: 100,
        color: videoOverlayBg,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_fill_rounded,
              color: videoOverlayFg,
              size: 36,
            ),
            SizedBox(height: 4),
            Text(
              'Video',
              style: TextStyle(color: videoOverlayFg, fontSize: 11),
            ),
          ],
        ),
      );
    } else if (pathOrUrl.startsWith('http://') ||
        pathOrUrl.startsWith('https://')) {
      preview = AppNetworkImage(
        imageUrl: pathOrUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorIcon: Icons.broken_image_rounded,
        backgroundColor: colors.border,
      );
    } else {
      preview = Image.file(
        File(pathOrUrl),
        width: 100,
        height: 100,
        cacheWidth: 300,
        cacheHeight: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 100,
          height: 100,
          color: colors.border,
          child: Icon(Icons.broken_image_rounded, color: colors.textMuted),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isVideo)
            GestureDetector(
              onTap: () => FullscreenVideoViewer.show(
                context,
                pathOrUrl: pathOrUrl,
                title: 'Video Bukti',
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: preview,
              ),
            )
          else
            GestureDetector(
              onTap: () {
                FullscreenImageViewer.show(
                  context,
                  imagePathOrUrl: pathOrUrl,
                  title: 'Foto Bukti ${index + 1}',
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: preview,
              ),
            ),
          if (_attachments.length > 1)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () => _removeAttachment(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.errorSolid,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: colors.onErrorSolid,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.primary, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDoorToDoor =
        widget.activity.category == ActivationCategory.doorToDoor;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Laporan Bukti Penyerahan',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Divider(height: 16, color: colors.divider),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Foto / Video Bukti Kegiatan',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _attachments.length >= _maxAttachments
                            ? colors.warning.withValues(alpha: 0.15)
                            : colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_attachments.length}/$_maxAttachments Lampiran',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _attachments.length >= _maxAttachments
                              ? colors.warning
                              : colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 108,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _attachments.length +
                        (_attachments.length < _maxAttachments
                            ? _hasVideo
                                  ? 1
                                  : 2
                            : 0),
                    itemBuilder: (context, idx) {
                      if (idx < _attachments.length) {
                        return _buildAttachmentTile(_attachments[idx], idx);
                      }
                      if (idx == _attachments.length) {
                        return _buildAddTile(
                          icon: Icons.add_a_photo_rounded,
                          label: '+ Foto',
                          onTap: _addPhoto,
                        );
                      }
                      return _buildAddTile(
                        icon: Icons.videocam_rounded,
                        label: '+ Video',
                        onTap: _addVideo,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (isDoorToDoor) ...[
                  _buildMandatoryLabel('Nama Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    style: TextStyle(color: colors.textPrimary),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nama penerima wajib diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama penerima...',
                      hintStyle: TextStyle(color: colors.textMuted),
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: colors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildMandatoryLabel('NIK Penerima'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nikController,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: colors.textPrimary),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'NIK penerima wajib diisi';
                      }
                      if (val.trim().length < 16) {
                        return 'NIK harus terdiri dari 16 digit';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan 16 digit NIK...',
                      hintStyle: TextStyle(color: colors.textMuted),
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: colors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Text(
                  'Catatan',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesController,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  maxLines: 2,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan laporan (opsional)...',
                    hintStyle: TextStyle(color: colors.textMuted),
                    prefixIcon: Icon(
                      Icons.note_alt_outlined,
                      color: colors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitReport,
                    icon: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: colors.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    label: Text(
                      _isSubmitting ? 'Mengirim...' : 'Kirim',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMandatoryLabel(String label) {
    final colors = context.appColors;
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(color: colors.error, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
