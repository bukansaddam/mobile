import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';

import '../../domain/entities/tokoh_entity.dart';
import '../bloc/tokoh_bloc/tokoh_bloc.dart';

import 'package:akar/features/linmas/demografi/institusi/presentation/bloc/institusi_bloc/institusi_bloc.dart';
import 'package:akar/features/linmas/demografi/organisasi/presentation/bloc/organisasi_bloc/organisasi_bloc.dart';

class AddTokohScreen extends StatefulWidget {
  final TokohEntity? initialTokoh;

  const AddTokohScreen({super.key, this.initialTokoh});

  @override
  State<AddTokohScreen> createState() => _AddTokohScreenState();
}

class _AddTokohScreenState extends State<AddTokohScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _jabatanInstitusiController =
      TextEditingController();
  final TextEditingController _jabatanOrganisasiController =
      TextEditingController();

  String _selectedJenisKelamin = DemografiConstants.defaultJenisKelamin;
  String _selectedProfesi = DemografiConstants.defaultProfesi;
  String _selectedAfiliasi = DemografiConstants.defaultAfiliasi;

  String _selectedInstitusi = 'Tidak Ada';
  int _selectedInstitusiId = 0;
  String _selectedOrganisasi = 'Tidak Ada';
  int _selectedOrganisasiId = 0;
  String? _selectedSuku;

  final List<String> _jenisKelaminOptions =
      DemografiConstants.jenisKelaminOptions;
  final List<String> _profesiOptions = DemografiConstants.profesiOptions;
  final List<String> _afiliasiOptions = DemografiConstants.afiliasiOptions;
  final List<String> _sukuOptions = DemografiConstants.sukuIndonesiaOptions;

  bool get _isEdit => widget.initialTokoh != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialTokoh != null) {
      final t = widget.initialTokoh!;
      _namaController.text = t.nama;
      _noTelpController.text = t.noTelp;
      _jabatanInstitusiController.text = t.jabatanInstitusi;
      _jabatanOrganisasiController.text = t.jabatanOrganisasi;
      if (_jenisKelaminOptions.contains(t.jenisKelamin)) {
        _selectedJenisKelamin = t.jenisKelamin;
      }
      if (_profesiOptions.contains(t.profesi)) {
        _selectedProfesi = t.profesi;
      }
      if (_afiliasiOptions.contains(t.afiliasi)) {
        _selectedAfiliasi = t.afiliasi;
      }
      if (t.namaInstitusi.isNotEmpty) {
        _selectedInstitusi = t.namaInstitusi;
      }
      _selectedInstitusiId = t.instituteId ?? 0;
      if (t.namaOrganisasi.isNotEmpty) {
        _selectedOrganisasi = t.namaOrganisasi;
      }
      _selectedOrganisasiId = t.organizationId ?? 0;
      if (t.suku.isNotEmpty && _sukuOptions.contains(t.suku)) {
        _selectedSuku = t.suku;
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noTelpController.dispose();
    _jabatanInstitusiController.dispose();
    _jabatanOrganisasiController.dispose();
    super.dispose();
  }

  void _showAddInstitusiDialog(
    BuildContext parentContext, {
    String? initialName,
  }) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: initialName ?? '');
    final alamatController = TextEditingController();
    String selectedScope = DemografiConstants.defaultInstitusiScope;
    const scopeOptions = DemografiConstants.institusiScopeOptions;
    final outerColors = parentContext.appColors;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: outerColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final colors = modalContext.appColors;
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colors.borderStrong,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tambah Institusi Baru',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: colors.textSecondary,
                              ),
                              onPressed: () => Navigator.pop(modalContext),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Nama Institusi', isRequired: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: namaController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama institusi wajib diisi';
                            }
                            return null;
                          },
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: Kantor Kelurahan / Puskesmas',
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Scope Institusi', isRequired: true),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: selectedScope,
                          dropdownColor: colors.surface,
                          items: scopeOptions.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedScope = val;
                              });
                            }
                          },
                          decoration: _buildInputDecoration(
                            hintText: 'Pilih Scope',
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Alamat Institusi', isRequired: false),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: alamatController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          maxLines: 2,
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: Jl. Merdeka No. 45 (Opsional)',
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              final newNama = namaController.text.trim();
                              parentContext.read<InstitusiBloc>().add(
                                CreateInstitusiEvent(
                                  nama: newNama,
                                  scope: selectedScope,
                                  alamat: alamatController.text.trim().isEmpty
                                      ? null
                                      : alamatController.text.trim(),
                                ),
                              );
                              setState(() {
                                _selectedInstitusi = newNama;
                              });
                              Navigator.pop(modalContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'SIMPAN INSTITUSI',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddOrganisasiDialog(
    BuildContext parentContext, {
    String? initialName,
  }) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: initialName ?? '');
    final jumlahAnggotaController = TextEditingController(text: '0');
    final alamatController = TextEditingController();
    String selectedBidang = DemografiConstants.defaultOrganisasiBidang;
    const bidangOptions = DemografiConstants.organisasiBidangOptions;
    final outerColors = parentContext.appColors;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: outerColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final colors = modalContext.appColors;
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(modalContext).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colors.borderStrong,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tambah Organisasi Baru',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: colors.textSecondary,
                              ),
                              onPressed: () => Navigator.pop(modalContext),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Nama Organisasi', isRequired: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: namaController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama organisasi wajib diisi';
                            }
                            return null;
                          },
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: Karang Taruna Karya Muda',
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildLabel(
                          'Perkiraan Jumlah Anggota',
                          isRequired: true,
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: jumlahAnggotaController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Jumlah anggota wajib diisi';
                            }
                            final parsed = int.tryParse(value.trim());
                            if (parsed == null || parsed < 0) {
                              return 'Masukkan jumlah anggota yang valid';
                            }
                            return null;
                          },
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: 50',
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildLabel('Bergerak di Bidang', isRequired: true),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: selectedBidang,
                          dropdownColor: colors.surface,
                          items: bidangOptions.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedBidang = val;
                              });
                            }
                          },
                          decoration: _buildInputDecoration(
                            hintText: 'Pilih Bidang',
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildLabel('Alamat Sekretariat', isRequired: false),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: alamatController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          maxLines: 2,
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: Balai Warga RW 03 (Opsional)',
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              final newNama = namaController.text.trim();
                              final jumlah =
                                  int.tryParse(
                                    jumlahAnggotaController.text.trim(),
                                  ) ??
                                  0;
                              parentContext.read<OrganisasiBloc>().add(
                                AddOrganisasiEvent(
                                  nama: newNama,
                                  jumlahAnggota: jumlah,
                                  bidang: selectedBidang,
                                  alamatSekretariat:
                                      alamatController.text.trim().isEmpty
                                      ? null
                                      : alamatController.text.trim(),
                                ),
                              );
                              setState(() {
                                _selectedOrganisasi = newNama;
                              });
                              Navigator.pop(modalContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'SIMPAN ORGANISASI',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSearchablePicker({
    required BuildContext context,
    required String title,
    required String hintSearch,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
    void Function(String searchText)? onAddNew,
  }) {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredList = List.from(options);
    final outerColors = context.appColors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: outerColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final colors = bottomSheetContext.appColors;
            final searchText = searchController.text.trim();
            final hasSearch = searchText.isNotEmpty;
            final exactMatch = options.any(
              (o) => o.toLowerCase() == searchText.toLowerCase(),
            );
            final showAddOptionAtTop =
                onAddNew != null && hasSearch && !exactMatch;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(bottomSheetContext).size.height * 0.75,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors.borderStrong,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            if (onAddNew != null)
                              InkWell(
                                onTap: () {
                                  Navigator.pop(bottomSheetContext);
                                  onAddNew(searchController.text.trim());
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline_rounded,
                                        size: 18,
                                        color: colors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Tambah Baru',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: searchController,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onChanged: (val) {
                            setModalState(() {
                              filteredList = options
                                  .where(
                                    (item) => item.toLowerCase().contains(
                                      val.trim().toLowerCase(),
                                    ),
                                  )
                                  .toList();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: hintSearch,
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textHint,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: colors.primary,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: colors.textHint,
                                    ),
                                    onPressed: () {
                                      searchController.clear();
                                      setModalState(() {
                                        filteredList = List.from(options);
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: colors.surfaceVariant,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: colors.divider),
                      Expanded(
                        child: filteredList.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 48,
                                        color: colors.textHint,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        hasSearch
                                            ? '"$searchText" tidak ditemukan'
                                            : 'Data tidak ditemukan',
                                        style: TextStyle(
                                          color: colors.textSecondary,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (onAddNew != null) ...[
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(bottomSheetContext);
                                            onAddNew(searchText);
                                          },
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            size: 18,
                                          ),
                                          label: Text(
                                            hasSearch
                                                ? 'Tambah "$searchText" Baru'
                                                : 'Tambah Baru',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colors.primary,
                                            foregroundColor: colors.onPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    filteredList.length +
                                    (showAddOptionAtTop ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (showAddOptionAtTop && index == 0) {
                                    return ListTile(
                                      leading: Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: colors.primary,
                                      ),
                                      title: Text(
                                        'Tambah "$searchText" Baru',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colors.primary,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(bottomSheetContext);
                                        onAddNew(searchText);
                                      },
                                    );
                                  }

                                  final actualIndex = showAddOptionAtTop
                                      ? index - 1
                                      : index;

                                  if (actualIndex < 0 ||
                                      actualIndex >= filteredList.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final item = filteredList[actualIndex];
                                  final isSelected = selectedValue == item;

                                  return ListTile(
                                    title: Text(
                                      item,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? colors.primary
                                            : colors.textPrimary,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? Icon(
                                            Icons.check_circle_rounded,
                                            color: colors.primary,
                                          )
                                        : null,
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.pop(bottomSheetContext);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      searchController.dispose();
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSuku == null || _selectedSuku!.isEmpty) {
      AppToast.showError(context, message: 'Suku wajib dipilih');
      return;
    }

    final finalInstitusi = _selectedInstitusi == 'Tidak Ada'
        ? ''
        : _selectedInstitusi;

    final finalOrganisasi = _selectedOrganisasi == 'Tidak Ada'
        ? ''
        : _selectedOrganisasi;

    final entity = TokohEntity(
      id: widget.initialTokoh?.id,
      nama: _namaController.text.trim(),
      noTelp: _noTelpController.text.trim(),
      jenisKelamin: _selectedJenisKelamin,
      profesi: _selectedProfesi,
      wilayah: widget.initialTokoh?.wilayah ?? 'Nasional',
      instituteId: _selectedInstitusi == 'Tidak Ada' ? 0 : _selectedInstitusiId,
      namaInstitusi: finalInstitusi,
      jabatanInstitusi: finalInstitusi.isNotEmpty
          ? _jabatanInstitusiController.text.trim()
          : '',
      afiliasi: _selectedAfiliasi,
      organizationId: _selectedOrganisasi == 'Tidak Ada'
          ? 0
          : _selectedOrganisasiId,
      namaOrganisasi: finalOrganisasi,
      jabatanOrganisasi: finalOrganisasi.isNotEmpty
          ? _jabatanOrganisasiController.text.trim()
          : '',
      suku: _selectedSuku!,
    );

    if (_isEdit) {
      context.read<TokohBloc>().add(
        UpdateTokohEvent(id: widget.initialTokoh!.id!, tokoh: entity),
      );
    } else {
      context.read<TokohBloc>().add(CreateTokohEvent(entity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TokohBloc, TokohState>(
          listener: (context, state) {
            if (state is TokohActionSuccess) {
              AppToast.showSuccess(context, message: state.message);
              Navigator.pop(context);
            } else if (state is TokohActionFailure) {
              AppToast.showError(context, message: state.message);
            }
          },
        ),
        BlocListener<InstitusiBloc, InstitusiState>(
          listener: (context, state) {
            if (state is InstitusiActionSuccess && state.institusi != null) {
              final newId = int.tryParse(state.institusi!.id ?? '') ?? 0;
              if (newId > 0 && state.institusi!.nama == _selectedInstitusi) {
                setState(() {
                  _selectedInstitusiId = newId;
                });
              }
            }
          },
        ),
        BlocListener<OrganisasiBloc, OrganisasiState>(
          listener: (context, state) {
            if (state is OrganisasiActionSuccess) {
              final newId = int.tryParse(state.organisasi.id ?? '') ?? 0;
              if (newId > 0 && state.organisasi.nama == _selectedOrganisasi) {
                setState(() {
                  _selectedOrganisasiId = newId;
                });
              }
            }
          },
        ),
      ],
      child: BlocBuilder<TokohBloc, TokohState>(
        builder: (context, state) {
          final colors = context.appColors;
          final institusiBloc = context.watch<InstitusiBloc>();
          final List<String> institusiListOptions = [
            'Tidak Ada',
            ...institusiBloc.listInstitusi.map((i) => i.nama),
          ];
          if (_selectedInstitusi != 'Tidak Ada' &&
              !institusiListOptions.contains(_selectedInstitusi)) {
            institusiListOptions.add(_selectedInstitusi);
          }

          final organisasiBloc = context.watch<OrganisasiBloc>();
          final List<String> organisasiListOptions = [
            'Tidak Ada',
            ...organisasiBloc.listOrganisasi.map((o) => o.nama),
          ];
          if (_selectedOrganisasi != 'Tidak Ada' &&
              !organisasiListOptions.contains(_selectedOrganisasi)) {
            organisasiListOptions.add(_selectedOrganisasi);
          }

          final bool showJabatanInstitusi = _selectedInstitusi != 'Tidak Ada';

          final bool showJabatanOrganisasi = _selectedOrganisasi != 'Tidak Ada';

          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppPageBar(
              title: _isEdit ? 'Ubah Data Tokoh' : 'Tambah Tokoh Baru',
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
                                    ? 'Perbarui formulir pendataan tokoh dengan data yang jujur & jelas agar proses demografi akurat.'
                                    : 'Isi formulir pendataan tokoh dengan data yang jujur & jelas agar proses demografi akurat.',
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
                      _buildLabel('Nama Tokoh', isRequired: true),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _namaController,
                        textCapitalization: TextCapitalization.words,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
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
                      _buildLabel('No. HP', isRequired: false),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _noTelpController,
                        keyboardType: TextInputType.phone,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: 081234567890 (Opsional)',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Jenis Kelamin', isRequired: true),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedJenisKelamin,
                        dropdownColor: colors.surface,
                        items: _jenisKelaminOptions.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedJenisKelamin = val;
                            });
                          }
                        },
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Jenis Kelamin',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Profesi', isRequired: true),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedProfesi,
                        dropdownColor: colors.surface,
                        items: _profesiOptions.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedProfesi = val;
                            });
                          }
                        },
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Profesi',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Institusi', isRequired: true),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _showSearchablePicker(
                          context: context,
                          title: 'Pilih Institusi',
                          hintSearch: 'Cari institusi...',
                          options: institusiListOptions,
                          selectedValue: _selectedInstitusi,
                          onSelected: (val) {
                            setState(() {
                              _selectedInstitusi = val;
                              if (val == 'Tidak Ada') {
                                _selectedInstitusiId = 0;
                              } else {
                                final inst = institusiBloc.listInstitusi
                                    .where((i) => i.nama == val)
                                    .firstOrNull;
                                _selectedInstitusiId =
                                    int.tryParse(inst?.id ?? '') ?? 0;
                              }
                            });
                          },
                          onAddNew: (searchQuery) {
                            _showAddInstitusiDialog(
                              context,
                              initialName: searchQuery,
                            );
                          },
                        ),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedInstitusi,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight:
                                        _selectedInstitusi != 'Tidak Ada'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (showJabatanInstitusi) ...[
                        const SizedBox(height: 14),
                        _buildLabel('Jabatan di Institusi', isRequired: false),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _jabatanInstitusiController,
                          textCapitalization: TextCapitalization.words,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: Kepala / Sekretaris (Opsional)',
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _buildLabel('Afiliasi', isRequired: true),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedAfiliasi,
                        dropdownColor: colors.surface,
                        items: _afiliasiOptions.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: colors.textPrimary,
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
                        decoration: _buildInputDecoration(
                          hintText: 'Pilih Afiliasi',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('Nama Organisasi', isRequired: true),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _showSearchablePicker(
                          context: context,
                          title: 'Pilih Organisasi',
                          hintSearch: 'Cari organisasi...',
                          options: organisasiListOptions,
                          selectedValue: _selectedOrganisasi,
                          onSelected: (val) {
                            setState(() {
                              _selectedOrganisasi = val;
                              if (val == 'Tidak Ada') {
                                _selectedOrganisasiId = 0;
                              } else {
                                final org = organisasiBloc.listOrganisasi
                                    .where((o) => o.nama == val)
                                    .firstOrNull;
                                _selectedOrganisasiId =
                                    int.tryParse(org?.id ?? '') ?? 0;
                              }
                            });
                          },
                          onAddNew: (searchQuery) {
                            _showAddOrganisasiDialog(
                              context,
                              initialName: searchQuery,
                            );
                          },
                        ),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedOrganisasi,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight:
                                        _selectedOrganisasi != 'Tidak Ada'
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showJabatanOrganisasi) ...[
                        const SizedBox(height: 14),
                        _buildLabel('Jabatan di Organisasi', isRequired: false),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _jabatanOrganisasiController,
                          textCapitalization: TextCapitalization.words,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: _buildInputDecoration(
                            hintText: 'Contoh: Ketua / Pembina (Opsional)',
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _buildLabel('Suku', isRequired: true),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _showSearchablePicker(
                          context: context,
                          title: 'Pilih Suku',
                          hintSearch: 'Cari suku (Jawa, Sunda, Batak...)...',
                          options: _sukuOptions,
                          selectedValue: _selectedSuku,
                          onSelected: (val) {
                            setState(() {
                              _selectedSuku = val;
                            });
                          },
                        ),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedSuku ?? 'Pilih Suku (Cari Suku)...',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: _selectedSuku != null
                                        ? colors.textPrimary
                                        : colors.textHint,
                                    fontWeight: _selectedSuku != null
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: colors.textSecondary,
                              ),
                            ],
                          ),
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
                    onPressed: state is TokohActionLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: state is TokohActionLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colors.onPrimary,
                            ),
                          )
                        : Text(
                            _isEdit ? 'SIMPAN PERUBAHAN' : 'SIMPAN TOKOH BARU',
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
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    final colors = context.appColors;
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(color: colors.error),
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
