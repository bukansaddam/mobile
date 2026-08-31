import 'dart:io';
import 'dart:ui' as ui;
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void showKtaCardDialog(BuildContext context, UserEntity user) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => KtaCardModal(user: user),
  );
}

class KtaCardModal extends StatefulWidget {
  final UserEntity user;

  const KtaCardModal({super.key, required this.user});

  @override
  State<KtaCardModal> createState() => _KtaCardModalState();
}

class _KtaCardModalState extends State<KtaCardModal> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isDownloading = false;

  Future<void> _downloadKta() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _globalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Render boundary tidak ditemukan.');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Gagal membuat data gambar.');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final Directory directory = await getApplicationDocumentsDirectory();
      final String sanitizeName = (widget.user.name ?? 'Pengguna')
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .replaceAll(' ', '_');
      final String filePath = '${directory.path}/KTA_$sanitizeName.png';

      final File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'KTA Digital berhasil diunduh!\nTersimpan: $filePath',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunduh KTA: ${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final String name = (user.name != null && user.name!.trim().isNotEmpty)
        ? user.name!.trim()
        : 'Pengguna AKAR';
    final String nik = (user.nik != null && user.nik!.trim().isNotEmpty)
        ? user.nik!.trim()
        : '3273000000000000';
    final String phone =
        (user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty)
        ? user.phoneNumber!.trim()
        : '-';
    final String roleTitle = user.isOfficer
        ? 'SATUAN LINMAS'
        : 'WARGA TERDAFTAR';
    final String memberId = 'AKAR-${(user.id.toString()).padLeft(6, '0')}';

    final initialLetter = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.badge_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Kartu Tanda Anggota (KTA)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.grey600),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Printable RepaintBoundary Card
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative background icon element
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        user.isOfficer
                            ? Icons.shield_rounded
                            : Icons.verified_user_rounded,
                        size: 220,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header KTA
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.security_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'AKAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'KARTU TANDA ANGGOTA',
                                    style: TextStyle(
                                      color: Color(0xFFFFD700),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                roleTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(
                          color: Colors.white24,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(height: 14),

                        // Body Profile Info & Photo
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 74,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  user.isOfficer
                                      ? 'assets/indonesian_headshot_portrait.jpg'
                                      : 'assets/indonesian_user_portrait.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.primaryLight,
                                      child: Center(
                                        child: Text(
                                          initialLetter,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  _buildKtaDetailRow('NIK', nik),
                                  _buildKtaDetailRow('ID Anggota', memberId),
                                  _buildKtaDetailRow('No. Telp', phone),
                                  _buildKtaDetailRow(
                                    'Status',
                                    'TERVERIFIKASI ✓',
                                    textColor: const Color(0xFF86EFAC),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Footer with Barcode/QR simulation
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Diterbitkan oleh Sistem AKAR',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'MASA BERLAKU: SEUMUR HIDUP',
                                      style: TextStyle(
                                        color: Color(0xFFFFD700),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.qr_code_2_rounded,
                                      size: 26,
                                      color: AppColors.primaryDark,
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 3,
                                          color: AppColors.primaryDark,
                                        ),
                                        const SizedBox(height: 2),
                                        Container(
                                          width: 16,
                                          height: 3,
                                          color: AppColors.primaryDark,
                                        ),
                                        const SizedBox(height: 2),
                                        Container(
                                          width: 20,
                                          height: 3,
                                          color: AppColors.primaryDark,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Download Action Button
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              // onPressed: _isDownloading ? null : _downloadKta,
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: _isDownloading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : null,
              label: Text(
                _isDownloading ? 'MENGUNDUH KTA...' : 'UNDUH',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKtaDetailRow(
    String label,
    String value, {
    Color textColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
