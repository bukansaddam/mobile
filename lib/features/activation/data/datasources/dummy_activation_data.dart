import 'package:akar/features/activation/domain/entities/activation_activity.dart';

class DummyActivationData {
  static final List<ActivationActivity> activities = [
    ActivationActivity(
      id: 'act-01',
      title: 'Pemasangan Router & Sensor Posko Utama',
      category: ActivationCategory.pemasanganPerangkat,
      location: 'Kec. Coblong, Bandung',
      address: 'Jl. Ir. H. Juanda No. 128, Dago, Kec. Coblong, Kota Bandung',
      ownerName: 'Ahmad Ridwan (PJ Teknis Posko)',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 15),
      completedSteps: 3,
      totalSteps: 5,
      description:
          'Pemasangan infrastruktur jaringan router Wi-Fi posko utama dan integrasi sensor monitoring real-time untuk koordinasi wilayah.',
      notes:
          'Pastikan stopkontak daya AC dilindungi kotak waterproof outdoor dan kabel LAN terikat rapi.',
      reports: [
        ActivationReport(
          id: 'rep-01',
          photoUrl:
              'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
          submittedAt: DateTime(2026, 8, 2, 10, 30),
          latitude: -6.8915,
          longitude: 107.6107,
          notes: 'Instalasi braket dinding luar posko selesai.',
        ),
        ActivationReport(
          id: 'rep-02',
          photoUrl:
              'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
          submittedAt: DateTime(2026, 8, 4, 14, 15),
          latitude: -6.8920,
          longitude: 107.6112,
          notes: 'Koneksi router Mikrotik utama aktif dan teruji.',
        ),
        ActivationReport(
          id: 'rep-03',
          photoUrl:
              'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400',
          submittedAt: DateTime(2026, 8, 6, 09, 45),
          latitude: -6.8925,
          longitude: 107.6118,
          notes: 'Sensor suhu dan kelembaban outdoor aktif.',
        ),
      ],
    ),
    ActivationActivity(
      id: 'act-02',
      title: 'Sosialisasi Door to Door Warga RT 04/RW 02',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Dago, Bandung',
      address: 'RT 04 / RW 02 Kelurahan Dago, Kec. Coblong, Bandung',
      ownerName: 'Siti Nurhaliza (Koordinator Lapangan)',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 8, 3),
      endDate: DateTime(2026, 8, 18),
      completedSteps: 2,
      totalSteps: 4,
      description:
          'Kunjungan langsung dari rumah ke rumah warga untuk menyerap aspirasi serta mendata kebutuhan komunitas lokal.',
      notes:
          'Wajib menyapa dengan ramah, membawa formulir fisik dan aplikasi mobile, serta mencatat NIK penerima paket edukasi.',
      reports: [
        ActivationReport(
          id: 'rep-04',
          photoUrl:
              'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
          submittedAt: DateTime(2026, 8, 4, 11, 20),
          latitude: -6.8850,
          longitude: 107.6150,
          recipientName: 'Budi Santoso',
          recipientNik: '3273011204850001',
          notes: 'Penerima menyambut baik sosialisasi program kebangsaan.',
        ),
        ActivationReport(
          id: 'rep-05',
          photoUrl:
              'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400',
          submittedAt: DateTime(2026, 8, 5, 15, 10),
          latitude: -6.8855,
          longitude: 107.6155,
          recipientName: 'Dewi Lestari',
          recipientNik: '3273015509900003',
          notes: 'Penyerahan pamflet dan paket cenderamata posko.',
        ),
      ],
    ),
    ActivationActivity(
      id: 'act-03',
      title: 'Pemasangan Gateway LoRaWAN Wilayah Selatan',
      category: ActivationCategory.pemasanganPerangkat,
      location: 'Kec. Bandung Selatan, Bandung',
      address: 'Menara Komando Posko 2, Bandung Selatan',
      ownerName: 'Bambang Hermawan (Teknisi Jaringan)',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 20),
      endDate: DateTime(2026, 8, 5),
      completedSteps: 5,
      totalSteps: 5,
      description:
          'Penggelaran perangkat jaringan nirkabel LoRaWAN jarak jauh untuk menjangkau area transmisi sinyal antar posko desa.',
      notes: 'Pemasangan antena Omni 868MHz pada ketinggian 12 meter.',
      reports: [],
    ),
    ActivationActivity(
      id: 'act-04',
      title: 'Pendataan & Verifikasi Konstituen Kebangsaan',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Sekeloa, Bandung',
      address: 'RW 03 & RW 04 Kel. Sekeloa, Bandung',
      ownerName: 'Dewi Anggraini (Relawan Lapangan)',
      status: ActivationStatus.dibatalkan,
      startDate: DateTime(2026, 7, 25),
      endDate: DateTime(2026, 8, 10),
      completedSteps: 1,
      totalSteps: 5,
      description:
          'Penjangkauan door to door yang dibatalkan karena pengalihan jadwal kegiatan prioritas wilayah.',
      notes: 'Kegiatan dialihkan ke jadwal bulan berikutnya.',
      reports: [],
    ),
    ActivationActivity(
      id: 'act-05',
      title: 'Pemasangan Display LED Komando Desa C',
      category: ActivationCategory.pemasanganPerangkat,
      location: 'Kec. Lengkong, Bandung',
      address: 'Balai Warga Desa C, Kec. Lengkong, Bandung',
      ownerName: 'Hendra Setiawan (PJ Posko Desa)',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 10),
      endDate: DateTime(2026, 8, 25),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Instalasi papan informasi digital LED di pusat posko komando desa untuk update statistik secara berkala.',
      notes: 'Menunggu pengiriman unit panel LED dari logistik pusat.',
      reports: [],
    ),
    ActivationActivity(
      id: 'act-06',
      title: 'Kunjungan Tokoh Masyarakat & Posko RW 05',
      category: ActivationCategory.doorToDoor,
      location: 'Kec. Cidadap, Bandung',
      address: 'Kediaman Bapak RW 05, Kec. Cidadap, Bandung',
      ownerName: 'Rizal Kurnia (Hubungan Masyarakat)',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 15),
      endDate: DateTime(2026, 7, 30),
      completedSteps: 4,
      totalSteps: 4,
      description:
          'Silaturahmi tokoh pemuda dan masyarakat lokal untuk koordinasi kegiatan gotong royong warga.',
      notes: 'Koordinasi berjalan sukses dan mendapat persetujuan warga.',
      reports: [],
    ),
  ];
}
