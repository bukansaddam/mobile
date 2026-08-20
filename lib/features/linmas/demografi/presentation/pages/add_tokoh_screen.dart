import 'package:akar/core/theme/app_colors.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:akar/features/linmas/demografi/core/constants/demografi_constants.dart';
import 'package:akar/features/linmas/demografi/presentation/bloc/demografi_bloc/demografi_bloc.dart';

class AddTokohScreen extends StatefulWidget {
  const AddTokohScreen({super.key});

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
  String _selectedOrganisasi = 'Tidak Ada';
  String? _selectedSuku;

  final List<String> _jenisKelaminOptions =
      DemografiConstants.jenisKelaminOptions;
  final List<String> _profesiOptions = DemografiConstants.profesiOptions;
  final List<String> _afiliasiOptions = DemografiConstants.afiliasiOptions;
  final List<String> _sukuOptions = DemografiConstants.sukuIndonesiaOptions;

  @override
  void dispose() {
    _namaController.dispose();
    _noTelpController.dispose();
    _jabatanInstitusiController.dispose();
    _jabatanOrganisasiController.dispose();
    super.dispose();
  }

  void _showSukuPicker(BuildContext context) {
    final TextEditingController searchSukuController = TextEditingController();
    List<String> filteredSukuList = List.from(_sukuOptions);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                            color: AppColors.grey300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              'Pilih Suku',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: searchSukuController,
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          onChanged: (val) {
                            setModalState(() {
                              filteredSukuList = _sukuOptions
                                  .where(
                                    (s) => s.toLowerCase().contains(
                                      val.trim().toLowerCase(),
                                    ),
                                  )
                                  .toList();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari suku (Jawa, Sunda, Batak...)...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey500,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.primary,
                            ),
                            suffixIcon: searchSukuController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      color: AppColors.grey500,
                                    ),
                                    onPressed: () {
                                      searchSukuController.clear();
                                      setModalState(() {
                                        filteredSukuList = List.from(
                                          _sukuOptions,
                                        );
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: AppColors.grey100,
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
                      const Divider(height: 1, color: AppColors.grey200),
                      Expanded(
                        child: filteredSukuList.isEmpty
                            ? const Center(
                                child: Text(
                                  'Suku tidak ditemukan',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredSukuList.length,
                                itemBuilder: (context, index) {
                                  final suku = filteredSukuList[index];
                                  final isSelected = _selectedSuku == suku;

                                  return ListTile(
                                    title: Text(
                                      suku,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.primary,
                                          )
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedSuku = suku;
                                      });
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
      searchSukuController.dispose();
    });
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSuku == null || _selectedSuku!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Suku wajib dipilih'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final finalInstitusi = _selectedInstitusi == 'Tidak Ada'
        ? ''
        : _selectedInstitusi;

    final finalOrganisasi = _selectedOrganisasi == 'Tidak Ada'
        ? ''
        : _selectedOrganisasi;

    context.read<DemografiBloc>().add(
      AddTokohEvent(
        nama: _namaController.text.trim(),
        noTelp: _noTelpController.text.trim(),
        jenisKelamin: _selectedJenisKelamin,
        profesi: _selectedProfesi,
        namaInstitusi: finalInstitusi,
        jabatanInstitusi: finalInstitusi.isNotEmpty
            ? _jabatanInstitusiController.text.trim()
            : '',
        afiliasi: _selectedAfiliasi,
        namaOrganisasi: finalOrganisasi,
        jabatanOrganisasi: finalOrganisasi.isNotEmpty
            ? _jabatanOrganisasiController.text.trim()
            : '',
        suku: _selectedSuku!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DemografiBloc, DemografiState>(
      listener: (context, state) {
        if (state.status == DemografiStatus.success) {
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
        } else if (state.status == DemografiStatus.failure &&
            state.errorMessage != null) {
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
        // Dynamic Options from Tab lists (Full Unfiltered Lists)
        final List<String> institusiListOptions = [
          'Tidak Ada',
          ...state.institusiList.map((i) => i.nama),
        ];

        final List<String> organisasiListOptions = [
          'Tidak Ada',
          ...state.organisasiList.map((o) => o.nama),
        ];

        final bool showJabatanInstitusi = _selectedInstitusi != 'Tidak Ada';

        final bool showJabatanOrganisasi = _selectedOrganisasi != 'Tidak Ada';

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
                              'Isi formulir pendataan tokoh dengan data yang jujur & jelas agar proses demografi akurat.',
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

                    // 1. Nama Tokoh *
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

                    // 2. No. HP (Opsional)
                    _buildLabel('No. HP', isRequired: false),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _noTelpController,
                      keyboardType: TextInputType.phone,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: _buildInputDecoration(
                        hintText: 'Contoh: 081234567890 (Opsional)',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 3. Jenis Kelamin (Dropdown) *
                    _buildLabel('Jenis Kelamin', isRequired: true),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedJenisKelamin,
                      items: _jenisKelaminOptions.map((item) {
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
                            _selectedJenisKelamin = val;
                          });
                        }
                      },
                      decoration: _buildInputDecoration(
                        hintText: 'Pilih Jenis Kelamin',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 4. Profesi (Dropdown) *
                    _buildLabel('Profesi', isRequired: true),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedProfesi,
                      items: _profesiOptions.map((item) {
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
                            _selectedProfesi = val;
                          });
                        }
                      },
                      decoration: _buildInputDecoration(
                        hintText: 'Pilih Profesi',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 5. Institusi (Dropdown dari list tab institusi - hanya title) *
                    _buildLabel('Institusi', isRequired: true),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedInstitusi,
                      items: institusiListOptions.map((item) {
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
                            _selectedInstitusi = val;
                          });
                        }
                      },
                      decoration: _buildInputDecoration(
                        hintText: 'Pilih Institusi',
                      ),
                    ),

                    // - Jabatan di Institusi (Opsional) - keluar setelah memilih institusi
                    if (showJabatanInstitusi) ...[
                      const SizedBox(height: 14),
                      _buildLabel('Jabatan di Institusi', isRequired: false),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _jabatanInstitusiController,
                        textCapitalization: TextCapitalization.words,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Kepala / Sekretaris (Opsional)',
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),

                    // 6. Afiliasi (Dropdown) *
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
                      decoration: _buildInputDecoration(
                        hintText: 'Pilih Afiliasi',
                      ),
                    ),
                    const SizedBox(height: 18),

                    // 7. Nama Organisasi (Dropdown dari list tab organisasi - hanya title) *
                    _buildLabel('Nama Organisasi', isRequired: true),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedOrganisasi,
                      items: organisasiListOptions.map((item) {
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
                            _selectedOrganisasi = val;
                          });
                        }
                      },
                      decoration: _buildInputDecoration(
                        hintText: 'Pilih Organisasi',
                      ),
                    ),

                    // - Jabatan di Organisasi (Opsional) - keluar setelah memilih organisasi
                    if (showJabatanOrganisasi) ...[
                      const SizedBox(height: 14),
                      _buildLabel('Jabatan di Organisasi', isRequired: false),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _jabatanOrganisasiController,
                        textCapitalization: TextCapitalization.words,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Ketua / Pembina (Opsional)',
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),

                    // 8. Suku (Dropdown semua suku di Indonesia & berikan search) *
                    _buildLabel('Suku', isRequired: true),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () => _showSukuPicker(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _selectedSuku != null
                                ? const Color(0xFFE2E8F0)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedSuku ?? 'Pilih Suku (Cari Suku)...',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _selectedSuku != null
                                    ? AppColors.textPrimary
                                    : const Color(0xFF94A3B8),
                                fontWeight: _selectedSuku != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: AppColors.grey600,
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
                      : const Text(
                          'SIMPAN TOKOH BARU',
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
