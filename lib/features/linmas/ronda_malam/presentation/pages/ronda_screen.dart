import 'dart:async';

import 'package:akar/core/di/injection_container.dart';
import 'package:akar/core/services/audio_recorder_service.dart';
import 'package:akar/core/services/google_speech_service.dart';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/ronda_malam/core/constants/ronda_constants.dart';
import 'package:akar/features/linmas/ronda_malam/domain/entities/ronda_laporan_entity.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/bloc/ronda_bloc/ronda_bloc.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/widgets/ronda_step_indicator.dart';
import 'package:akar/features/linmas/ronda_malam/presentation/widgets/ronda_success_dialog.dart';
import 'package:akar/features/masyarakat/complaint/presentation/pages/location_picker_page.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

enum SttMode { none, regular }

class RondaScreen extends StatefulWidget {
  const RondaScreen({super.key});

  @override
  State<RondaScreen> createState() => _RondaScreenState();
}

class _RondaScreenState extends State<RondaScreen> {
  final TextEditingController _keteranganController = TextEditingController();
  SttMode _sttMode = SttMode.none;
  bool _isTranscribing = false;
  final ValueNotifier<int> _recordDurationNotifier = ValueNotifier<int>(0);
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _keteranganController.addListener(_onKeteranganChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RondaBloc>().add(ResetRondaFormEvent());
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
    _recordDurationNotifier.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _startRegularRecording() async {
    final audioRecorder = sl<AudioRecorderService>();
    final status = await audioRecorder.requestPermissionStatus();

    if (status.isGranted) {
      try {
        await audioRecorder.startRecording();
        _recordDurationNotifier.value = 0;
        setState(() {
          _sttMode = SttMode.regular;
        });
        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            _recordDurationNotifier.value++;
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memulai perekaman: $e'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Izin mikrofon dibutuhkan untuk fitur dikte suara.',
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _stopRegularRecording() async {
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
            SnackBar(
              content: const Text('Tidak ada data suara yang terekam.'),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
          context.read<RondaBloc>().add(
            UpdateRondaFieldEvent(keterangan: newText),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Suara berhasil dikonversi ke teks!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Suara tidak terdengar jelas atau tidak ada suara terdeteksi.',
              ),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        _recordDurationNotifier.value = 0;
        setState(() {
          _isTranscribing = false;
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
    return BlocConsumer<RondaBloc, RondaState>(
      listener: (context, state) {
        if (state is RondaActionSuccess) {
          _showSuccessDialog(context, state.laporan);
        } else if (state is RondaActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final currentStep = state.currentStep;

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
              'Laporan Harian',
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
                child: RondaStepIndicator(currentStep: currentStep),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: _buildStepContent(state, currentStep),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(
            context,
            state,
            currentStep,
          ),
        );
      },
    );
  }

  Widget _buildStepContent(RondaState state, int currentStep) {
    switch (currentStep) {
      case 0:
        return _buildSampahStep(state);
      case 1:
        return _buildKeamananStep(state);
      case 2:
        return _buildLingkunganStep(state);
      case 3:
      default:
        return _buildTambahanStep(state);
    }
  }

  Widget _buildSampahStep(RondaState state) {
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
                  color: const Color(0xFFD97706).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cleaning_services_rounded,
                  color: Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Sampah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 16),

          _buildYesNoQuestion(
            questionNumber: 1,
            question:
                'Apakah pada area tugas patroli anda hari ini ditemukan sampah menumpuk?',
            value: state.adaSampahMenumpuk,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaSampahMenumpuk: val),
              );
            },
          ),
          if (state.adaSampahMenumpuk) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildTimePickerInput(
                  label: 'Waktu Kejadian',
                  value: state.waktuSampahMenumpuk,
                  hintText: 'pilih waktu',
                  onTimeSelected: (timeStr) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(waktuSampahMenumpuk: timeStr),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Lokasi Kejadian',
                  value: state.lokasiSampahMenumpuk,
                  hintText: 'pilih lokasi',
                  items: RondaConstants.lokasiSampahOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(lokasiSampahMenumpuk: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Jenis Sampah Dominan',
                  value: state.jenisSampahDominan,
                  hintText: 'pilih jenis',
                  items: RondaConstants.jenisSampahDominanOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(jenisSampahDominan: val),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 20),

          _buildYesNoQuestion(
            questionNumber: 2,
            question:
                'Apakah pengangkutan sampah dilingkungan anda sesuai jadwal yang ditentukan?',
            value: state.pengangkutanSesuaiJadwal,
            isNegativeCondition: false,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(pengangkutanSesuaiJadwal: val),
              );
            },
          ),
          if (!state.pengangkutanSesuaiJadwal) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildDropdownInput(
                  label: 'Alasan',
                  value: state.alasanPengangkutan,
                  hintText: 'pilih alasan',
                  items: RondaConstants.alasanPengangkutanOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(alasanPengangkutan: val),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 20),

          _buildYesNoQuestion(
            questionNumber: 3,
            question:
                'Apakah ditemukan aktivitas pembakaran sampah di area patroli?',
            value: state.adaPembakaranSampah,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaPembakaranSampah: val),
              );
            },
          ),
          if (state.adaPembakaranSampah) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildTimePickerInput(
                  label: 'Waktu Kejadian',
                  value: state.waktuPembakaran,
                  hintText: 'pilih waktu',
                  onTimeSelected: (timeStr) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(waktuPembakaran: timeStr),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Lokasi Kejadian',
                  value: state.lokasiPembakaran,
                  hintText: 'pilih lokasi',
                  items: RondaConstants.lokasiKejadianUmumOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(lokasiPembakaran: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Apakah sudah diberikan tindakan',
                  value: state.pembakaranDiberiTindakan,
                  hintText: 'pilih tindakan',
                  items: RondaConstants.yaTidakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(pembakaranDiberiTindakan: val),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeamananStep(RondaState state) {
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
                  color: const Color(0xFF2B6CB0).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.security_rounded,
                  color: Color(0xFF2B6CB0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Keamanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B6CB0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 16),

          _buildYesNoQuestion(
            questionNumber: 1,
            question:
                'Apakah terjadi pencurian atau perampasan barang milik orang lain?',
            value: state.adaPencurian,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaPencurian: val),
              );
            },
          ),
          if (state.adaPencurian) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildTimePickerInput(
                  label: 'Waktu Kejadian',
                  value: state.waktuPencurian,
                  hintText: 'pilih waktu',
                  onTimeSelected: (timeStr) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(waktuPencurian: timeStr),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Lokasi Kejadian',
                  value: state.lokasiPencurian,
                  hintText: 'pilih lokasi',
                  items: RondaConstants.lokasiKejadianUmumOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(lokasiPencurian: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Pelaku Diketahui',
                  value: state.pelakuPencurianDiketahui,
                  hintText: 'pilih opsi',
                  items: RondaConstants.yaTidakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(pelakuPencurianDiketahui: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Sudah Dilaporkan ke Aparat',
                  value: state.pencurianDilaporkanAparat,
                  hintText: 'pilih opsi',
                  items: RondaConstants.yaTidakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(pencurianDilaporkanAparat: val),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 20),

          _buildYesNoQuestion(
            questionNumber: 2,
            question:
                'Apakah terjadi perkelahian kelompok / tawuran di lingkungan anda?',
            value: state.adaTawuran,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaTawuran: val),
              );
            },
          ),
          if (state.adaTawuran) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildTimePickerInput(
                  label: 'Waktu Kejadian',
                  value: state.waktuTawuran,
                  hintText: 'pilih waktu',
                  onTimeSelected: (timeStr) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(waktuTawuran: timeStr),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Lokasi Kejadian',
                  value: state.lokasiTawuran,
                  hintText: 'pilih lokasi',
                  items: RondaConstants.lokasiKejadianUmumOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(lokasiTawuran: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Pelaku Diketahui',
                  value: state.pelakuTawuranDiketahui,
                  hintText: 'pilih opsi',
                  items: RondaConstants.yaTidakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(pelakuTawuranDiketahui: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Sudah Dilaporkan ke Aparat',
                  value: state.tawuranDilaporkanAparat,
                  hintText: 'pilih opsi',
                  items: RondaConstants.yaTidakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(tawuranDilaporkanAparat: val),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 20),

          _buildYesNoQuestion(
            questionNumber: 3,
            question:
                'Apakah terdapat penyalahgunaan narkoba di lingkungan anda?',
            value: state.adaNarkoba,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaNarkoba: val),
              );
            },
          ),
          if (state.adaNarkoba) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildDropdownInput(
                  label: 'Sudah Dilaporkan ke Aparat',
                  value: state.narkobaDilaporkanAparat,
                  hintText: 'pilih opsi',
                  items: RondaConstants.yaTidakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(narkobaDilaporkanAparat: val),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLingkunganStep(RondaState state) {
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
                  color: const Color(0xFF2F855A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF2F855A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Lingkungan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F855A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 16),

          _buildYesNoQuestion(
            questionNumber: 1,
            question: 'Apakah terdapat selokan tersumbat di lingkungan anda?',
            value: state.adaSelokanTersumbat,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaSelokanTersumbat: val),
              );
            },
          ),
          if (state.adaSelokanTersumbat) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildTimePickerInput(
                  label: 'Waktu Kejadian',
                  value: state.waktuSelokanTersumbat,
                  hintText: 'pilih waktu',
                  onTimeSelected: (timeStr) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(waktuSelokanTersumbat: timeStr),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Lokasi Kejadian',
                  value: state.lokasiSelokanTersumbat,
                  hintText: 'pilih lokasi',
                  items: RondaConstants.lokasiKejadianUmumOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(lokasiSelokanTersumbat: val),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Resiko yang Terjadi',
                  value: state.resikoSelokanTersumbat,
                  hintText: 'pilih resiko',
                  items: RondaConstants.resikoSelokanOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(resikoSelokanTersumbat: val),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 20),

          _buildYesNoQuestion(
            questionNumber: 2,
            question: 'Apakah Terdapat Jalan rusak di lingkungan anda?',
            value: state.adaJalanRusak,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaJalanRusak: val),
              );
            },
          ),
          if (state.adaJalanRusak) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildGpsInput(
                  label: 'Lokasi Kejadian (GPS)',
                  value: state.lokasiJalanRusakGps,
                  hintText: 'pilih lokasi gps',
                  onLocationSelected: (address, lat, lng) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(
                        lokasiJalanRusakGps: address,
                        latitudeJalanRusak: lat,
                        longitudeJalanRusak: lng,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Resiko yang Terjadi',
                  value: state.resikoJalanRusak,
                  hintText: 'pilih resiko',
                  items: RondaConstants.resikoJalanRusakOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(resikoJalanRusak: val),
                    );
                  },
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey200),
          const SizedBox(height: 20),

          _buildYesNoQuestion(
            questionNumber: 3,
            question:
                'Apakah terdapat lampu jalan yang tidak menyala di lingkungan anda?',
            value: state.adaLampuMati,
            isNegativeCondition: true,
            onChanged: (val) {
              context.read<RondaBloc>().add(
                UpdateRondaFieldEvent(adaLampuMati: val),
              );
            },
          ),
          if (state.adaLampuMati) ...[
            const SizedBox(height: 12),
            _buildNestedContainer(
              children: [
                _buildGpsInput(
                  label: 'Lokasi Kejadian (GPS)',
                  value: state.lokasiLampuMatiGps,
                  hintText: 'pilih lokasi gps',
                  onLocationSelected: (address, lat, lng) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(
                        lokasiLampuMatiGps: address,
                        latitudeLampuMati: lat,
                        longitudeLampuMati: lng,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdownInput(
                  label: 'Resiko yang Terjadi',
                  value: state.resikoLampuMati,
                  hintText: 'pilih resiko',
                  items: RondaConstants.resikoLampuMatiOptions,
                  onChanged: (val) {
                    context.read<RondaBloc>().add(
                      UpdateRondaFieldEvent(resikoLampuMati: val),
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTambahanStep(RondaState state) {
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
                onChanged: (val) => context.read<RondaBloc>().add(
                  UpdateRondaFieldEvent(keterangan: val),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'tulis keterangan...',
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
                            context.read<RondaBloc>().add(
                              const UpdateRondaFieldEvent(keterangan: ''),
                            );
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
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.fiber_manual_record,
                        color: AppColors.error,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: _recordDurationNotifier,
                          builder: (context, duration, _) {
                            return Text(
                              'Mendengarkan... ${_formatDuration(duration)}',
                              style: const TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _stopRegularRecording(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
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
              const Padding(
                padding: EdgeInsets.only(left: 2, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
        _buildSummaryCard(state),
      ],
    );
  }

  Widget _buildSummaryCard(RondaState state) {
    int sampahAlerts = 0;
    if (state.adaSampahMenumpuk) sampahAlerts++;
    if (!state.pengangkutanSesuaiJadwal) sampahAlerts++;
    if (state.adaPembakaranSampah) sampahAlerts++;

    int keamananAlerts = 0;
    if (state.adaPencurian) keamananAlerts++;
    if (state.adaTawuran) keamananAlerts++;
    if (state.adaNarkoba) keamananAlerts++;

    int lingkunganAlerts = 0;
    if (state.adaSelokanTersumbat) lingkunganAlerts++;
    if (state.adaJalanRusak) lingkunganAlerts++;
    if (state.adaLampuMati) lingkunganAlerts++;

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
            'Sampah',
            '$sampahAlerts temuan terindikasi',
            sampahAlerts > 0 ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Keamanan',
            '$keamananAlerts temuan terindikasi',
            keamananAlerts > 0 ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Lingkungan',
            '$lingkunganAlerts temuan terindikasi',
            lingkunganAlerts > 0 ? AppColors.warning : AppColors.success,
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

  Widget _buildYesNoQuestion({
    required int questionNumber,
    required String question,
    required bool value,
    required bool isNegativeCondition,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$questionNumber',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildChoiceTile(
                label: 'Ya',
                isSelected: value == true,
                selectedColor: isNegativeCondition
                    ? AppColors.warning
                    : AppColors.success,
                onTap: () => onChanged(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChoiceTile(
                label: 'Tidak',
                isSelected: value == false,
                selectedColor: isNegativeCondition
                    ? AppColors.success
                    : AppColors.warning,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceTile({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withValues(alpha: 0.12)
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? selectedColor : AppColors.grey300,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 18,
                color: isSelected ? selectedColor : AppColors.grey500,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? selectedColor : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNestedContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey100.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildGpsInput({
    required String label,
    required String? value,
    required void Function(String address, double? lat, double? lng)
    onLocationSelected,
    String? hintText,
  }) {
    final effectiveHint = hintText ?? 'pilih lokasi gps';
    final bool hasValue = value != null && value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final result = await LocationPickerPage.showWithResult(
              context,
              initialAddress: hasValue ? value : null,
            );
            if (result != null && result.address.isNotEmpty) {
              onLocationSelected(
                result.address,
                result.latitude,
                result.longitude,
              );
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value : effectiveHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: hasValue
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.grey500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.map_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerInput({
    required String label,
    required String? value,
    required Function(String) onTimeSelected,
    String? hintText,
    bool isRequired = true,
  }) {
    final effectiveHint = hintText ?? 'pilih waktu';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : const [],
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final now = TimeOfDay.now();
            final picked = await showTimePicker(
              context: context,
              initialTime: now,
            );
            if (picked != null) {
              final formatted =
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              onTimeSelected(formatted);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null && value.isNotEmpty ? value : effectiveHint,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: value != null && value.isNotEmpty
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: value != null && value.isNotEmpty
                        ? AppColors.textPrimary
                        : AppColors.grey500,
                  ),
                ),
                const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownInput({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText,
  }) {
    final effectiveHint = hintText ?? 'pilih ${label.toLowerCase()}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: items.contains(value) ? value : null,
          hint: Text(
            effectiveHint,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.grey500,
            ),
          ),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: effectiveHint,
            hintStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.grey500,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    RondaState state,
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
                    onPressed: () =>
                        context.read<RondaBloc>().add(PreviousRondaStepEvent()),
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
                  onPressed: state is RondaActionLoading
                      ? null
                      : () {
                          if (isFinalStep) {
                            _onSubmitPressed(context, state);
                          } else {
                            _onNextPressed(context, state, currentStep);
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
                  child: state is RondaActionLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isFinalStep ? 'Kirim' : 'Lanjut',
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

  String? _validateStep(RondaState state, int step) {
    if (step == 0) {
      if (state.adaSampahMenumpuk) {
        if (state.waktuSampahMenumpuk == null ||
            state.waktuSampahMenumpuk!.trim().isEmpty) {
          return 'Waktu kejadian sampah menumpuk wajib diisi';
        }
        if (state.lokasiSampahMenumpuk == null ||
            state.lokasiSampahMenumpuk!.trim().isEmpty) {
          return 'Lokasi kejadian sampah menumpuk wajib dipilih';
        }
        if (state.jenisSampahDominan == null ||
            state.jenisSampahDominan!.trim().isEmpty) {
          return 'Jenis sampah dominan wajib dipilih';
        }
      }
      if (!state.pengangkutanSesuaiJadwal) {
        if (state.alasanPengangkutan == null ||
            state.alasanPengangkutan!.trim().isEmpty) {
          return 'Alasan pengangkutan sampah tidak sesuai jadwal wajib dipilih';
        }
      }
      if (state.adaPembakaranSampah) {
        if (state.waktuPembakaran == null ||
            state.waktuPembakaran!.trim().isEmpty) {
          return 'Waktu kejadian pembakaran sampah wajib diisi';
        }
        if (state.lokasiPembakaran == null ||
            state.lokasiPembakaran!.trim().isEmpty) {
          return 'Lokasi kejadian pembakaran sampah wajib dipilih';
        }
        if (state.pembakaranDiberiTindakan == null ||
            state.pembakaranDiberiTindakan!.trim().isEmpty) {
          return 'Status tindakan pembakaran sampah wajib dipilih';
        }
      }
    } else if (step == 1) {
      if (state.adaPencurian) {
        if (state.waktuPencurian == null ||
            state.waktuPencurian!.trim().isEmpty) {
          return 'Waktu kejadian pencurian/perampasan wajib diisi';
        }
        if (state.lokasiPencurian == null ||
            state.lokasiPencurian!.trim().isEmpty) {
          return 'Lokasi kejadian pencurian/perampasan wajib dipilih';
        }
        if (state.pelakuPencurianDiketahui == null ||
            state.pelakuPencurianDiketahui!.trim().isEmpty) {
          return 'Status pelaku diketahui pada pencurian/perampasan wajib dipilih';
        }
        if (state.pencurianDilaporkanAparat == null ||
            state.pencurianDilaporkanAparat!.trim().isEmpty) {
          return 'Status lapor ke aparat pada pencurian/perampasan wajib dipilih';
        }
      }
      if (state.adaTawuran) {
        if (state.waktuTawuran == null || state.waktuTawuran!.trim().isEmpty) {
          return 'Waktu kejadian perkelahian/tawuran wajib diisi';
        }
        if (state.lokasiTawuran == null ||
            state.lokasiTawuran!.trim().isEmpty) {
          return 'Lokasi kejadian perkelahian/tawuran wajib dipilih';
        }
        if (state.pelakuTawuranDiketahui == null ||
            state.pelakuTawuranDiketahui!.trim().isEmpty) {
          return 'Status pelaku diketahui pada perkelahian/tawuran wajib dipilih';
        }
        if (state.tawuranDilaporkanAparat == null ||
            state.tawuranDilaporkanAparat!.trim().isEmpty) {
          return 'Status lapor ke aparat pada perkelahian/tawuran wajib dipilih';
        }
      }
      if (state.adaNarkoba) {
        if (state.narkobaDilaporkanAparat == null ||
            state.narkobaDilaporkanAparat!.trim().isEmpty) {
          return 'Status lapor ke aparat pada penyalahgunaan narkoba wajib dipilih';
        }
      }
    } else if (step == 2) {
      if (state.adaSelokanTersumbat) {
        if (state.waktuSelokanTersumbat == null ||
            state.waktuSelokanTersumbat!.trim().isEmpty) {
          return 'Waktu kejadian selokan tersumbat wajib diisi';
        }
        if (state.lokasiSelokanTersumbat == null ||
            state.lokasiSelokanTersumbat!.trim().isEmpty) {
          return 'Lokasi kejadian selokan tersumbat wajib dipilih';
        }
        if (state.resikoSelokanTersumbat == null ||
            state.resikoSelokanTersumbat!.trim().isEmpty) {
          return 'Resiko yang terjadi pada selokan tersumbat wajib dipilih';
        }
      }
      if (state.adaJalanRusak) {
        if (state.lokasiJalanRusakGps == null ||
            state.lokasiJalanRusakGps!.trim().isEmpty) {
          return 'Lokasi GPS jalan rusak wajib ditentukan';
        }
        if (state.resikoJalanRusak == null ||
            state.resikoJalanRusak!.trim().isEmpty) {
          return 'Resiko yang terjadi pada jalan rusak wajib dipilih';
        }
      }
      if (state.adaLampuMati) {
        if (state.lokasiLampuMatiGps == null ||
            state.lokasiLampuMatiGps!.trim().isEmpty) {
          return 'Lokasi GPS lampu jalan mati wajib ditentukan';
        }
        if (state.resikoLampuMati == null ||
            state.resikoLampuMati!.trim().isEmpty) {
          return 'Resiko yang terjadi pada lampu jalan mati wajib dipilih';
        }
      }
    }
    return null;
  }

  void _onNextPressed(BuildContext context, RondaState state, int currentStep) {
    final error = _validateStep(state, currentStep);
    if (error != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  error,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(12),
        ),
      );
      return;
    }
    context.read<RondaBloc>().add(NextRondaStepEvent());
  }

  void _onSubmitPressed(BuildContext context, RondaState state) {
    for (int step = 0; step < 3; step++) {
      final error = _validateStep(state, step);
      if (error != null) {
        context.read<RondaBloc>().add(SetRondaStepEvent(step));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
        return;
      }
    }
    context.read<RondaBloc>().add(const SubmitRondaLaporanEvent());
  }

  void _showSuccessDialog(BuildContext context, RondaLaporanEntity? result) {
    RondaSuccessDialog.show(
      context,
      result: result,
      onDismiss: () {
        context.read<RondaBloc>().add(ResetRondaFormEvent());
        Navigator.pop(context);
      },
    );
  }
}
