import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
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
          AppToast.showSuccess(context, message: state.message);
          context.pop();
        } else if (state is InstitusiActionFailure) {
          AppToast.showError(context, message: state.message);
        } else if (state is InstitusiFailure) {
          AppToast.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        final colors = context.appColors;
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppPageBar(
            title: _isEdit ? 'Ubah Data Institusi' : 'Tambah Institusi Baru',
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
                                    ? 'Perbarui formulir pendataan institusi dengan data yang jujur & jelas agar proses demografi akurat.'
                                    : 'Isi formulir pendataan institusi dengan data yang jujur & jelas agar proses demografi akurat.',
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
                      _buildLabel('Nama Institusi', isRequired: true),
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
                        dropdownColor: colors.surface,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Kategori Institusi',
                        ),
                        items: _safeKategoriOptions.map((k) {
                          return DropdownMenuItem(
                            value: k,
                            child: Text(
                              k,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
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
                        dropdownColor: colors.surface,
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Scope (Kelurahan - Nasional)',
                        ),
                        items: _safeScopeOptions.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
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
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
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
                  onPressed: state is InstitusiActionLoading
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
                  child: state is InstitusiActionLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onPrimary,
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
