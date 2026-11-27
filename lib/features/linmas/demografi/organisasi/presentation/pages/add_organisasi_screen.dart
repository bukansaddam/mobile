import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';

import 'package:akar/features/linmas/demografi/organisasi/domain/entities/organisasi_entity.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/bloc/organisasi_bloc/organisasi_bloc.dart';

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
          AppToast.showSuccess(context, message: state.message);
          context.pop();
        } else if (state is OrganisasiActionFailure) {
          AppToast.showError(context, message: state.message);
        } else if (state is OrganisasiFailure) {
          AppToast.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final colors = context.appColors;
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppPageBar(
            title: _isEdit ? 'Ubah Data Organisasi' : 'Tambah Organisasi',
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
                          color: colors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: colors.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isEdit
                                    ? 'Perbarui formulir pendataan organisasi dengan data yang jujur & jelas agar proses demografi akurat.'
                                    : 'Isi formulir pendataan organisasi dengan data yang jujur & jelas agar proses demografi akurat.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colors.primaryDark,
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
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
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
                        dropdownColor: colors.surface,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Bidang Organisasi',
                        ),
                        items: _bidangOptions.map((b) {
                          return DropdownMenuItem(
                            value: b,
                            child: Text(
                              b,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
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
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
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
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
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
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.05),
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
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state is OrganisasiActionLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onPrimary,
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
    final colors = context.appColors;
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: colors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    final colors = context.appColors;
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: colors.textHint),
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
    );
  }
}
