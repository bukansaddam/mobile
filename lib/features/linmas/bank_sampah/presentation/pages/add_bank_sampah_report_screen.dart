import 'dart:io';
import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/bank_sampah_constants.dart';
import '../../domain/entities/bank_sampah_location_entity.dart';
import '../provider/bank_sampah_provider.dart';
import '../widgets/bank_sampah_search_sheet.dart';

class AddBankSampahReportScreen extends StatefulWidget {
  const AddBankSampahReportScreen({super.key});

  @override
  State<AddBankSampahReportScreen> createState() =>
      _AddBankSampahReportScreenState();
}

class _AddBankSampahReportScreenState extends State<AddBankSampahReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  BankSampahLocationEntity? _selectedLocation;
  String _selectedJenisSampah = BankSampahConstants.jenisSampahList.first;
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  double _calculatedNilai = 0.0;
  File? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<BankSampahProvider>();
      await provider.updateDistancesWithCurrentLocation(silent: true);
      if (mounted && _selectedLocation == null) {
        setState(() {
          _selectedLocation =
              provider.nearestLocation ??
              (provider.locations.isNotEmpty ? provider.locations.first : null);
        });
      }
    });
  }

  @override
  void dispose() {
    _beratController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _onBeratChanged(String val) {
    final parsed = double.tryParse(val.replaceAll(',', '.')) ?? 0.0;
    setState(() {
      _calculatedNilai = parsed * BankSampahConstants.hargaPerKg;
    });
  }

  void _addBeratPreset(double add) {
    final current =
        double.tryParse(_beratController.text.replaceAll(',', '.')) ?? 0.0;
    final newTotal = (current + add).clamp(0.0, 9999.0);
    _beratController.text = newTotal.toStringAsFixed(
      newTotal.truncateToDouble() == newTotal ? 0 : 1,
    );
    _onBeratChanged(_beratController.text);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedPhoto = File(picked.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil gambar: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih Sumber Foto',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: const Text(
                    'Kamera',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Ambil foto sampah langsung'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  title: const Text(
                    'Galeri',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Pilih dari file foto tersimpan'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih Bank Sampah terlebih dahulu.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final parsedBerat =
        double.tryParse(_beratController.text.replaceAll(',', '.')) ?? 0.0;
    if (parsedBerat <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berat sampah harus lebih dari 0 kg.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final petugasNama = authProvider.currentUser?.name ?? 'Petugas Linmas';
    final provider = context.read<BankSampahProvider>();

    final success = await provider.addReport(
      bankSampahId: _selectedLocation!.id,
      bankSampahNama: _selectedLocation!.nama,
      jenisSampah: _selectedJenisSampah,
      beratKg: parsedBerat,
      fotoPath: _selectedPhoto?.path,
      catatan: _catatanController.text.trim(),
      petugasNama: petugasNama,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Laporan Bank Sampah ($_selectedJenisSampah - ${parsedBerat}kg) berhasil ditambahkan!',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Gagal menyimpan laporan bank sampah.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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
          'Tambah Laporan Sampah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Consumer<BankSampahProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: ElevatedButton(
                onPressed: provider.isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: provider.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Simpan Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF3FE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD6E4FB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF2F80ED),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Catat penimbangan sampah di Bank Sampah. Nilai dihitung otomatis Rp 5.000 / kg.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF1E5BB4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildSectionHeader(
                  icon: Icons.account_balance_rounded,
                  title: 'Pilih Bank Sampah *',
                  subtitle: 'Tentukan lokasi bank sampah penerima sampah',
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final selected = await BankSampahSearchSheet.show(
                      context,
                      initialSelected: _selectedLocation,
                    );
                    if (selected != null) {
                      setState(() {
                        _selectedLocation = selected;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _selectedLocation != null
                            ? AppColors.primary
                            : AppColors.grey300,
                        width: _selectedLocation != null ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedLocation != null
                                ? AppColors.primaryLight
                                : AppColors.grey100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.recycling_rounded,
                            color: _selectedLocation != null
                                ? AppColors.primary
                                : AppColors.grey500,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _selectedLocation != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _selectedLocation!.nama,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                          ),
                                        ),
                                        if (_selectedLocation!
                                            .formattedDistance
                                            .isNotEmpty) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF0284C7,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFF0284C7,
                                                ).withValues(alpha: 0.3),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.near_me_rounded,
                                                  size: 11,
                                                  color: Color(0xFF0284C7),
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  _selectedLocation!
                                                      .formattedDistance,
                                                  style: const TextStyle(
                                                    color: Color(0xFF0284C7),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _selectedLocation!.alamat,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : Text(
                                  'Cari atau pilih Bank Sampah...',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textHint,
                                  ),
                                ),
                        ),
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.grey600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildSectionHeader(
                  icon: Icons.category_rounded,
                  title: 'Jenis Sampah *',
                  subtitle: 'Pilih kategori jenis sampah yang disetor',
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedJenisSampah,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.grey600,
                      ),
                      items: BankSampahConstants.jenisSampahList.map((jenis) {
                        return DropdownMenuItem<String>(
                          value: jenis,
                          child: Row(
                            children: [
                              _getJenisIconWidget(jenis),
                              const SizedBox(width: 10),
                              Text(
                                jenis,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedJenisSampah = val;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildSectionHeader(
                  icon: Icons.scale_rounded,
                  title: 'Berat Sampah (Kg) *',
                  subtitle: 'Masukkan bobot hasil penimbangan dalam kilogram',
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _beratController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+[\.,]?\d{0,2}'),
                    ),
                  ],
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  onChanged: _onBeratChanged,
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textHint,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    suffixText: 'kg',
                    suffixStyle: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Berat sampah wajib diisi';
                    }
                    final d = double.tryParse(val.replaceAll(',', '.'));
                    if (d == null || d <= 0) {
                      return 'Masukkan angka berat yang valid (> 0)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    _buildPresetChip('+1 kg', () => _addBeratPreset(1.0)),
                    const SizedBox(width: 8),
                    _buildPresetChip('+5 kg', () => _addBeratPreset(5.0)),
                    const SizedBox(width: 8),
                    _buildPresetChip('+10 kg', () => _addBeratPreset(10.0)),
                    const SizedBox(width: 8),
                    _buildPresetChip('+25 kg', () => _addBeratPreset(25.0)),
                  ],
                ),

                const SizedBox(height: 20),

                _buildSectionHeader(
                  icon: Icons.payments_rounded,
                  title: 'Nilai Sampah (Otomatis)',
                  subtitle: 'Dihitung otomatis: Berat (kg) × Rp 5.000',
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F9F66), Color(0xFF0A754B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F9F66).withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimasi Total Nilai:',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormatter.format(_calculatedNilai),
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Rp 5.000 / kg',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _buildSectionHeader(
                  icon: Icons.camera_alt_rounded,
                  title: 'Foto Sampah / Penimbangan',
                  subtitle: 'Lampirkan foto sampah atau proses penimbangan',
                ),
                const SizedBox(height: 8),
                if (_selectedPhoto != null)
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.grey300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_selectedPhoto!, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                tooltip: 'Ganti Foto',
                                onPressed: _showImageSourceDialog,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                tooltip: 'Hapus Foto',
                                onPressed: () {
                                  setState(() {
                                    _selectedPhoto = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  InkWell(
                    onTap: _showImageSourceDialog,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.grey300,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_a_photo_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ambil Foto / Pilih dari Galeri',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kamera atau Galeri (Opsional)',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                _buildSectionHeader(
                  icon: Icons.notes_rounded,
                  title: 'Catatan Tambahan',
                  subtitle:
                      'Keterangan kondisi sampah atau rincian lainnya (opsional)',
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _catatanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Contoh: Sampah botol air mineral bersih hasil pilah warga RT 03...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textHint,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getJenisIconWidget(String jenis) {
    IconData icon;
    Color color;
    switch (jenis.toLowerCase()) {
      case 'organik':
        icon = Icons.eco_rounded;
        color = const Color(0xFF16A34A);
        break;
      case 'anorganik':
        icon = Icons.recycling_rounded;
        color = const Color(0xFF0284C7);
        break;
      case 'botol plastik':
        icon = Icons.local_drink_rounded;
        color = const Color(0xFF0284C7);
        break;
      case 'kardus':
        icon = Icons.inventory_2_rounded;
        color = const Color(0xFFD97706);
        break;
      case 'kertas':
        icon = Icons.newspaper_rounded;
        color = const Color(0xFF4F46E5);
        break;
      case 'plastik kemasan':
        icon = Icons.shopping_bag_rounded;
        color = const Color(0xFFDC2626);
        break;
      case 'campuran kering':
      default:
        icon = Icons.delete_sweep_rounded;
        color = const Color(0xFF059669);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}
