import 'dart:async';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_recorder_service.dart';
import 'package:akar/core/services/google_speech_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/provider/ronda_provider.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

enum SttMode { none, regular }

class _ScaleOption {
  final int value;
  final String label;
  final Color color;

  const _ScaleOption(this.value, this.label, this.color);
}

const List<_ScaleOption> _kScaleOptions = [
  _ScaleOption(1, 'Tidak ada', Color(0xFF9E9E9E)),
  _ScaleOption(2, 'Ada, tapi belum mengganggu', Color(0xFF8BC34A)),
  _ScaleOption(3, 'Ada, mulai mengganggu', Color(0xFFFFB300)),
  _ScaleOption(4, 'Ada, dan sudah mengganggu', Color(0xFFFF8A65)),
  _ScaleOption(5, 'Ada, dan sudah perlu ditangani', Color(0xFFE53935)),
];

class RondaScreen extends StatefulWidget {
  const RondaScreen({super.key});

  @override
  State<RondaScreen> createState() => _RondaScreenState();
}

class _RondaScreenState extends State<RondaScreen> {
  final TextEditingController _keteranganController = TextEditingController();
  SttMode _sttMode = SttMode.none;
  bool _isTranscribing = false;
  int _recordDurationSeconds = 0;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _keteranganController.addListener(_onKeteranganChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RondaProvider>().resetForm();
        _keteranganController.clear();
      }
    });
  }

  void _onKeteranganChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _keteranganController.removeListener(_onKeteranganChanged);
    _recordingTimer?.cancel();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _startRegularRecording() async {
    final audioRecorder = sl<AudioRecorderService>();
    final status = await audioRecorder.requestPermissionStatus();

    if (status.isGranted) {
      try {
        await audioRecorder.startRecording();
        setState(() {
          _sttMode = SttMode.regular;
          _recordDurationSeconds = 0;
        });
        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _recordDurationSeconds++;
            });
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memulai perekaman: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Izin mikrofon ditolak permanen. Silakan aktifkan di Pengaturan.',
            ),
            action: SnackBarAction(
              label: 'Pengaturan',
              textColor: Colors.white,
              onPressed: () => audioRecorder.openSettings(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin mikrofon dibutuhkan untuk fitur dikte suara.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _stopRegularRecording(RondaProvider provider) async {
    _recordingTimer?.cancel();
    setState(() {
      _sttMode = SttMode.none;
      _isTranscribing = true;
    });

    try {
      final audioRecorder = sl<AudioRecorderService>();
      final googleSpeech = sl<GoogleSpeechService>();
      final audioBytes = await audioRecorder.stopRecording();

      if (audioBytes == null || audioBytes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak ada data suara yang terekam.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final transcript = await googleSpeech.transcribeAudioBytes(audioBytes);

      if (mounted) {
        if (transcript.trim().isNotEmpty) {
          var formattedTranscript = transcript.trim();
          if (!formattedTranscript.endsWith('.') &&
              !formattedTranscript.endsWith('?') &&
              !formattedTranscript.endsWith('!')) {
            formattedTranscript = '$formattedTranscript.';
          }

          final currentText = _keteranganController.text.trim();
          final newText = currentText.isEmpty
              ? formattedTranscript
              : '$currentText $formattedTranscript';
          _keteranganController.text = newText;
          provider.updateKeterangan(newText);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Suara berhasil dikonversi ke teks!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Suara tidak terdengar jelas atau tidak ada suara terdeteksi.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppLogger.e('Gagal memproses suara : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memproses suara: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTranscribing = false;
          _recordDurationSeconds = 0;
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RondaProvider>(
      builder: (context, provider, child) {
        final currentStep = provider.currentStep;

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
              'Laporan Ronda Malam',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    _buildBannerHeader(currentStep),
                    const SizedBox(height: 14),
                    _buildStepperIndicator(provider, currentStep),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: _buildStepContent(provider, currentStep),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(
            context,
            provider,
            currentStep,
          ),
        );
      },
    );
  }

  Widget _buildBannerHeader(int currentStep) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStepIcon(currentStep),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Pemantauan Ronda (${currentStep + 1}/4)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStepDescription(currentStep),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.eco_rounded;
      case 1:
        return Icons.security_rounded;
      case 2:
        return Icons.people_alt_rounded;
      case 3:
      default:
        return Icons.edit_note_rounded;
    }
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'Step 1 dari 4: Evaluasi kondisi kebersihan, fasilitas & lingkungan.';
      case 1:
        return 'Step 2 dari 4: Identifikasi situasi ketertiban & potensi ancaman keamanan.';
      case 2:
        return 'Step 3 dari 4: Pemantauan situasi permasalahan sosial & keharmonisan warga.';
      case 3:
      default:
        return 'Step 4 dari 4: Catatan temuan khusus & pengiriman laporan ronda malam.';
    }
  }

  Widget _buildStepperIndicator(RondaProvider provider, int currentStep) {
    final stepTitles = ['Lingkungan', 'Keamanan', 'Sosial', 'Tambahan'];

    return Column(
      children: [
        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (currentStep + 1) / 4,
            minHeight: 6,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 12),
        // Step Pills Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : (isCompleted
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.white),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : (isCompleted
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : AppColors.grey300),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? Colors.white
                            : (isCompleted
                                  ? AppColors.primary
                                  : AppColors.grey500),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stepTitles[index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : (isCompleted
                                  ? AppColors.primary
                                  : AppColors.grey600),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepContent(RondaProvider provider, int currentStep) {
    switch (currentStep) {
      case 0:
        return _buildLingkunganStep(provider);
      case 1:
        return _buildKeamananStep(provider);
      case 2:
        return _buildSosialStep(provider);
      case 3:
      default:
        return _buildTambahanStep(provider);
    }
  }

  Widget _buildLingkunganStep(RondaProvider provider) {
    return _buildSectionCard(
      title: 'Lingkungan',
      icon: Icons.eco_rounded,
      accentColor: const Color(0xFF2F855A),
      questions: [
        _QuestionData(
          question: 'Apakah bapak/ibu melihat sampah menumpuk atau berserakan?',
          value: provider.sampahMenumpuk,
          onChanged: (val) => provider.setSampahMenumpuk(val),
        ),
        _QuestionData(
          question:
              'Apakah Bapak/Ibu melihat selokan mampet, air menggenang, atau jalan yang mulai kebanjiran',
          value: provider.selokanMampet,
          onChanged: (val) => provider.setSelokanMampet(val),
        ),
        _QuestionData(
          question:
              'Apakah Bapak/Ibu melihat jalan, lampu jalan, selokan, atau fasilitas umum yang rusak?',
          value: provider.fasilitasRusak,
          onChanged: (val) => provider.setFasilitasRusak(val),
        ),
        _QuestionData(
          question:
              'Apakah ada kegiatan warga atau usaha yang membuat lingkungan kotor atau mengganggu warga sekitar',
          value: provider.kegiatanMengganggu,
          onChanged: (val) => provider.setKegiatanMengganggu(val),
        ),
        _QuestionData(
          question:
              'Apakah Bapak/Ibu melihat sesuatu yang bisa membahayakan warga, seperti pohon hampir tumbang, kabel menjuntai, lubang jalan, atau bangunan rusak?',
          value: provider.potensiBahaya,
          onChanged: (val) => provider.setPotensiBahaya(val),
        ),
      ],
    );
  }

  Widget _buildKeamananStep(RondaProvider provider) {
    return _buildSectionCard(
      title: 'Keamanan',
      icon: Icons.security_rounded,
      accentColor: const Color(0xFF2B6CB0),
      questions: [
        _QuestionData(
          question:
              'Saat bertugas hari ini, apakah Bapak/Ibu melihat atau menerima laporan pencurian, perusakan, ancaman, atau kejadian keamanan lainnya?',
          value: provider.laporanKeamanan,
          onChanged: (val) => provider.setLaporanKeamanan(val),
        ),
        _QuestionData(
          question:
              'apakah hari ini ada warga yang bertengkar, ribut, atau berselisih sampai mengganggu warga sekitar?',
          value: provider.wargaBertengkar,
          onChanged: (val) => provider.setWargaBertengkar(val),
        ),
        _QuestionData(
          question:
              'Apakah Bapak/Ibu menemukan tempat yang gelap, sepi, atau kurang aman saat melakukan pemantauan?',
          value: provider.tempatKurangAman,
          onChanged: (val) => provider.setTempatKurangAman(val),
        ),
        _QuestionData(
          question:
              'Apakah ada kerumunan atau kegiatan warga yang membuat keadaan menjadi tidak tertib?',
          value: provider.kerumunanTidakTertib,
          onChanged: (val) => provider.setKerumunanTidakTertib(val),
        ),
        _QuestionData(
          question:
              'Apakah hari ini ada kejadian yang membuat Bapak/Ibu perlu meminta bantuan petugas lain, kelurahan/desa, Satpol PP, atau Polisi?',
          value: provider.perluBantuanPetugas,
          onChanged: (val) => provider.setPerluBantuanPetugas(val),
        ),
      ],
    );
  }

  Widget _buildSosialStep(RondaProvider provider) {
    return _buildSectionCard(
      title: 'Sosial',
      icon: Icons.people_alt_rounded,
      accentColor: const Color(0xFF6B46C1),
      questions: [
        _QuestionData(
          question:
              'Saat bertugas hari ini, apakah Bapak/Ibu menemukan warga yang terlihat membutuhkan bantuan?',
          value: provider.wargaButuhBantuan,
          onChanged: (val) => provider.setWargaButuhBantuan(val),
        ),
        _QuestionData(
          question:
              'Apakah ada warga atau kelompok warga yang bertengkar atau berselisih hari ini?',
          value: provider.kelompokBerselisih,
          onChanged: (val) => provider.setKelompokBerselisih(val),
        ),
        _QuestionData(
          question:
              'Apakah ada warga yang menyampaikan keluhan atau meminta bantuan kepada Bapak/Ibu hari ini?',
          value: provider.keluhanWarga,
          onChanged: (val) => provider.setKeluhanWarga(val),
        ),
        _QuestionData(
          question:
              'Apakah ada kegiatan atau kejadian yang membuat warga sekitar merasa terganggu?',
          value: provider.kejadianMenggangguWarga,
          onChanged: (val) => provider.setKejadianMenggangguWarga(val),
        ),
        _QuestionData(
          question:
              'Apakah ada masalah warga yang menurut Bapak/Ibu perlu diteruskan ke RT/RW, desa/kelurahan, atau petugas lain?',
          value: provider.perluTerusanRTRW,
          onChanged: (val) => provider.setPerluTerusanRTRW(val),
        ),
      ],
    );
  }

  Widget _buildTambahanStep(RondaProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Catatan & Temuan Tambahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _keteranganController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                maxLines: 4,
                minLines: 3,
                onChanged: (val) => provider.updateKeterangan(val),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Tuliskan keterangan detail atau temuan unik di sini...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                  filled: true,
                  fillColor: AppColors.grey100,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: _keteranganController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.cancel_rounded,
                            color: AppColors.grey500,
                            size: 20,
                          ),
                          onPressed: () {
                            _keteranganController.clear();
                            provider.updateKeterangan('');
                          },
                          tooltip: 'Bersihkan teks',
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              if (_sttMode == SttMode.regular) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fiber_manual_record,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mendengarkan... ${_formatDuration(_recordDurationSeconds)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _stopRegularRecording(provider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        label: const Text(
                          'Ketuk untuk berhenti',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_isTranscribing) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Mengonversi suara ke teks...',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _startRegularRecording(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.mic_rounded, size: 16),
                    label: const Text(
                      'Bicara untuk menulis',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 2, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Catatan: Fitur "Bicara untuk menulis" hanya mendukung Bahasa Indonesia.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(provider),
      ],
    );
  }

  Widget _buildSummaryCard(RondaProvider provider) {
    int countNeedAttention(List<int> values) {
      return values.where((v) => v > 1).length;
    }

    final lingkunganAlerts = countNeedAttention([
      provider.sampahMenumpuk,
      provider.selokanMampet,
      provider.fasilitasRusak,
      provider.kegiatanMengganggu,
      provider.potensiBahaya,
    ]);

    final keamananAlerts = countNeedAttention([
      provider.laporanKeamanan,
      provider.wargaBertengkar,
      provider.tempatKurangAman,
      provider.kerumunanTidakTertib,
      provider.perluBantuanPetugas,
    ]);

    final sosialAlerts = countNeedAttention([
      provider.wargaButuhBantuan,
      provider.kelompokBerselisih,
      provider.keluhanWarga,
      provider.kejadianMenggangguWarga,
      provider.perluTerusanRTRW,
    ]);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Laporan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Lingkungan',
            '$lingkunganAlerts temuan terindikasi',
            lingkunganAlerts > 0 ? Colors.orange : Colors.green,
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Keamanan',
            '$keamananAlerts temuan terindikasi',
            keamananAlerts > 0 ? Colors.orange : Colors.green,
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Sosial',
            '$sosialAlerts temuan terindikasi',
            sosialAlerts > 0 ? Colors.orange : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String valueText, Color badgeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            valueText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required List<_QuestionData> questions,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 14),
          ...questions.map((q) => _buildScaleQuestionTile(q)),
        ],
      ),
    );
  }

  Widget _buildScaleQuestionTile(_QuestionData data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          RadioGroup<int>(
            groupValue: data.value,
            onChanged: (val) {
              if (val != null) {
                data.onChanged(val);
              }
            },
            child: Column(
              children: _kScaleOptions.map((opt) {
                final isSelected = data.value == opt.value;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => data.onChanged(opt.value),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Radio<int>(
                              value: opt.value,
                              activeColor: AppColors.primary,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: opt.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              opt.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    RondaProvider provider,
    int currentStep,
  ) {
    final isFinalStep = currentStep == 3;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
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
        top: false,
        child: Row(
          children: [
            if (currentStep > 0) ...[
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => provider.previousStep(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.grey300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: provider.status == RondaStatus.submitting
                      ? null
                      : () async {
                          if (isFinalStep) {
                            final success = await provider.submitLaporan();
                            if (success && context.mounted) {
                              _showSuccessDialog(context, provider);
                            }
                          } else {
                            provider.nextStep();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: provider.status == RondaStatus.submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isFinalStep ? 'Kirim Laporan' : 'Lanjut',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
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

class _QuestionData {
  final String question;
  final int value;
  final ValueChanged<int> onChanged;

  _QuestionData({
    required this.question,
    required this.value,
    required this.onChanged,
  });
}
