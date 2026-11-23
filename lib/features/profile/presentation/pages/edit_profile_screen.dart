import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:akar/core/theme/app_color_scheme.dart';
import 'package:akar/core/theme/app_text_styles.dart';
import 'package:akar/core/widgets/app_network_image.dart';
import 'package:akar/core/widgets/app_page_bar.dart';
import 'package:akar/core/widgets/app_toast.dart';
import 'package:akar/features/auth/domain/entities/auth_entity.dart';
import 'package:akar/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:akar/features/profile/domain/entities/update_profile_params.dart';
import 'package:akar/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nikController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _addressController;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isChangePasswordExpanded = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;
  bool _hasPopped = false;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    final authState = context.read<AuthBloc>().state;
    final UserEntity? user =
        profileState.user ??
        (authState is AuthAuthenticated ? authState.user : null);

    _nameController = TextEditingController(text: user?.name ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _nikController = TextEditingController(text: user?.nik ?? '');
    _birthDateController = TextEditingController(text: user?.birthDate ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nikController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = picked;
        });
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(
          context,
          message: 'Gagal memilih gambar. Pastikan izin akses telah diberikan.',
        );
      }
    }
  }

  void _showImagePickerModal() {
    final colors = context.appColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final sheetColors = sheetContext.appColors;
        return Material(
          color: sheetColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: sheetColors.borderStrong,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Ubah Foto Profil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: sheetColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildModalActionTile(
                    colors: sheetColors,
                    icon: Icons.camera_alt_outlined,
                    iconColor: sheetColors.primary,
                    iconBgColor: sheetColors.primaryLight,
                    title: 'Ambil dari Kamera',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const SizedBox(height: 6),
                  _buildModalActionTile(
                    colors: sheetColors,
                    icon: Icons.photo_library_outlined,
                    iconColor: sheetColors.primary,
                    iconBgColor: sheetColors.primaryLight,
                    title: 'Pilih dari Galeri',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 6),
                    _buildModalActionTile(
                      colors: sheetColors,
                      icon: Icons.delete_outline_rounded,
                      iconColor: sheetColors.error,
                      iconBgColor: sheetColors.errorLight,
                      title: 'Hapus Foto Baru',
                      textColor: sheetColors.error,
                      onTap: () {
                        Navigator.pop(sheetContext);
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalActionTile({
    required AppColorScheme colors,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? colors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textHint,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    DateTime initial = DateTime(1995, 1, 1);
    if (_birthDateController.text.trim().isNotEmpty) {
      try {
        initial = DateTime.parse(_birthDateController.text.trim());
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final colors = context.appColors;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                (colors.isDark
                        ? const ColorScheme.dark()
                        : const ColorScheme.light())
                    .copyWith(
                      primary: colors.primary,
                      onPrimary: colors.onPrimary,
                      surface: colors.surface,
                      onSurface: colors.textPrimary,
                    ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _handleSubmit() {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentPass = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (newPass.isNotEmpty && currentPass.isEmpty) {
      AppToast.showWarning(
        context,
        message: 'Masukkan kata sandi saat ini untuk mengubah kata sandi.',
      );
      return;
    }

    if (newPass.isNotEmpty && newPass != confirmPass) {
      AppToast.showWarning(
        context,
        message: 'Konfirmasi kata sandi baru tidak cocok.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final params = UpdateProfileParams(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      nik: _nikController.text.trim().isEmpty
          ? null
          : _nikController.text.trim(),
      birthDate: _birthDateController.text.trim().isEmpty
          ? null
          : _birthDateController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      profilePic: _selectedImage != null ? File(_selectedImage!.path) : null,
      currentPassword: currentPass.isEmpty ? null : currentPass,
      password: newPass.isEmpty ? null : newPass,
      passwordConfirmation: confirmPass.isEmpty ? null : confirmPass,
    );

    context.read<ProfileBloc>().add(UpdateProfileEvent(params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateError) {
          setState(() {
            _isSubmitting = false;
          });
          AppToast.showError(context, message: state.message);
          context.read<ProfileBloc>().add(ClearProfileStatusEvent());
        } else if (state is ProfileUpdateSuccess) {
          if (_hasPopped) return;
          _hasPopped = true;
          context.read<ProfileBloc>().add(ClearProfileStatusEvent());
          AppToast.showSuccess(context, message: state.message);
          Future.delayed(const Duration(milliseconds: 250), () {
            if (mounted && context.mounted) {
              if (context.canPop()) {
                context.pop(true);
              } else {
                Navigator.of(context).maybePop(true);
              }
            }
          });
        }
      },
      builder: (context, state) {
        final bool isUpdating = state is ProfileUpdating;
        final authState = context.watch<AuthBloc>().state;
        final UserEntity? currentUser =
            state.user ??
            (authState is AuthAuthenticated ? authState.user : null);

        final colors = context.appColors;
        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppPageBar(
            title: 'Edit Profil',
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatarPicker(colors, currentUser),
                    const SizedBox(height: 24),

                    _buildSectionContainer(
                      colors: colors,
                      title: 'Data Pribadi',
                      icon: Icons.person_outline_rounded,
                      children: [
                        _buildFieldLabel(
                          colors,
                          'Nama Lengkap',
                          isRequired: true,
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                          decoration: _inputDecoration(
                            colors: colors,
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.person_outline_rounded,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Nama lengkap wajib diisi';
                            }
                            if (val.trim().length < 2) {
                              return 'Nama terlalu pendek';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel(colors, 'Username', isRequired: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                          decoration: _inputDecoration(
                            colors: colors,
                            hint: 'Masukkan username',
                            icon: Icons.alternate_email_rounded,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Username wajib diisi';
                            }
                            if (val.trim().length < 3) {
                              return 'Username minimal 3 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel(colors, 'Email', isRequired: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                          decoration: _inputDecoration(
                            colors: colors,
                            hint: 'contoh@email.com',
                            icon: Icons.email_outlined,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }
                            final regex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!regex.hasMatch(val.trim())) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel(colors, 'Nomor Telepon'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                          decoration: _inputDecoration(
                            colors: colors,
                            hint: '08xxxxxxxxxx',
                            icon: Icons.phone_outlined,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel(
                          colors,
                          'NIK (Nomor Induk Kependudukan)',
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nikController,
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                          decoration: _inputDecoration(
                            colors: colors,
                            hint: '16 digit NIK',
                            icon: Icons.badge_outlined,
                          ).copyWith(counterText: ''),
                          validator: (val) {
                            if (val != null &&
                                val.isNotEmpty &&
                                val.length != 16) {
                              return 'NIK harus 16 digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel(colors, 'Tanggal Lahir'),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _pickBirthDate,
                          borderRadius: BorderRadius.circular(12),
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: _birthDateController,
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textPrimary,
                              ),
                              decoration:
                                  _inputDecoration(
                                    colors: colors,
                                    hint: 'Pilih tanggal lahir (YYYY-MM-DD)',
                                    icon: Icons.calendar_today_outlined,
                                  ).copyWith(
                                    suffixIcon: Icon(
                                      Icons.date_range_rounded,
                                      color: colors.primary,
                                      size: 20,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel(colors, 'Alamat Lengkap'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Nama jalan, RT/RW, nomor rumah...',
                            hintStyle: TextStyle(
                              color: colors.textHint,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: colors.surfaceVariant,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colors.borderStrong,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: colors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildSecurityCard(colors),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (isUpdating || _isSubmitting)
                            ? null
                            : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          disabledBackgroundColor: colors.primary.withAlpha(
                            120,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isUpdating
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colors.onPrimary,
                                  ),
                                ),
                              )
                            : const Text(
                                'SIMPAN PERUBAHAN',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarPicker(AppColorScheme colors, UserEntity? currentUser) {
    final name = currentUser?.name?.trim();
    final initials = (name != null && name.isNotEmpty)
        ? name
              .split(' ')
              .where((w) => w.isNotEmpty)
              .map((w) => w[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'U';

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryLight,
                border: Border.all(color: colors.surface, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(
                        File(_selectedImage!.path),
                        width: 104,
                        height: 104,
                        fit: BoxFit.cover,
                      )
                    : (currentUser?.displayProfilePic != null)
                    ? AppNetworkImage(
                        imageUrl: currentUser!.displayProfilePic!,
                        width: 104,
                        height: 104,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(52),
                      )
                    : Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: colors.primaryDark,
                          ),
                        ),
                      ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _showImagePickerModal,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.surface, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colors.onPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: _showImagePickerModal,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              'Ganti Foto Profil',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContainer({
    required AppColorScheme colors,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
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
                  color: colors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSecurityCard(AppColorScheme colors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: _isChangePasswordExpanded,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            onExpansionChanged: (val) {
              setState(() {
                _isChangePasswordExpanded = val;
              });
            },
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: colors.primary,
                size: 18,
              ),
            ),
            title: Text(
              'Ubah Kata Sandi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            subtitle: Text(
              'Opsional, buka untuk mengatur sandi baru',
              style: TextStyle(fontSize: 12, color: colors.textMuted),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: colors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Kosongkan kolom sandi jika Anda tidak ingin mengubah kata sandi.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _buildFieldLabel(colors, 'Kata Sandi Saat Ini'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
                decoration:
                    _inputDecoration(
                      colors: colors,
                      hint: 'Masukkan kata sandi saat ini',
                      icon: Icons.lock_clock_outlined,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.textHint,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                    ),
              ),
              const SizedBox(height: 16),

              _buildFieldLabel(colors, 'Kata Sandi Baru'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
                decoration:
                    _inputDecoration(
                      colors: colors,
                      hint: 'Minimal 8 karakter',
                      icon: Icons.key_outlined,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.textHint,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                validator: (val) {
                  if (val != null && val.isNotEmpty && val.length < 8) {
                    return 'Kata sandi minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildFieldLabel(colors, 'Konfirmasi Kata Sandi Baru'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
                decoration:
                    _inputDecoration(
                      colors: colors,
                      hint: 'Ulangi kata sandi baru',
                      icon: Icons.check_circle_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.textHint,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(
    AppColorScheme colors,
    String label, {
    bool isRequired = false,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: label,
          style: AppTextStyles.labelLarge.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          children: isRequired
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: colors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required AppColorScheme colors,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.textHint, fontSize: 13.5),
      prefixIcon: Icon(icon, color: colors.textMuted, size: 20),
      filled: true,
      fillColor: colors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
    );
  }
}
