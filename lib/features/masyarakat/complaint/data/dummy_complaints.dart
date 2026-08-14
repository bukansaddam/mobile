import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';

/// Daftar pengaduan khusus milik pengguna (Pengaduan Saya)
final List<ComplaintItem> dummyMyComplaints = [
  ComplaintItem(
    id: 'PGD-MY-2026-001',
    title: 'Lampu Penerangan Jalan Umum (PJU) Mati',
    category: ComplaintCategory.sosial.label,
    dateTime: DateTime.now().subtract(const Duration(hours: 4)),
    description:
        'Lampu jalan mati di sepanjang area gang perumahan RT 04. Kondisi jalan menjadi sangat gelap pada malam hari dan rawan kejahatan.',
    location: 'Jl. Merdeka Gang 3, RT 04 / RW 02, Kelurahan Melati',
    attachments: const ['assets/pju_mati.jpg'],
    status: ComplaintStatus.completed,
    icon: ComplaintCategory.sosial.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Laporan pengaduan berhasil masuk ke sistem.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.verified,
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 18)),
        note: 'Laporan telah diverifikasi oleh tim dinas PJU.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.inProgress,
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        note: 'Petugas teknisi PJU melakukan penggantian bohlam lampu.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.completed,
        dateTime: DateTime.now().subtract(const Duration(hours: 4)),
        note:
            'Penggantian lampu telah selesai. Penerangan jalan kembali normal.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-MY-2026-002',
    title: 'Permohonan Pembongkaran Saluran Air Mampet',
    category: ComplaintCategory.lingkungan.label,
    dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    description:
        'Saluran air tersumbat oleh endapan lumpur dan sampah sehingga air meluap ke halaman warga saat hujan.',
    location: 'Jl. Anggrek No. 12, RT 02 / RW 05',
    attachments: const ['assets/saluran_air.jpg'],
    status: ComplaintStatus.inProgress,
    icon: ComplaintCategory.lingkungan.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Laporan pengaduan baru dikirim oleh warga.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.verified,
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
        note: 'Laporan telah diverifikasi oleh admin kelurahan.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.inProgress,
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        note: 'Tim kebersihan drainase dalam proses pengerjaan di lokasi.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-MY-2026-003',
    title: 'Pohon Rindang Berisiko Tumbang di Depan Rumah',
    category: ComplaintCategory.lingkungan.label,
    dateTime: DateTime.now().subtract(const Duration(days: 3)),
    description:
        'Dahan pohon pelindung jalan sudah lapuk dan terlalu lebat, dikhawatirkan rubuh mengenai kabel listrik dan rumah warga.',
    location: 'Jl. Mawar No. 88, Kelurahan Sukajadi',
    attachments: const ['assets/pohon_tumbang.jpg'],
    status: ComplaintStatus.pending,
    icon: ComplaintCategory.lingkungan.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        note: 'Laporan berhasil masuk ke sistem DUMAS.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.pending,
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        note: 'Laporan menunggu verifikasi dari petugas dinas pertamanan.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-MY-2026-004',
    title: 'Kebisingan Usaha Bengkel Saat Malam Hari',
    category: ComplaintCategory.sosial.label,
    dateTime: DateTime.now().subtract(const Duration(days: 5)),
    description:
        'Aktivitas perbaikan kendaraan bermotor hingga pukul 02.00 dini hari mengganggu jam tidur warga sekitar.',
    location: 'Jl. Veteran No. 14, Bandung',
    attachments: const ['assets/kebisingan.jpg'],
    status: ComplaintStatus.cancelled,
    icon: ComplaintCategory.sosial.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 6)),
        note: 'Laporan masuk ke sistem.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.cancelled,
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        note:
            'Pengaduan dibatalkan oleh pelapor setelah ada kesepakatan dengan pemilik bengkel.',
      ),
    ],
  ),
];

/// Daftar pengaduan umum dari seluruh warga/masyarakat (Daftar Pengaduan Publik)
final List<ComplaintItem> dummyPublicComplaints = [
  ComplaintItem(
    id: 'PGD-PUB-2026-001',
    title: 'Jalan Rusak dan Berlubang di Depan Sekolah',
    category: ComplaintCategory.lingkungan.label,
    dateTime: DateTime.now().subtract(const Duration(hours: 2)),
    description:
        'Terdapat lubang cukup dalam di badan jalan tepat di depan pintu masuk SDN 01. Sangat membahayakan anak sekolah dan pengendara motor terutama saat hujan lebat.',
    location: 'Jl. Pemuda No. 45, Kecamatan Sukajadi, Kota Bandung',
    attachments: const ['assets/jalan_rusak.jpg'],
    status: ComplaintStatus.inProgress,
    icon: ComplaintCategory.lingkungan.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(hours: 6)),
        note: 'Laporan masuk dari sistem warga.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.verified,
        dateTime: DateTime.now().subtract(const Duration(hours: 4)),
        note: 'Petugas memperbarui laporan dan memverifikasi kelayakan lokasi.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.inProgress,
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        note:
            'Laporan diproses & tim perbaikan jalan melakukan penambalan di lokasi.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-PUB-2026-002',
    title: 'Penumpukan Sampah di TPS Pasar Rakyat',
    category: ComplaintCategory.lingkungan.label,
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    description:
        'Sampah menumpuk dan meluber hingga ke bahu jalan di sekitar TPS Pasar. Menyebabkan bau tidak sedap dan mengganggu kenyamanan warga setempat.',
    location: 'TPS Pasar Rakyat, Jl. Mawar No. 12',
    attachments: const ['assets/penumpukan_sampah.jpg'],
    status: ComplaintStatus.inProgress,
    icon: ComplaintCategory.lingkungan.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Laporan masuk dari warga.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.verified,
        dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        note: 'Laporan telah diverifikasi oleh Dinas Lingkungan Hidup.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.inProgress,
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        note: 'Truk pengangkut sampah dalam proses pengangkutan di lokasi.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-PUB-2026-003',
    title: 'Laporan Banjir dan Luapan Air Sungai',
    category: ComplaintCategory.bencanaAlam.label,
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    description:
        'Luapan air sungai akibat curah hujan tinggi merendam permukiman warga setinggi 30 cm. Diperlukan penanganan darurat.',
    location: 'Jl. Dahlia Blok C No. 8',
    attachments: const ['assets/laporan_banjir.jpg'],
    status: ComplaintStatus.received,
    icon: ComplaintCategory.bencanaAlam.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Laporan masuk ke dalam sistem DUMAS.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-PUB-2026-004',
    title: 'Pohon Tumbang Menghalangi Akses Jalan Utama',
    category: ComplaintCategory.bencanaAlam.label,
    dateTime: DateTime.now().subtract(const Duration(days: 3)),
    description:
        'Pohon besar tumbang akibat angin kencang menutup dua lajur jalan raya utama. Memerlukan evakuasi tim damkar & BPBD.',
    location: 'Jl. Asia Afrika No. 102, Bandung',
    attachments: const ['assets/pohon_tumbang.jpg'],
    status: ComplaintStatus.completed,
    icon: ComplaintCategory.bencanaAlam.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        note: 'Laporan darurat masuk.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.verified,
        dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 18)),
        note: 'Laporan diverifikasi oleh tim BPBD & Damkar.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.inProgress,
        dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 12)),
        note: 'Tim evakuasi bekerja memotong dan memindahkan ranting pohon.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.completed,
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        note:
            'Pohon telah dipotong dan dievakuasi, arus lalu lintas kembali lancar.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-PUB-2026-005',
    title: 'Kebocoran Pipa Utama Air PDAM',
    category: ComplaintCategory.lingkungan.label,
    dateTime: DateTime.now().subtract(const Duration(days: 4)),
    description:
        'Pipa bocor menyemburkan air bersih ke jalan raya dan mengancam pasokan air ke perumahan warga sekitar.',
    location: 'Jl. Gatot Subroto No. 55',
    attachments: const ['assets/saluran_air.jpg'],
    status: ComplaintStatus.pending,
    icon: ComplaintCategory.lingkungan.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
        note: 'Laporan masuk dikirim oleh warga.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.pending,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        note: 'Menunggu verifikasi dari tim teknis PDAM.',
      ),
    ],
  ),
  ComplaintItem(
    id: 'PGD-PUB-2026-006',
    title: 'Kerusakan Fasilitas Mainan di Taman Kota',
    category: ComplaintCategory.sosial.label,
    dateTime: DateTime.now().subtract(const Duration(days: 5)),
    description:
        'Ayunan dan perosotan anak di area bermain taman kota mengalami kerusakan struktur dan berbahaya bagi anak-anak.',
    location: 'Taman Kota Balai Kota Bandung',
    attachments: const ['assets/jalan_rusak.jpg'],
    status: ComplaintStatus.inProgress,
    icon: ComplaintCategory.sosial.icon,
    statusHistory: [
      ComplaintStatusHistory(
        status: ComplaintStatus.received,
        dateTime: DateTime.now().subtract(const Duration(days: 6)),
        note: 'Laporan masuk ke sistem.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.verified,
        dateTime: DateTime.now().subtract(const Duration(days: 5, hours: 18)),
        note: 'Petugas dinas pertamanan memverifikasi kondisi lokasi.',
      ),
      ComplaintStatusHistory(
        status: ComplaintStatus.inProgress,
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        note: 'Area bermain sementara dipasang garis pengaman untuk perbaikan.',
      ),
    ],
  ),
];

/// Alias kompatibilitas mundur untuk daftar pengaduan publik
final List<ComplaintItem> dummyComplaints = dummyPublicComplaints;
