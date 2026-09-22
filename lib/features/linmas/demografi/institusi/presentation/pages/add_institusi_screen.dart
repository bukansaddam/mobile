import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import '../../domain/entities/institusi_entity.dart';
import '../bloc/institusi_bloc/institusi_bloc.dart';

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
  List<String> _scopeOptions = DemografiConstants.institusiScopeOptions;

  String _selectedKategori = DemografiConstants.defaultInstitusiKategori;
  int? _selectedCategoryId;
  List<String> _kategoriOptions = DemografiConstants.institusiKategoriOptions;

  bool get _isEdit => widget.initialInstitusi != null;

  List<String> get _safeKategoriOptions {
    final list = _kategoriOptions.toSet().toList();
    if (_selectedKategori.isNotEmpty && !list.contains(_selectedKategori)) {
      list.insert(0, _selectedKategori);
    }
    return list;
  }

  List<String> get _safeScopeOptions {
    final list = _scopeOptions.toSet().toList();
    if (_selectedScope.isNotEmpty && !list.contains(_selectedScope)) {
      list.insert(0, _selectedScope);
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    final institusiBloc = context.read<InstitusiBloc>();
    if (institusiBloc.categories.isEmpty &&
        !institusiBloc.isCategoriesLoading) {
      institusiBloc.add(const GetInstitusiCategoriesEvent());
    }
    _kategoriOptions = List<String>.from(institusiBloc.categoryOptions);

    if (widget.initialInstitusi != null) {
      final i = widget.initialInstitusi!;
      _namaController.text = i.nama;
      _alamatController.text = i.alamat ?? '';
      _selectedCategoryId = i.categoryId;
      final matchingScope = _scopeOptions.where(
        (s) =>
            s.toLowerCase().replaceAll('/', '_') ==
            i.scope.toLowerCase().replaceAll('/', '_'),
      );
      if (matchingScope.isNotEmpty) {
        _selectedScope = matchingScope.first;
      } else if (i.scope.trim().isNotEmpty) {
        _selectedScope = i.displayScope;
        if (!_scopeOptions.contains(_selectedScope)) {
          _scopeOptions = [_selectedScope, ..._scopeOptions];
        }
      }
      if (i.categoryId != null) {
        final match = institusiBloc.categories.where(
          (c) => c.id == i.categoryId,
        );
        if (match.isNotEmpty) {
          _selectedKategori = match.first.label;
        }
      }
      if (i.kategori != null && i.kategori!.trim().isNotEmpty) {
        _selectedKategori = i.displayKategori;
      }
      if (!_kategoriOptions.contains(_selectedKategori)) {
        _kategoriOptions.insert(0, _selectedKategori);
      }
    } else if (_kategoriOptions.isNotEmpty) {
      _selectedKategori = _kategoriOptions.first;
      final match = institusiBloc.categories.where(
        (c) => c.label.toLowerCase() == _selectedKategori.toLowerCase(),
      );
      if (match.isNotEmpty) {
        _selectedCategoryId = match.first.id;
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

    final bloc = context.read<InstitusiBloc>();
    int? catId = _selectedCategoryId;
    if (catId == null && _selectedKategori.isNotEmpty) {
      final match = bloc.categories.where(
        (c) => c.label.toLowerCase() == _selectedKategori.toLowerCase(),
      );
      if (match.isNotEmpty) {
        catId = match.first.id;
      }
    }
    catId ??= widget.initialInstitusi?.categoryId ?? 0;

    if (_isEdit && widget.initialInstitusi?.id != null) {
      bloc.add(
        UpdateInstitusiEvent(
          id: widget.initialInstitusi!.id!,
          nama: _namaController.text.trim(),
          scope: _selectedScope,
          kategori: _selectedKategori,
          categoryId: catId,
          alamat: _alamatController.text.trim().isEmpty
              ? null
              : _alamatController.text.trim(),
        ),
      );
    } else {
      bloc.add(
        CreateInstitusiEvent(
          nama: _namaController.text.trim(),
          scope: _selectedScope,
          kategori: _selectedKategori,
          categoryId: catId,
          alamat: _alamatController.text.trim().isEmpty
              ? null
              : _alamatController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstitusiBloc, InstitusiState>(
      listener: (context, state) {
        if (state is InstitusiLoaded &&
            state.categories != null &&
            state.categories!.isNotEmpty) {
          setState(() {
            final newOpts = context.read<InstitusiBloc>().categoryOptions;
            _kategoriOptions = List<String>.from(newOpts);
            if (_selectedKategori.isNotEmpty &&
                !_kategoriOptions.contains(_selectedKategori)) {
              _kategoriOptions.insert(0, _selectedKategori);
            }
            if (_selectedCategoryId != null) {
              final match = state.categories!.where(
                (c) => c.id == _selectedCategoryId,
              );
              if (match.isNotEmpty) {
                _selectedKategori = match.first.label;
              }
            } else if (_selectedKategori.isNotEmpty) {
              final match = state.categories!.where(
                (c) => c.label.toLowerCase() == _selectedKategori.toLowerCase(),
              );
              if (match.isNotEmpty) {
                _selectedCategoryId = match.first.id;
              }
            }
          });
        } else if (state is InstitusiActionSuccess) {
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
        } else if (state is InstitusiActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is InstitusiFailure) {
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
              _isEdit ? 'Ubah Data Institusi' : 'Tambah Institusi Baru',
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
                                    ? 'Perbarui formulir pendataan institusi dengan data yang jujur & jelas agar proses demografi akurat.'
                                    : 'Isi formulir pendataan institusi dengan data yang jujur & jelas agar proses demografi akurat.',
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
                      _buildLabel('Nama Institusi', isRequired: true),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _namaController,
                        textCapitalization: TextCapitalization.words,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText:
                              'Contoh: Kantor Kelurahan Sukamaju / Puskesmas',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama institusi wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Kategori Institusi', isRequired: true),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedKategori,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Kategori Institusi',
                        ),
                        items: _safeKategoriOptions.map((k) {
                          return DropdownMenuItem(
                            value: k,
                            child: Text(
                              k,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedKategori = val;
                              final match = context
                                  .read<InstitusiBloc>()
                                  .categories
                                  .where(
                                    (c) =>
                                        c.label.toLowerCase() ==
                                        val.toLowerCase(),
                                  );
                              if (match.isNotEmpty) {
                                _selectedCategoryId = match.first.id;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Scope Institusi', isRequired: true),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedScope,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Scope (Kelurahan - Nasional)',
                        ),
                        items: _safeScopeOptions.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedScope = val);
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      _buildLabel(
                        'Alamat Institusi (Opsional)',
                        isRequired: false,
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _alamatController,
                        maxLines: 3,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Jl. Merdeka No. 45, Kel. Sukamaju',
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
                  onPressed: state is InstitusiActionLoading
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
                  child: state is InstitusiActionLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
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
