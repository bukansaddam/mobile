import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import '../../domain/entities/organisasi_entity.dart';
import '../bloc/organisasi_bloc/organisasi_bloc.dart';

class AddOrganisasiScreen extends StatefulWidget {
  final OrganisasiEntity? initialOrganisasi;

  const AddOrganisasiScreen({super.key, this.initialOrganisasi});

  @override
  State<AddOrganisasiScreen> createState() => _AddOrganisasiScreenState();
}

class _AddOrganisasiScreenState extends State<AddOrganisasiScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahAnggotaController =
      TextEditingController();
  final TextEditingController _alamatSekretariatController =
      TextEditingController();

  String _selectedBidang = DemografiConstants.defaultOrganisasiBidang;
  final List<String> _bidangOptions =
      DemografiConstants.organisasiBidangOptions;

  bool get _isEdit => widget.initialOrganisasi != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialOrganisasi != null) {
      final o = widget.initialOrganisasi!;
      _namaController.text = o.nama;
      _jumlahAnggotaController.text = o.jumlahAnggota > 0
          ? o.jumlahAnggota.toString()
          : '';
      _alamatSekretariatController.text = o.alamatSekretariat ?? '';
      if (_bidangOptions.contains(o.bidang)) {
        _selectedBidang = o.bidang;
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahAnggotaController.dispose();
    _alamatSekretariatController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final int jumlahAnggota =
        int.tryParse(_jumlahAnggotaController.text.trim()) ?? 0;

    if (_isEdit && widget.initialOrganisasi?.id != null) {
      context.read<OrganisasiBloc>().add(
        UpdateOrganisasiEvent(
          id: widget.initialOrganisasi!.id!,
          nama: _namaController.text.trim(),
          jumlahAnggota: jumlahAnggota,
          bidang: _selectedBidang,
          alamatSekretariat: _alamatSekretariatController.text.trim().isEmpty
              ? null
              : _alamatSekretariatController.text.trim(),
        ),
      );
    } else {
      context.read<OrganisasiBloc>().add(
        CreateOrganisasiEvent(
          nama: _namaController.text.trim(),
          jumlahAnggota: jumlahAnggota,
          bidang: _selectedBidang,
          alamatSekretariat: _alamatSekretariatController.text.trim().isEmpty
              ? null
              : _alamatSekretariatController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrganisasiBloc, OrganisasiState>(
      listener: (context, state) {
        if (state is OrganisasiActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
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
        } else if (state is OrganisasiActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is OrganisasiFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
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
            title: Text(
              _isEdit ? 'Ubah Data Organisasi' : 'Tambah Organisasi',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isEdit
                                    ? 'Perbarui formulir pendataan organisasi dengan data yang jujur & jelas agar proses demografi akurat.'
                                    : 'Isi formulir pendataan organisasi dengan data yang jujur & jelas agar proses demografi akurat.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Nama Organisasi', isRequired: true),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _namaController,
                        textCapitalization: TextCapitalization.words,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Karang Taruna RW 05',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama organisasi wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Bidang Organisasi', isRequired: true),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBidang,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Bidang Organisasi',
                        ),
                        items: _bidangOptions.map((b) {
                          return DropdownMenuItem(
                            value: b,
                            child: Text(
                              b,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBidang = val);
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildLabel(
                        'Estimasi Jumlah Anggota (Opsional)',
                        isRequired: false,
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _jumlahAnggotaController,
                        keyboardType: TextInputType.number,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: 35',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildLabel(
                        'Alamat Sekretariat (Opsional)',
                        isRequired: false,
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _alamatSekretariatController,
                        maxLines: 3,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Jl. Merpati No. 12, Balai Warga',
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state is OrganisasiActionLoading
                      ? null
                      : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state is OrganisasiActionLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'SIMPAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
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

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
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
