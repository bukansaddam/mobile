import 'package:akar/features/activation/domain/entities/activation_activity.dart';

class DummyActivationData {
  static final List<ActivationActivity> activities = [
    ActivationActivity(
      id: 'act-01',
      title: 'Pemasangan Router & Sensor Posko Utama',
      category: ActivationCategory.pemasanganPerangkat,
      location: 'Kec. Coblong, Bandung',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 15),
      completedSteps: 3,
      totalSteps: 5,
      description:
          'Pemasangan infrastruktur jaringan router Wi-Fi posko utama dan integrasi sensor monitoring real-time untuk koordinasi wilayah.',
    ),
    ActivationActivity(
      id: 'act-02',
      title: 'Sosialisasi Door to Door Warga RT 04/RW 02',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Dago, Bandung',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 8, 3),
      endDate: DateTime(2026, 8, 18),
      completedSteps: 2,
      totalSteps: 4,
      description:
          'Kunjungan langsung dari rumah ke rumah warga untuk menyerap aspirasi serta mendata kebutuhan komunitas lokal.',
    ),
    ActivationActivity(
      id: 'act-03',
      title: 'Pemasangan Gateway LoRaWAN Wilayah Selatan',
      category: ActivationCategory.pemasanganPerangkat,
      location: 'Kec. Bandung Selatan, Bandung',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 20),
      endDate: DateTime(2026, 8, 5),
      completedSteps: 5,
      totalSteps: 5,
      description:
          'Penggelaran perangkat jaringan nirkabel LoRaWAN jarak jauh untuk menjangkau area transmisi sinyal antar posko desa.',
    ),
    ActivationActivity(
      id: 'act-04',
      title: 'Pendataan & Verifikasi Konstituen Kebangsaan',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Sekeloa, Bandung',
      status: ActivationStatus.dibatalkan,
      startDate: DateTime(2026, 7, 25),
      endDate: DateTime(2026, 8, 10),
      completedSteps: 1,
      totalSteps: 5,
      description:
          'Penjangkauan door to door yang dibatalkan karena pengalihan jadwal kegiatan prioritas wilayah.',
    ),
    ActivationActivity(
      id: 'act-05',
      title: 'Pemasangan Display LED Komando Desa C',
      category: ActivationCategory.pemasanganPerangkat,
      location: 'Kec. Lengkong, Bandung',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 25),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Instalasi papan informasi digital LED di pusat posko komando desa untuk update statistik secara berkala.',
    ),
    ActivationActivity(
      id: 'act-06',
      title: 'Kunjungan Tokoh Masyarakat & Posko RW 05',
      category: ActivationCategory.doorToDoor,
      location: 'Kec. Cidadap, Bandung',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 15),
      endDate: DateTime(2026, 7, 30),
      completedSteps: 4,
      totalSteps: 4,
      description:
          'Silaturahmi tokoh pemuda dan masyarakat lokal untuk koordinasi kegiatan gotong royong warga.',
    ),
  ];
}
