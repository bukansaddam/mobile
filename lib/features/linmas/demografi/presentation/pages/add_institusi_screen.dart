import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import 'package:akar/features/linmas/demografi/domain/entities/institusi_entity.dart';
import 'package:akar/features/linmas/demografi/presentation/bloc/demografi_bloc/demografi_bloc.dart';

class AddInstitusiScreen extends StatefulWidget {
  final InstitusiEntity? initialInstitusi;

  const AddInstitusiScreen({super.key, this.initialInstitusi});

  @override
  State<AddInstitusiScreen> createState() => _AddInstitusiScreenState();
}

class _AddInstitusiScreenState extends State<AddInstitusiScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  String _selectedScope = DemografiConstants.defaultInstitusiScope;
  final List<String> _scopeOptions = DemografiConstants.institusiScopeOptions;

  bool get _isEdit => widget.initialInstitusi != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialInstitusi != null) {
      final inst = widget.initialInstitusi!;
      _namaController.text = inst.nama;
      _alamatController.text = inst.alamat ?? '';
      if (_scopeOptions.contains(inst.scope)) {
        _selectedScope = inst.scope;
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    context.read<DemografiBloc>().add(
      AddInstitusiEvent(
        nama: _namaController.text.trim(),
        scope: _selectedScope,
        alamat: _alamatController.text.trim().isEmpty
            ? null
            : _alamatController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DemografiBloc, DemografiState>(
      listener: (context, state) {
        if (state is DemografiLoadedState &&
            state.actionSuccessMessage == 'Institusi berhasil ditambahkan') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Institusi "${_namaController.text.trim()}" berhasil ditambahkan!',
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
        } else if (state is DemografiFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is DemografiLoadedState &&
            state.errorMessage != null &&
            !state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
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
              _isEdit ? 'Edit Data Institusi' : 'Tambah Institusi Baru',
              style: const TextStyle(
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
                                  ? 'Perbarui formulir pendataan institusi dengan valid agar informasi wilayah & alamat tepat.'
                                  : 'Isi formulir pendataan institusi dengan valid agar informasi wilayah & alamat tepat.',
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

                    // 1. Nama Institusi *
                    _buildLabel('Nama Institusi', isRequired: true),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _namaController,
                      textCapitalization: TextCapitalization.words,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama institusi wajib diisi';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        hintText:
                            'Contoh: Kantor Kelurahan Sukamaju / Puskesmas',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 2. Scope (Dropdown: Kelurahan - Nasional) *
                    _buildLabel('Scope Institusi', isRequired: true),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedScope,
                      items: _scopeOptions.map((item) {
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
                            _selectedScope = val;
                          });
                        }
                      },
                      decoration: _buildInputDecoration(
                        hintText: 'Pilih Scope (Kelurahan - Nasional)',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. Alamat Institusi (Opsional)
                    _buildLabel('Alamat Institusi', isRequired: false),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _alamatController,
                      maxLines: 3,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: _buildInputDecoration(
                        hintText:
                            'Contoh: Jl. Merdeka No. 45, Kel. Sukamaju (Opsional)',
                      ),
                    ),
                    const SizedBox(height: 24),
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isEdit
                              ? 'SIMPAN PERUBAHAN'
                              : 'SIMPAN INSTITUSI BARU',
                          style: const TextStyle(
                            fontSize: 15,
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
