import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../provider/ronda_provider.dart';

class RondaScreen extends StatefulWidget {
  const RondaScreen({super.key});

  @override
  State<RondaScreen> createState() => _RondaScreenState();
}

class _RondaScreenState extends State<RondaScreen> {
  final TextEditingController _keteranganController = TextEditingController();

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RondaProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey300),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            title: const Text(
              'Form Laporan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------ Section 1: Keamanan ------------------
                _buildSectionHeader('Keamanan'),
                const SizedBox(height: 14),

                _buildQuestionRow(
                  question: 'Apakah terdapat Gangguan Kamtibmas',
                  value: provider.gangguanKamtibmas,
                  onChanged: (val) => provider.setGangguanKamtibmas(val),
                ),
                _buildQuestionRow(
                  question: 'Apakah Terdapat Aktivitas Mencurigakan',
                  value: provider.aktivitasMencurigakan,
                  onChanged: (val) => provider.setAktivitasMencurigakan(val),
                ),
                _buildQuestionRow(
                  question: 'Apakah Terdapat Kehilangan di lingkungan Anda',
                  value: provider.kehilanganLingkungan,
                  onChanged: (val) => provider.setKehilanganLingkungan(val),
                ),
                const SizedBox(height: 12),

                // ------------------ Section 2: Lingkungan ------------------
                _buildSectionHeader('Lingkungan'),
                const SizedBox(height: 14),

                _buildQuestionRow(
                  question: 'Apakah Terdapat Sampah Menumpuk',
                  value: provider.sampahMenumpuk,
                  onChanged: (val) => provider.setSampahMenumpuk(val),
                ),
                _buildQuestionRow(
                  question: 'Apakah terdapat jalan berlubang',
                  value: provider.jalanBerlubang,
                  onChanged: (val) => provider.setJalanBerlubang(val),
                ),
                _buildQuestionRow(
                  question: 'Apakah Terdapat lampu penerangan yang mati',
                  value: provider.lampuMati,
                  onChanged: (val) => provider.setLampuMati(val),
                ),
                const SizedBox(height: 12),

                // ------------------ Section 3: Sosial ------------------
                _buildSectionHeader('Sosial'),
                const SizedBox(height: 14),

                _buildQuestionRow(
                  question: 'Apakah Terdapat Permasalahan Sosial',
                  value: provider.permasalahanSosial,
                  onChanged: (val) => provider.setPermasalahanSosial(val),
                ),
                _buildQuestionRow(
                  question:
                      'Apakah Terdapat Kasus Perzinahan di lingkungan anda ?',
                  value: provider.kasusPerzinahan,
                  onChanged: (val) => provider.setKasusPerzinahan(val),
                ),
                _buildQuestionRow(
                  question: 'Apakah Terdapat Orang Terlantar',
                  value: provider.orangTerlantar,
                  onChanged: (val) => provider.setOrangTerlantar(val),
                ),
                const SizedBox(height: 20),

                // ------------------ Kolom Keterangan ------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.grey400,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: TextField(
                    controller: _keteranganController,
                    maxLines: 5,
                    minLines: 4,
                    onChanged: (val) => provider.updateKeterangan(val),
                    decoration: const InputDecoration(
                      hintText: 'KOLOM KETERANGAN',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey500,
                        letterSpacing: 0.8,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ------------------ Selesai Button ------------------
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 48,
                    width: 140,
                    child: ElevatedButton(
                      onPressed: provider.status == RondaStatus.submitting
                          ? null
                          : () async {
                              final success = await provider.submitLaporan();
                              if (success && context.mounted) {
                                _showSuccessDialog(context, provider);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC7E5DB),
                        foregroundColor: const Color(0xFF2C5E4C),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(
                            color: Color(0xFF2C5E4C),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: provider.status == RondaStatus.submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF2C5E4C),
                              ),
                            )
                          : const Text(
                              'SELESAI',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildQuestionRow({
    required String question,
    required bool? value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Option: Ya
              InkWell(
                onTap: () => onChanged(true),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: value == true
                                ? AppColors.primary
                                : AppColors.grey400,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: value == true
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: value == true
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Ya',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 40),

              // Option: Tidak
              InkWell(
                onTap: () => onChanged(false),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: value == false
                                ? AppColors.primary
                                : AppColors.grey400,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: value == false
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: value == false
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Tidak',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, RondaProvider provider) {
    final result = provider.lastResult;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Laporan Ronda Berhasil Terkirim!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Laporan ronda malam Anda telah tersimpan dengan ID ${result?.id ?? '-'}. Terima kasih atas partisipasi siaga lingkungan.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  provider.resetForm();
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'KEMBALI KE UTAMA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
