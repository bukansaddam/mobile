import 'package:akar/features/masyarakat/complaint/data/dummy_complaints.dart';
import 'package:akar/features/masyarakat/complaint/domain/entities/complaint_item.dart';
import 'package:akar/features/masyarakat/notification/domain/entities/notification_item.dart';

final List<NotificationItem> dummyNotifications = [
  // 1. Complaint Update (Pengaduan PJU Mati - Selesai)
  NotificationItem(
    id: 'NTF-2026-001',
    complaintItem: dummyMyComplaints[0], // Lampu PJU Mati
    title: 'Pengaduan Telah Selesai Ditangani',
    message:
        dummyMyComplaints[0].statusHistory.last.note ??
        'Penggantian lampu telah selesai. Penerangan jalan kembali normal.',
    type: NotificationType.complaint,
    category: NotificationCategory.pengaduan,
    status: ComplaintStatus.completed,
    dateTime: DateTime.now().subtract(const Duration(minutes: 15)),
    isRead: false,
  ),
  // 2. Disaster Alert (Umum)
  NotificationItem(
    id: 'NTF-2026-010',
    title: 'Peringatan Dini Cuaca Ekstrem',
    message:
        'BMKG merilis peringatan dini potensi hujan lebat disertai angin kencang di wilayah Bandung dan sekitarnya. Diimbau tetap waspada.',
    type: NotificationType.disaster,
    category: NotificationCategory.umum,
    dateTime: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: false,
  ),
  // 3. Complaint Update (Pengaduan Saluran Air - Dalam Proses)
  NotificationItem(
    id: 'NTF-2026-002',
    complaintItem: dummyMyComplaints[1], // Saluran Air Mampet
    title: 'Pengaduan Dalam Proses Perbaikan',
    message:
        dummyMyComplaints[1].statusHistory.last.note ??
        'Tim kebersihan drainase dalam perjalanan menuju lokasi.',
    type: NotificationType.complaint,
    category: NotificationCategory.pengaduan,
    status: ComplaintStatus.inProgress,
    dateTime: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: false,
  ),
  // 4. System Maintenance (Umum)
  NotificationItem(
    id: 'NTF-2026-011',
    title: 'Pemeliharaan Rutin Layanan DUMAS',
    message:
        'Sistem DUMAS akan melakukan peningkatan performa server pada hari Minggu pukul 00.00 - 03.00 WIB. Layanan tetap dapat diakses setelahnya.',
    type: NotificationType.system,
    category: NotificationCategory.umum,
    dateTime: DateTime.now().subtract(const Duration(hours: 5)),
    isRead: true,
  ),
  // 5. Complaint Update (Pengaduan Pohon Rindang - Menunggu Verifikasi)
  NotificationItem(
    id: 'NTF-2026-003',
    complaintItem: dummyMyComplaints[2], // Pohon Rindang
    title: 'Laporan Berhasil Diterima Sistem',
    message:
        dummyMyComplaints[2].statusHistory.last.note ??
        'Laporan berhasil dibuat dan menunggu verifikasi petugas.',
    type: NotificationType.complaint,
    category: NotificationCategory.pengaduan,
    status: ComplaintStatus.pending,
    dateTime: DateTime.now().subtract(const Duration(hours: 6)),
    isRead: true,
  ),
  // 6. Announcement (Umum)
  NotificationItem(
    id: 'NTF-2026-012',
    title: 'Peluncuran Fitur Deteksi Otomatis Lokasi',
    message:
        'Kini pembuatan pengaduan menjadi lebih efisien dengan fitur pengisian alamat dan koordinat lokasi otomatis menggunakan GPS.',
    type: NotificationType.announcement,
    category: NotificationCategory.umum,
    dateTime: DateTime.now().subtract(const Duration(hours: 12)),
    isRead: true,
  ),
  // 7. Complaint Update (Pengaduan Kebisingan Bengkel - Dibatalkan)
  NotificationItem(
    id: 'NTF-2026-004',
    complaintItem: dummyMyComplaints[3], // Kebisingan Bengkel
    title: 'Pengaduan Dibatalkan',
    message:
        dummyMyComplaints[3].statusHistory.last.note ??
        'Pengaduan dibatalkan oleh pelapor.',
    type: NotificationType.complaint,
    category: NotificationCategory.pengaduan,
    status: ComplaintStatus.cancelled,
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
  ),
  // 8. General Info (Umum)
  NotificationItem(
    id: 'NTF-2026-013',
    title: 'Panduan Pelaporan Pengaduan Efektif',
    message:
        'Sertakan foto pendukung yang jelas serta detail patokan lokasi agar proses penanganan oleh dinas terkait dapat dilakukan lebih cepat.',
    type: NotificationType.info,
    category: NotificationCategory.umum,
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
];
