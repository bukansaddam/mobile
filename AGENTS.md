# 🤖 AI Coding Assistant Guidelines (AGENTS.md)

File ini berisi instruksi dan batasan acuan (*guardrails*) untuk seluruh asisten AI (Antigravity, Cursor, Claude Code, GitHub Copilot, dll.) yang bekerja pada repositori `akar` (`AKAR_NARADATA/mobile`).

---

## 📌 Prinsip Utama Pengembangan (Grounding Rules)

### 1. Wajib Mengacu pada Dokumentasi Sebelum Menulis Kode
- **Sebelum membuat atau mengubah fitur**: Periksa dokumentasi proyek yang relevan di `docs/` (kontrak API, rencana eksekusi, audit keamanan) serta `DESIGN.md` untuk arahan visual.
- Jangan mengasumsikan alur kerja, validasi, atau skema API jika tidak tertulis di spesifikasi atau kode yang sudah ada. Jika ada ambiguitas atau perubahan endpoint/skema baru, tanyakan terlebih dahulu kepada pengguna.

### 2. Patuhi Arsitektur Proyek (Tier 2 — Clean Architecture + Pure BLoC)
Proyek `akar` menggunakan **Tier 2 (Enterprise Project - BLoC)**:
- Gunakan `flutter_bloc` murni (`Bloc<Event, State>`), **DILARANG** menggunakan `Cubit`.
- Struktur folder BLoC: `presentation/bloc/<nama>_bloc/` berisi 3 berkas (`<nama>_bloc.dart`, `<nama>_event.dart`, `<nama>_state.dart`) menggunakan direktif `part` & `part of`.
- State meng-extend `Equatable`.
- Struktur fitur: **3-layer Clean Architecture** (`presentation/` ↔ `domain/` ↔ `data/`). Layer `domain/` wajib **pure Dart** (dilarang import `flutter/*`, `dio`, `data/*`, atau `presentation/*`).
- Tempatkan logika bisnis di UseCase murni (`domain/usecases/`), inject UseCase di konstruktor BLoC, dan tangani via `on<Event>` dengan `result.fold`.
- Daftarkan dependensi di `lib/core/di/injection_container.dart` menggunakan `GetIt`.

### 3. Disiplin Import & File Generated
- **Wajib Package Import**: Selalu gunakan package import (`import 'package:akar/...';`), **DILARANG** menggunakan relative import (`import '../../...';`) di dalam `lib/` dan `test/` (kecuali `part` / `part of`).
- **Larangan Edit File Generated**: DILARANG memodifikasi file `*.g.dart` atau `*.freezed.dart` secara manual. Gunakan `dart run build_runner build --delete-conflicting-outputs`.

### 4. Keamanan Endpoint, Kredensial & Logging
- **Endpoint Obfuscation**: DILARANG menuliskan path API secara plaintext langsung di file fitur. Selalu gunakan `ApiConstants` / `EndpointSecurity` di `lib/core/constants/api_constants.dart`.
- **Environment Config**: Dilarang melakukan hardcode secret key atau base URL di kode Dart. Ambil melalui `String.fromEnvironment(...)` (`--dart-define-from-file=.env`).
- **Penyimpanan Kredensial**: DILARANG menyimpan `access_token`, `refresh_token`, PIN, atau data sensitif di `SharedPreferences` atau database lokal biasa. Wajib gunakan `FlutterSecureStorage`.
- **Standar Logging & Redaction**:
  - DILARANG menggunakan `print()` atau `debugPrint()` di seluruh codebase. Gunakan `AppLogger` (`package:akar/utils/app_logger.dart` atau `package:akar/core/utils/app_logger.dart`): `AppLogger.d()`, `AppLogger.i()`, `AppLogger.w()`, `AppLogger.e()`.
  - DILARANG mencetak password, PIN, OTP, NIK, atau token utuh ke dalam log.
- **Clean Session Wipe**: Saat pengguna logout atau terkena `401 Unauthorized` permanen, wajib menghapus seluruh sesi sensitif di penyimpanan lokal dan me-reset state di memori sebelum mengarahkan ke halaman Login.

### 5. Modularitas Widget, Reusability (DRY) & Penamaan Semantik
- **Gunakan Token Desain**:
  - Warna: `context.appColors` / `AppColors` (`lib/core/theme/`). Jangan gunakan `Color(0xFF...)` sembarangan di luar `lib/core/theme/`.
  - Tipografi: `AppTextStyles` (`lib/core/theme/app_text_styles.dart`).
- **Modularitas Widget Pragmatis (Hindari Over-Fragmentation)**:
  - **Ekstrak ke class `StatelessWidget`/`StatefulWidget` hanya jika ada manfaat nyata**: (1) dipakai ulang di `≥ 2` lokasi, (2) perlu isolasi rebuild/`const` di dalam `BlocBuilder`/animasi/list, (3) punya state/lifecycle sendiri, atau (4) blok UI besar (`> ~60–80` baris) sehingga membuat `build()` sulit dibaca.
  - **Potongan UI kecil (`< ~30` baris) khusus 1 layar** yang terikat erat ke `TextEditingController`/`_formKey`/`setState` lokal: BOLEH tetap inline di `build()` atau sebagai helper lokal ringkas agar mudah di-trace tanpa boilerplate constructor berlebihan.
  - **Penempatan widget hasil ekstraksi**:
    - Khusus 1 layar (`< ~60` baris, `StatelessWidget`, non-reusable): cukup sebagai private widget class (misal `class _OrderHeader extends StatelessWidget`) di file halaman yang sama.
    - Reusable (`≥ 2` lokasi), stateful, atau kompleks (`> ~60–80` baris): ekstrak menjadi 1 file per class di `presentation/widgets/` (fitur) atau `lib/core/widgets/` (lintas fitur).
  - *Catatan audit*: temuan `no_widget_helper_methods` dari `audit_scan.dart` diperlakukan sebagai indikator hotspot layar gemuk, bukan target wajib 0 jika ekstraksi justru menyulitkan tracing.
- **Mapper (Model ↔ Entity)**: Letakkan mapper di `data/mappers/<feature>_mapper.dart` atau sebagai `extension <Feature>ModelMapper on <Feature>Model` di bagian bawah `data/models/<feature>_model.dart`. DILARANG meletakkan mapper yang meng-import `data/models/` di dalam `domain/`.
- **Reuse vs Buat Baru**:
  - Sebelum membuat widget baru, wajib periksa `lib/core/widgets/`.
  - Jika perbedaannya hanya variasi kosmetik (warna, ukuran, teks, padding, radius, icon), gunakan widget yang ada dengan parameter opsional, `enum Variant`, atau *named constructor*.
- **Penamaan Semantik (Tanpa Angka)**: DILARANG menamai widget/class dengan urutan angka atau kata ambigu (`CustomTextField1`, `CardNew`). Gunakan nama deskriptif sesuai fungsinya.

### 6. Standar UX & Interaksi Wajib
- **Komponen Interaktif Inti**:
  - Gunakan komponen reusable inti di `lib/core/widgets/` (`CustomButton` anti-double-click, `CustomTextField`, `CustomSearchField` dengan debounce `500ms`, `CustomNetworkImage`, `state_views.dart`).
  - Untuk input sensitif (Password, PIN, OTP), pastikan `enableSuggestions: false`, `autocorrect: false`, dan `obscureText: true`.
- **Kelengkapan State UI**: Setiap halaman yang memuat data wajib menangani **Loading State**, **Empty State**, dan **Error State** (dengan tombol Retry).
- **Anti-Overflow Teks & Keyboard**:
  - Setiap `Text` dinamis di dalam `Row` wajib dibungkus `Expanded` atau `Flexible` serta diberi `maxLines` dan `overflow: TextOverflow.ellipsis`.
  - Setiap halaman berisi Form/TextField wajib scrollable dengan `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`.
- **SafeArea, RefreshIndicator & Tap Target**:
  - Semua tombol atau bar yang menempel di bagian bawah layar wajib dibungkus `SafeArea`.
  - Halaman daftar data dari API wajib mendukung tarik-untuk-menyegarkan (`RefreshIndicator`).
  - Area sentuh tombol atau icon interaktif minimal berukuran `48x48` dp.

### 7. Standar Performance, Error Handling & Lifecycle Safety
- **Lazy List Rendering**: DILARANG merender daftar data dinamis menggunakan `Column` atau `ListView(children: [...])`. Wajib gunakan `ListView.builder`, `ListView.separated`, atau `SliverList`.
- **Isolasi Rebuild State**: Letakkan `BlocBuilder` sedalam mungkin (hanya membungkus widget yang benar-benar berubah) dan gunakan `buildWhen` atau `context.select`.
- **Kemurnian `build()`**: Method `build()` harus murni berisi deklarasi UI. Dilarang melakukan sorting/filtering koleksi besar atau inisialisasi controller di dalam `build()`.
- **Lifecycle & Memory Safety**:
  - Wajib melakukan `dispose()` pada seluruh `TextEditingController`, `ScrollController`, `FocusNode`, `AnimationController`, dan `cancel()` pada `StreamSubscription`.
  - Wajib memeriksa `if (!context.mounted) return;` / `if (!mounted) return;` setelah operasi `await` sebelum menggunakan `BuildContext`.
- **Penanganan Error Terstruktur**: Tangani seluruh error menggunakan pola `Failure` (`lib/core/errors/`) dan tampilkan pesan yang ramah pengguna, bukan pesan exception teknis mentah.

### 8. Audit & Verifikasi Wajib Sebelum Selesai
Jalankan pemeriksaan berikut sebelum mengklaim perubahan selesai:
```bash
dart run .agents/skills/auditing-project-compliance/scripts/audit_scan.dart --target .
dart analyze
flutter test
```
