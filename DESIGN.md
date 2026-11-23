# DESIGN.md: SISKAMLING (AKAR Mobile)

## Brand Identity & Direction

- **Product:** SISKAMLING (Aplikasi Keamanan & Aduan Lingkungan Rakyat / AKAR)
- **Users:** Petugas Linmas (pengamanan wilayah, ronda malam, jaga tanah, bank sampah, demografi, aktivasi, presensi, SOS) dan Masyarakat (layanan Dumas / pengaduan warga).
- **Visual Language:** Layanan publik yang tenang, terpercaya, kontras tinggi di luar ruangan, dan konsisten lintas fitur.
- **Dial:** `ENERGY 1 / RHYTHM 1 / MOTION 1` (tenang, terstruktur, transisi fungsional tanpa dekorasi berlebihan).

## Color System (`lib/core/theme/app_colors.dart`)

- **Core Palette:**
  - `AppColors.primary` (`#0D8E34`): Aksi primer, tombol utama, fokus input.
  - `AppColors.primaryDark` (`#114C30`): Teks & ikon beraksen hijau di atas latar terang atau gradien AppBar (menjamin kontras WCAG AA `>= 4.5:1`), serta status aktif tombol header.
  - `AppColors.secondary` (`#1E293B`): Aksen netral gelap pendukung & notifikasi feedback.
- **Background & Surfaces:**
  - `AppColors.background` (`#F4F6F9`): Alas kanvas utama aplikasi dan alas dasar di bawah gradien AppBar.
  - `AppColors.surface` / `AppColors.white` (`#FFFFFF`): Kartu, bottom sheet, dan panel input.
  - `AppColors.topHeaderGradient`: Gradien vertikal lembut `primary` (alpha `0.4`) menuju transparan di atas `AppColors.background` untuk memisahkan zona header tanpa garis keras.
- **Typography & Semantic Tokens:**
  - `AppColors.textPrimary` (`#1A1A2E`): Judul, label utama, dan ikon standar.
  - `AppColors.textSecondary` (`#4B5563`): Teks pendukung dan label tab pasif.
  - Semantic states: `success` (`#2E7D32`), `successLight` (`#E8F5E9`), `warning` (`#F57F17`), `warningDark` (`#92400E`), `warningLight` (`#FFF8E1`), `warningBorder` (`#FDE68A`), `error` (`#C62828`), `errorDark` (`#991B1B`), `errorLight` (`#FFEBEE`), `errorBorder` (`#FCA5A5`), `info` (`#0277BD`), `infoLight` (`#E1F5FE`).

## Typography (`lib/core/theme/app_text_styles.dart`)

- **Font Family:** `Roboto`
- **Header & Navigation Hierarchy:**
  - Shell Title (`CustomAppBar`): `AppTextStyles.headlineSmall` (`18px Bold`, `AppColors.textPrimary`).
  - Shell Role Subtitle (`CustomAppBar`): `AppTextStyles.labelSmall` disesuaikan ke `11px SemiBold`, `AppColors.primaryDark`.
  - Sub-Page Title (`AppPageBar`): Terpusat (`centerTitle: true`), `AppTextStyles.headlineSmall` (`18px Bold`, `AppColors.textPrimary`, 1 baris dengan elipsis).

## AppBar & Navigation Standards (`lib/core/widgets/`)

- **Main Shell (`CustomAppBar`):** Tinggi tetap `60dp` (`toolbarHeight: 60.0`), logo brand `38x38dp` radius `10dp` (`AppLogoBadge.dumas` / `AppLogoBadge.linmas`), dan tombol notifikasi dengan badge unread count reaktif.
- **Sub-Pages (`AppPageBar`):** Tinggi `kToolbarHeight` (`56dp`) + tinggi opsional `bottom` (misal `TabBar` `48dp`), alas `AppColors.background` di bawah `AppColors.topHeaderGradient` (kecuali layar gradient penuh Auth memakai `transparentBackground: true`).
- **Header Action & Back Buttons (`AppBarCircleButton`):** Visual lingkaran `36x36dp` tanpa border (`side: BorderSide.none`), latar `AppColors.white` (`0.9` alpha, atau `AppColors.primaryDark` saat `isActive`), dan area sentuh minimum aksesibel `48x48dp`, simetris `8dp` dari tepi kiri dan kanan.
- **Fullscreen / Camera / Media Exclusions:** `SplashScreen`, `WelcomeScreen`, `DisasterEmergencyWarningPage`, `KtpCameraPage`, `FullscreenImageViewer`, dan `FullscreenVideoViewer` dikecualikan dari `AppPageBar` standar.

## Dialog & Modal Standards (`lib/core/widgets/app_dialogs.dart`)

- **Floating Dialog (`AppDialogs`):** Seluruh dialog aplikasi wajib memakai `AppDialogs` (`showSuccess`, `showFailed`, `showConfirmation`, `showAlert`, `showLoading`, `showCustom`).
- **Geometri & Gerakan:** Posisi mengambang di `Alignment.bottomCenter`, margin luar `16dp`, lebar maksimum `440dp`, tinggi maksimum `85%` viewport, sudut kartu `BorderRadius.circular(32)`, blur latar `BackdropFilter(sigma: 5)` dengan scrim gelap `45%`, serta animasi slide-up + fade (`260ms`).
- **Larangan `showDialog` Mentah:** Fitur tidak boleh memanggil `showDialog` / `AlertDialog` / `Dialog` mentah secara langsung.
- **Pemisahan Peran Modal:** `showModalBottomSheet` tetap digunakan khusus untuk detail sheet, filter, form bersarang, dan pemilih opsi (`ImageSource`, dsb.), sedangkan picker tanggal/waktu native memakai `showDatePicker`, `showTimePicker`, dan `showDateRangePicker`.

## Button & Action Color Standards (`lib/core/theme/app_theme.dart`)

- **Primary CTA & FAB:** Seluruh tombol aksi utama (`ElevatedButton`, `FilledButton`, `FloatingActionButton`) wajib memakai `AppColors.primary` (`#0D8E34`) dengan teks/ikon `AppColors.white` (termasuk `filledButtonTheme` dan `floatingActionButtonTheme` di `AppTheme.lightTheme`).
- **Aksen Hijau Kontras (`AppColors.primaryDark`):** Dikhususkan hanya untuk teks, ikon, atau indikator aktif di atas latar terang atau gradien (seperti subtitle `CustomAppBar`, tab aktif `TabBar`, atau teks pada banner/tombol putih), bukan `backgroundColor` CTA primer.
- **Destructive & Emergency Actions:** Tombol hapus/bahaya/darurat memakai `AppColors.error` (`#C62828`) solid atau latar lembut `AppColors.errorLight` (`#FFEBEE`) dengan border `AppColors.errorBorder` (`#FCA5A5`) serta teks `AppColors.error` / `AppColors.errorDark`.
- **Neutral Secondary / Cancel Buttons:** Tombol batal atau tutup netral memakai foreground `AppColors.secondary` (atau `AppColors.textPrimary`) dan border `AppColors.grey300`.
