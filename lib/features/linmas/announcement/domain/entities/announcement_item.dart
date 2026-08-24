import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AnnouncementItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String date;
  final String author;
  final String? imagePath;
  final List<String> images;
  final String badge;
  final bool isPinned;

  const AnnouncementItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.date,
    required this.author,
    this.imagePath,
    this.images = const [],
    this.badge = 'INFORMASI',
    this.isPinned = false,
  });

  List<String> get allImages {
    if (images.isNotEmpty) return images;
    if (imagePath != null && imagePath!.isNotEmpty) return [imagePath!];
    return [];
  }

  bool get hasImage => allImages.isNotEmpty;

  bool get isPenting => isPinned || badge.toUpperCase() == 'PENTING';

  Color get categoryColor {
    switch (badge.toUpperCase()) {
      case 'PENTING':
        return const Color(0xFFDC2626);
      case 'SIAGA':
        return const Color(0xFFD97706);
      case 'INFORMASI':
      default:
        return const Color(0xFF0F9F66);
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    content,
    date,
    author,
    imagePath,
    images,
    badge,
    isPinned,
  ];
}

final List<AnnouncementItem> dummyLinmasAnnouncements = [
  const AnnouncementItem(
    id: 'ANN-001',
    title: 'Peningkatan Pengawasan & Ronda Malam H-3 Hari Raya',
    subtitle:
        'Diimbau kepada seluruh personil Linmas untuk meningkatkan frekuensi pengawasan di titik rawan.',
    content:
        'Menjelang Hari Raya, seluruh anggota Linmas diimbau untuk memperketat patroli lingkungan, khususnya pemukiman yang ditinggal mudik. Pastikan koordinasi secara aktif melalui grup siaga dan laporkan aktivitas mencurigakan secara real-time via aplikasi.',
    date: '24 Ags 2026',
    author: 'Kasat Pol PP & Linmas',
    imagePath: 'assets/banner_1.jpg',
    images: ['assets/banner_1.jpg', 'assets/banner_2.jpg'],
    badge: 'PENTING',
    isPinned: true,
  ),
  const AnnouncementItem(
    id: 'ANN-002',
    title: 'Apel Siaga & Sosialisasi Tanggap Bencana Wilayah',
    subtitle:
        'Pelaksanaan Apel Siaga Linmas bersama Satpol PP & BPBD dalam antisipasi cuaca ekstrem.',
    content:
        'Kegiatan Apel Siaga dan Sosialisasi Tanggap Bencana akan dilaksanakan pada hari Sabtu mendatang bertempat di Lapangan Kecamatan. Diharapkan kehadiran seluruh ketua dan anggota Satgas Linmas kelurahan tepat waktu dengan atribut lengkap.',
    date: '22 Ags 2026',
    author: 'Admin Linmas Pusat',
    imagePath: 'assets/banner_2.jpg',
    images: ['assets/banner_2.jpg', 'assets/banner_illustration.jpg'],
    badge: 'SIAGA',
  ),
  const AnnouncementItem(
    id: 'ANN-003',
    title: 'Informasi Fitur Laporan Harian & Bank Sampah',
    subtitle:
        'Pembaruan sistem pelaporan kegiatan Linmas dan pencatatan Bank Sampah wilayah.',
    content:
        'Kini personil Linmas dapat langsung mencatatkan laporan kegiatan harian ronda serta menyetorkan data bank sampah lingkungan melalui menu utama aplikasi. Pastikan data koordinat dan foto terlampir secara lengkap.',
    date: '20 Ags 2026',
    author: 'Tim Teknis AKAR',
    imagePath: 'assets/banner_illustration.jpg',
    images: [
      'assets/banner_illustration.jpg',
      'assets/home_hero_illustration.jpg',
    ],
    badge: 'INFORMASI',
  ),
  const AnnouncementItem(
    id: 'ANN-004',
    title: 'Pemeriksaan Kesehatan & Kebugaran Anggota Linmas',
    subtitle:
        'Jadwal pemeriksaan kesehatan gratis untuk personil Linmas di Puskesmas terdekat.',
    content:
        'Diberitahukan kepada seluruh personil Linmas bahwa layanan pemeriksaan kesehatan dan kebugaran gratis dapat diakses setiap hari Rabu di Puskesmas Kecamatan. Diharapkan seluruh anggota memanfaatkan fasilitas ini secara berkala.',
    date: '18 Ags 2026',
    author: 'Dinas Kesehatan & Linmas',
    imagePath: 'assets/indonesian_headshot_portrait.jpg',
    images: ['assets/indonesian_headshot_portrait.jpg'],
    badge: 'INFORMASI',
  ),
  const AnnouncementItem(
    id: 'ANN-005',
    title: 'Himbauan Penghematan Energi & Air Bersih Posko',
    subtitle:
        'Seluruh personil Linmas diminta menjaga efisiensi penggunaan listrik dan air di posko kelurahan.',
    content:
        'Dalam rangka mendukung gerakan efisiensi energi daerah, setiap regu jaga Linmas diwajibkan memastikan seluruh peralatan elektronik dan lampu posko yang tidak terpakai telah dimatikan sebelum serah terima tugas.',
    date: '15 Ags 2026',
    author: 'Pengurus Posko Linmas',
    imagePath: null,
    images: [],
    badge: 'INFORMASI',
  ),
];
