import 'package:equatable/equatable.dart';

/// Supported OS permissions required across Masyarakat and Petugas Linmas roles.
enum AppPermissionType {
  locationWhenInUse,
  locationAlways,
  camera,
  microphone,
  notification,
}

/// Role-specific metadata and copy for a single permission onboarding step.
class PermissionStepSpec extends Equatable {
  final AppPermissionType type;
  final String title;
  final String description;
  final String actionLabel;
  final String settingsHint;
  final String? disclosureNote;

  const PermissionStepSpec({
    required this.type,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.settingsHint,
    this.disclosureNote,
  });

  @override
  List<Object?> get props => [
        type,
        title,
        description,
        actionLabel,
        settingsHint,
        disclosureNote,
      ];
}

/// Ordered catalog of required permission steps per user role.
abstract class PermissionStepCatalog {
  static const List<PermissionStepSpec> _masyarakatSteps = [
    PermissionStepSpec(
      type: AppPermissionType.locationWhenInUse,
      title: 'Akses Lokasi',
      description:
          'Menentukan titik koordinat laporan aduan warga secara akurat agar petugas dapat merespons lokasi kejadian dengan cepat.',
      actionLabel: 'Izinkan Akses Lokasi',
      settingsHint:
          'Buka Pengaturan, pilih Izin, pilih Lokasi, lalu pilih Izinkan saat aplikasi digunakan.',
    ),
    PermissionStepSpec(
      type: AppPermissionType.camera,
      title: 'Akses Kamera',
      description:
          'Mengambil foto atau video bukti kejadian langsung saat membuat laporan pengaduan masyarakat.',
      actionLabel: 'Izinkan Akses Kamera',
      settingsHint:
          'Buka Pengaturan, pilih Izin, pilih Kamera, lalu pilih Izinkan.',
    ),
    PermissionStepSpec(
      type: AppPermissionType.notification,
      title: 'Izin Notifikasi',
      description:
          'Menerima peringatan darurat bencana/SOS serta pembaruan status penanganan aduan Anda secara real-time.',
      actionLabel: 'Izinkan Notifikasi',
      settingsHint:
          'Buka Pengaturan, pilih Notifikasi, lalu aktifkan notifikasi untuk aplikasi ini.',
    ),
  ];

  // locationWhenInUse must precede locationAlways because Android 11+ and iOS
  // reject background location requests until foreground location is granted.
  static const List<PermissionStepSpec> _linmasSteps = [
    PermissionStepSpec(
      type: AppPermissionType.locationWhenInUse,
      title: 'Akses Lokasi',
      description:
          'Mencatat posisi saat presensi, patroli ronda malam, pelaporan Jaga Tanah, Bank Sampah, dan aktivasi tombol darurat SOS.',
      actionLabel: 'Izinkan Akses Lokasi',
      settingsHint:
          'Buka Pengaturan, pilih Izin, pilih Lokasi, lalu pilih Izinkan saat aplikasi digunakan.',
    ),
    PermissionStepSpec(
      type: AppPermissionType.locationAlways,
      title: 'Lokasi Latar Belakang (24/7)',
      description:
          'Menjaga pelacakan komando dan rute patroli Linmas tetap terpantau secara aman meski layar terkunci atau aplikasi berjalan di latar belakang.',
      actionLabel: 'Izinkan Lokasi 24/7',
      settingsHint:
          'Buka Pengaturan, pilih Izin, pilih Lokasi, lalu pilih Izinkan sepanjang waktu atau Selalu.',
      disclosureNote:
          'Pada layar berikutnya, pilih Izinkan sepanjang waktu / Selalu agar pelacakan patroli tetap aktif di latar belakang.',
    ),
    PermissionStepSpec(
      type: AppPermissionType.camera,
      title: 'Akses Kamera',
      description:
          'Mendokumentasikan foto dan video kegiatan ronda malam, presensi lapangan, aktivasi pos, Jaga Tanah, dan Bank Sampah.',
      actionLabel: 'Izinkan Akses Kamera',
      settingsHint:
          'Buka Pengaturan, pilih Izin, pilih Kamera, lalu pilih Izinkan.',
    ),
    PermissionStepSpec(
      type: AppPermissionType.microphone,
      title: 'Akses Mikrofon',
      description:
          'Merekam dikte suara untuk mempercepat pengisian laporan harian (Laphar) saat bertugas di lapangan.',
      actionLabel: 'Izinkan Akses Mikrofon',
      settingsHint:
          'Buka Pengaturan, pilih Izin, pilih Mikrofon, lalu pilih Izinkan.',
    ),
    PermissionStepSpec(
      type: AppPermissionType.notification,
      title: 'Izin Notifikasi',
      description:
          'Menerima panggilan darurat SOS, peringatan bencana kritis, dan instruksi penugasan komando secara instan.',
      actionLabel: 'Izinkan Notifikasi',
      settingsHint:
          'Buka Pengaturan, pilih Notifikasi, lalu aktifkan notifikasi untuk aplikasi ini.',
    ),
  ];

  static List<PermissionStepSpec> stepsForRole({required bool isOfficer}) {
    return isOfficer ? _linmasSteps : _masyarakatSteps;
  }
}
