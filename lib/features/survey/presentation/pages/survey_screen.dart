import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/survey/domain/entities/survey_entity.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_bloc.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_event.dart';
import 'package:akar/features/survey/presentation/bloc/survey_bloc/survey_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahAslinmasController = TextEditingController();

  bool? _isMemilahSampah;
  String? _tujuanSampahOrganik;
  bool? _hasBankSampah;
  bool? _hasMesinPengolahOrganik;
  bool? _hasAslinmas;
  bool? _hasRonda;

  @override
  void reassemble() {
    super.reassemble();
    _resetAnswers();
  }

  void _resetAnswers() {
    setState(() {
      _isMemilahSampah = null;
      _tujuanSampahOrganik = null;
      _hasBankSampah = null;
      _hasMesinPengolahOrganik = null;
      _hasAslinmas = null;
      _hasRonda = null;
      _jumlahAslinmasController.clear();
    });
  }

  @override
  void dispose() {
    _jumlahAslinmasController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_isMemilahSampah == null) {
      _showWarningSnackBar('Mohon jawab pertanyaan 1 (Memilah sampah)');
      return;
    }
    if (_tujuanSampahOrganik == null) {
      _showWarningSnackBar('Mohon jawab pertanyaan 2 (Tujuan sampah organik)');
      return;
    }
    if (_hasBankSampah == null) {
      _showWarningSnackBar('Mohon jawab pertanyaan 3 (Bank sampah)');
      return;
    }
    if (_hasMesinPengolahOrganik == null) {
      _showWarningSnackBar('Mohon jawab pertanyaan 4 (Mesin pengolah organik)');
      return;
    }
    if (_hasAslinmas == null) {
      _showWarningSnackBar('Mohon jawab pertanyaan 5 (Anggota ASLINMAS)');
      return;
    }
    if (_hasAslinmas == true) {
      if (_jumlahAslinmasController.text.trim().isEmpty) {
        _showWarningSnackBar('Mohon isi jumlah anggota ASLINMAS di RT Anda');
        return;
      }
    }
    if (_hasRonda == null) {
      _showWarningSnackBar('Mohon jawab pertanyaan 6 (Ronda malam)');
      return;
    }

    final periodKey = SurveyEntity.getCurrentPeriodKey();
    final periodLabel = SurveyEntity.getCurrentPeriodLabel();
    final int? jumlahAnggota = _hasAslinmas == true
        ? int.tryParse(_jumlahAslinmasController.text.trim())
        : 0;

    final survey = SurveyEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      period: periodKey,
      periodLabel: periodLabel,
      isMemilahSampah: _isMemilahSampah!,
      tujuanSampahOrganik: _tujuanSampahOrganik!,
      hasBankSampah: _hasBankSampah!,
      hasMesinPengolahOrganik: _hasMesinPengolahOrganik!,
      hasAslinmas: _hasAslinmas!,
      jumlahAnggotaAslinmas: jumlahAnggota,
      hasRonda: _hasRonda!,
      submittedAt: DateTime.now(),
    );

    context.read<SurveyBloc>().add(SubmitSurveyEvent(survey));
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPeriodLabel = SurveyEntity.getCurrentPeriodLabel();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Survey Bulanan',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocListener<SurveyBloc, SurveyState>(
        listener: (context, state) {
          if (state is SurveySuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 54,
                ),
                title: const Text('Survey Berhasil Dikirim'),
                content: Text(
                  'Terima kasih telah mengisi survey bulanan lingkungan & keamanan RT periode $currentPeriodLabel.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            );
          } else if (state is SurveyFailureState) {
            _showWarningSnackBar(state.errorMessage);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Periode $currentPeriodLabel',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Survey ini diisi 1x setiap bulan untuk memantau pengelolaan sampah & keamanan di lingkungan RT Anda.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildQuestionCard(
                  number: 1,
                  question:
                      'Apakah di lingkungan Anda sudah memilah sampah dengan baik?',
                  child: Column(
                    children: [
                      _buildRadioOption<bool>(
                        label: 'A. Sudah',
                        value: true,
                        groupValue: _isMemilahSampah,
                        onChanged: (val) =>
                            setState(() => _isMemilahSampah = val),
                      ),
                      _buildRadioOption<bool>(
                        label: 'B. Belum',
                        value: false,
                        groupValue: _isMemilahSampah,
                        onChanged: (val) =>
                            setState(() => _isMemilahSampah = val),
                      ),
                    ],
                  ),
                ),

                _buildQuestionCard(
                  number: 2,
                  question: 'Jika ada sampah organik, dibawa ke mana?',
                  child: Column(
                    children: [
                      _buildRadioOption<String>(
                        label: 'A. TPS',
                        value: 'TPS',
                        groupValue: _tujuanSampahOrganik,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _tujuanSampahOrganik = val);
                          }
                        },
                      ),
                      _buildRadioOption<String>(
                        label: 'B. TPA',
                        value: 'TPA',
                        groupValue: _tujuanSampahOrganik,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _tujuanSampahOrganik = val);
                          }
                        },
                      ),
                      _buildRadioOption<String>(
                        label: 'C. Di lokasi Sendiri',
                        value: 'Di lokasi Sendiri',
                        groupValue: _tujuanSampahOrganik,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _tujuanSampahOrganik = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                _buildQuestionCard(
                  number: 3,
                  question:
                      'Apakah di wilayah Anda sudah memiliki bank sampah?',
                  child: Column(
                    children: [
                      _buildRadioOption<bool>(
                        label: 'A. Sudah',
                        value: true,
                        groupValue: _hasBankSampah,
                        onChanged: (val) =>
                            setState(() => _hasBankSampah = val),
                      ),
                      _buildRadioOption<bool>(
                        label: 'B. Belum',
                        value: false,
                        groupValue: _hasBankSampah,
                        onChanged: (val) =>
                            setState(() => _hasBankSampah = val),
                      ),
                    ],
                  ),
                ),

                _buildQuestionCard(
                  number: 4,
                  question:
                      'Apakah di wilayah Anda sudah memiliki mesin pengolahan sampah organik?',
                  child: Column(
                    children: [
                      _buildRadioOption<bool>(
                        label: 'A. Sudah',
                        value: true,
                        groupValue: _hasMesinPengolahOrganik,
                        onChanged: (val) =>
                            setState(() => _hasMesinPengolahOrganik = val),
                      ),
                      _buildRadioOption<bool>(
                        label: 'B. Belum',
                        value: false,
                        groupValue: _hasMesinPengolahOrganik,
                        onChanged: (val) =>
                            setState(() => _hasMesinPengolahOrganik = val),
                      ),
                    ],
                  ),
                ),

                _buildQuestionCard(
                  number: 5,
                  question: 'Ada berapa anggota ASLINMAS di RT Anda?',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRadioOption<bool>(
                        label: 'A. Ada',
                        value: true,
                        groupValue: _hasAslinmas,
                        onChanged: (val) => setState(() => _hasAslinmas = val),
                      ),
                      if (_hasAslinmas == true) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 36,
                            top: 4,
                            bottom: 8,
                          ),
                          child: TextFormField(
                            controller: _jumlahAslinmasController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: 'Masukkan Jumlah Anggota ASLINMAS',
                              hintText: 'Contoh: 5',
                              prefixIcon: const Icon(
                                Icons.people_outline_rounded,
                              ),
                              filled: true,
                              fillColor: AppColors.grey50,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.grey300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      _buildRadioOption<bool>(
                        label: 'B. Tidak Ada',
                        value: false,
                        groupValue: _hasAslinmas,
                        onChanged: (val) {
                          setState(() {
                            _hasAslinmas = val;
                            _jumlahAslinmasController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                _buildQuestionCard(
                  number: 6,
                  question: 'Apakah di lingkungan Anda masih ada ronda?',
                  child: Column(
                    children: [
                      _buildRadioOption<bool>(
                        label: 'A. Ada',
                        value: true,
                        groupValue: _hasRonda,
                        onChanged: (val) => setState(() => _hasRonda = val),
                      ),
                      _buildRadioOption<bool>(
                        label: 'B. Tidak',
                        value: false,
                        groupValue: _hasRonda,
                        onChanged: (val) => setState(() => _hasRonda = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BlocBuilder<SurveyBloc, SurveyState>(
            builder: (context, state) {
              final isSubmitting = state is SurveySubmittingState;

              return SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isSubmitting ? 'Mengirim...' : 'Kirim Hasil Survey',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required int number,
    required String question,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildRadioOption<T>({
    required String label,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
