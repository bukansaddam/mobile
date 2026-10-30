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
