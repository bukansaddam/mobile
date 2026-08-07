import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../provider/profiling_provider.dart';

class AddTokohScreen extends StatefulWidget {
  const AddTokohScreen({super.key});

  @override
  State<AddTokohScreen> createState() => _AddTokohScreenState();
}

class _AddTokohScreenState extends State<AddTokohScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _namaOrganisasiController =
      TextEditingController();

  String _selectedWilayah = 'Lokal';
  String _selectedAfiliasi = 'Politik';

  final List<String> _wilayahOptions = ['Lokal', 'Nasional'];
  final List<String> _afiliasiOptions = ['Politik', 'Agama', 'Suku', 'Pemuda'];

  @override
  void dispose() {
    _namaController.dispose();
    _noTelpController.dispose();
    _namaOrganisasiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfilingProvider>();

    final success = await provider.addTokoh(
      nama: _namaController.text.trim(),
      noTelp: _noTelpController.text.trim(),
      wilayah: _selectedWilayah,
      afiliasi: _selectedAfiliasi,
      namaOrganisasi: _namaOrganisasiController.text.trim(),
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
                  'Tokoh "${_namaController.text.trim()}" berhasil ditambahkan!',
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
            provider.errorMessage ?? 'Gagal menambahkan data tokoh.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Tambah Tokoh Baru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
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
                  padding: const EdgeInsets.all(16),
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
                          'Isi formulir pendataan tokoh dengan data yang jujur & jelas agar proses profiling akurat.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF1E5BB4),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel('Nama Tokoh', isRequired: true),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _namaController,
                  textCapitalization: TextCapitalization.words,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tokoh wajib diisi';
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    hintText: 'Contoh: H. Ahmad Subardjo',
                  ),
                ),
                const SizedBox(height: 18),

                _buildLabel('No. Telepon', isRequired: true),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _noTelpController,
                  keyboardType: TextInputType.phone,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor telepon wajib diisi';
                    }
                    if (value.trim().length < 8) {
                      return 'Nomor telepon minimal 8 digit';
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    hintText: 'Contoh: 081234567890',
                  ),
                ),
                const SizedBox(height: 18),

                _buildLabel('Wilayah', isRequired: true),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedWilayah,
                  items: _wilayahOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedWilayah = val;
                      });
                    }
                  },
                  decoration: _buildInputDecoration(hintText: 'Pilih Wilayah'),
                ),
                const SizedBox(height: 18),

                _buildLabel('Afiliasi', isRequired: true),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedAfiliasi,
                  items: _afiliasiOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedAfiliasi = val;
                      });
                    }
                  },
                  decoration: _buildInputDecoration(hintText: 'Pilih Afiliasi'),
                ),
                const SizedBox(height: 18),

                _buildLabel('Nama Organisasi (Opsional)', isRequired: false),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _namaOrganisasiController,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: _buildInputDecoration(
                    hintText: 'Contoh: Majelis Taklim / DPC Partai X',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Consumer<ProfilingProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: provider.isSubmitting ? null : _submitForm,
                  icon: provider.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 20),
                  label: Text(
                    provider.isSubmitting
                        ? 'MENYIMPAN...'
                        : 'SIMPAN TOKOH BARU',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9F66),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }
}
