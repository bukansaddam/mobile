import 'dart:async';
import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_recorder_service.dart';
import 'package:akar/core/services/google_speech_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/ronda_malam/presentation/provider/ronda_provider.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

enum SttMode { none, regular, streaming }

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
  StreamSubscription<String>? _speechStreamSubscription;
  String _baseTextBeforeStreaming = '';

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _speechStreamSubscription?.cancel();
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
          final currentText = _keteranganController.text.trim();
          final newText = currentText.isEmpty
              ? transcript
              : '$currentText $transcript';
          _keteranganController.text = newText;
          provider.updateKeterangan(newText);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mode Biasa: Suara berhasil dikonversi ke teks!'),
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

  Future<void> _startStreamingRecording(RondaProvider provider) async {
    final audioRecorder = sl<AudioRecorderService>();
    final googleSpeech = sl<GoogleSpeechService>();
    final status = await audioRecorder.requestPermissionStatus();

    if (!status.isGranted) {
      if (status.isPermanentlyDenied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Izin mikrofon ditolak permanen.'),
            action: SnackBarAction(
              label: 'Pengaturan',
              textColor: Colors.white,
              onPressed: () => audioRecorder.openSettings(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final audioStream = await audioRecorder.startAudioStream();
      _baseTextBeforeStreaming = _keteranganController.text.trim();

      setState(() {
        _sttMode = SttMode.streaming;
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

      _speechStreamSubscription?.cancel();
      _speechStreamSubscription = googleSpeech
          .transcribeAudioStream(audioStream)
          .listen(
            (liveTranscript) {
              if (mounted && liveTranscript.trim().isNotEmpty) {
                final newText = _baseTextBeforeStreaming.isEmpty
                    ? liveTranscript
                    : '$_baseTextBeforeStreaming $liveTranscript';
                _keteranganController.text = newText;
                provider.updateKeterangan(newText);
              }
            },
            onError: (error) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mode Streaming Gagal: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
                _stopStreamingRecording();
              }
            },
            onDone: () {
              if (mounted && _sttMode == SttMode.streaming) {
                _stopStreamingRecording();
              }
            },
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memulai streaming audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopStreamingRecording() async {
    if (mounted) {
      setState(() {
        _sttMode = SttMode.none;
        _recordDurationSeconds = 0;
      });
    }

    _recordingTimer?.cancel();
    _recordingTimer = null;

    final sub = _speechStreamSubscription;
    _speechStreamSubscription = null;

    try {
      final audioRecorder = sl<AudioRecorderService>();
      await audioRecorder.cancelRecording();
    } catch (e) {
      AppLogger.e('Error cancelling audio recorder: $e');
    }

    try {
      sub?.cancel();
    } catch (e) {
      AppLogger.e('Error cancelling speech stream: $e');
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mode Streaming Selesai!'),
          backgroundColor: Colors.green,
        ),
      );
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
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.82),
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
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Form Pemantauan Ronda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Isi laporan kondisi situasi keamanan & lingkungan wilayah ronda malam.',
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
                ),
                const SizedBox(height: 20),

                _buildSectionCard(
                  title: 'Keamanan',
                  icon: Icons.security_rounded,
                  accentColor: const Color(0xFF2B6CB0),
                  questions: [
                    _QuestionData(
                      question: 'Apakah terdapat Gangguan Kamtibmas?',
                      value: provider.gangguanKamtibmas,
                      onChanged: (val) => provider.setGangguanKamtibmas(val),
                    ),
                    _QuestionData(
                      question: 'Apakah Terdapat Aktivitas Mencurigakan?',
                      value: provider.aktivitasMencurigakan,
                      onChanged: (val) =>
                          provider.setAktivitasMencurigakan(val),
                    ),
                    _QuestionData(
                      question:
                          'Apakah Terdapat Kehilangan di lingkungan Anda?',
                      value: provider.kehilanganLingkungan,
                      onChanged: (val) => provider.setKehilanganLingkungan(val),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildSectionCard(
                  title: 'Lingkungan',
                  icon: Icons.eco_rounded,
                  accentColor: const Color(0xFF2F855A),
                  questions: [
                    _QuestionData(
                      question: 'Apakah Terdapat Sampah Menumpuk?',
                      value: provider.sampahMenumpuk,
                      onChanged: (val) => provider.setSampahMenumpuk(val),
                    ),
                    _QuestionData(
                      question: 'Apakah terdapat jalan berlubang?',
                      value: provider.jalanBerlubang,
                      onChanged: (val) => provider.setJalanBerlubang(val),
                    ),
                    _QuestionData(
                      question: 'Apakah Terdapat lampu penerangan yang mati?',
                      value: provider.lampuMati,
                      onChanged: (val) => provider.setLampuMati(val),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildSectionCard(
                  title: 'Sosial',
                  icon: Icons.people_alt_rounded,
                  accentColor: const Color(0xFF6B46C1),
                  questions: [
                    _QuestionData(
                      question: 'Apakah Terdapat Permasalahan Sosial?',
                      value: provider.permasalahanSosial,
                      onChanged: (val) => provider.setPermasalahanSosial(val),
                    ),
                    _QuestionData(
                      question:
                          'Apakah Terdapat Kasus Perzinahan di lingkungan Anda?',
                      value: provider.kasusPerzinahan,
                      onChanged: (val) => provider.setKasusPerzinahan(val),
                    ),
                    _QuestionData(
                      question: 'Apakah Terdapat Orang Terlantar?',
                      value: provider.orangTerlantar,
                      onChanged: (val) => provider.setOrangTerlantar(val),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

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
                              fontSize: 14,
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
                            borderSide: const BorderSide(
                              color: AppColors.grey300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.grey300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
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
                                  'Merekam... ${_formatDuration(_recordDurationSeconds)}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _stopRegularRecording(provider),
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.check_rounded, size: 16),
                                label: const Text(
                                  'Selesai & Konversi',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_sttMode == SttMode.streaming) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.graphic_eq_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Silahkan bicara... ${_formatDuration(_recordDurationSeconds)}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _stopStreamingRecording(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(Icons.stop_rounded, size: 16),
                                label: const Text(
                                  'Hentikan',
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
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _startRegularRecording(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 10,
                                  ),
                                ),
                                icon: const Icon(Icons.mic_rounded, size: 16),
                                label: const Text(
                                  'Mode Biasa',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _startStreamingRecording(provider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 10,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.stream_rounded,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Mode Stream',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: Container(
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
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: provider.status == RondaStatus.submitting
                      ? null
                      : () async {
                          final success = await provider.submitLaporan();
                          if (success && context.mounted) {
                            _showSuccessDialog(context, provider);
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
                  icon: provider.status == RondaStatus.submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    provider.status == RondaStatus.submitting
                        ? 'MEMPROSES LAPORAN...'
                        : 'KIRIM LAPORAN RONDA',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
          ...questions.map((q) => _buildQuestionTile(q, accentColor)),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(_QuestionData data, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildChoiceChip(
                  label: 'Ya',
                  isSelected: data.value == true,
                  activeColor: AppColors.success,
                  icon: Icons.check_circle_rounded,
                  onTap: () => data.onChanged(true),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: _buildChoiceChip(
                  label: 'Tidak',
                  isSelected: data.value == false,
                  activeColor: AppColors.error,
                  icon: Icons.cancel_rounded,
                  onTap: () => data.onChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.12)
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.grey300,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? icon : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: isSelected ? activeColor : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : AppColors.textSecondary,
                ),
              ),
            ],
          ),
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
  final bool? value;
  final ValueChanged<bool> onChanged;

  _QuestionData({
    required this.question,
    required this.value,
    required this.onChanged,
  });
}
