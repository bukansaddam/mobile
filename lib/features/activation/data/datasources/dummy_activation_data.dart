import 'package:akar/features/activation/domain/entities/activation_activity.dart';

class DummyActivationData {
  static final List<ActivationActivity> activities = [
    // 1. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-01',
      title: 'Pemasangan Baliho Menyapa Warga Kelurahan Menteng',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Menteng, Kec. Menteng, Kota Jakarta Pusat',
      address: 'Kel. Menteng, Kec. Menteng, Kota Jakarta Pusat',
      ownerName: 'Ahmad Ridwan',
      ownerPhone: '081234567890',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 25),
      endDate: DateTime(2026, 8, 5),
      completedSteps: 3,
      totalSteps: 5,
      description:
          'Penggelaran Alat Peraga Kampanye (APK) berupa baliho utama dan spanduk sosialisasi di titik-titik strategis Kelurahan Menteng secara tertib.',
      notes:
          'Pastikan konstruksi rangka kayu/bambu terikat kokoh dan tidak mengganggu jarak pandang pengguna jalan.',
      reports: [
        ActivationReport(
          id: 'rep-01',
          photoUrls: [
            'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
            'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
          ],
          submittedAt: DateTime(2026, 7, 26, 10, 30),
          latitude: -6.1965,
          longitude: 106.8317,
          notes: 'Pemasangan kerangka kayu baliho di simpang kelurahan selesai (2 foto).',
        ),
        ActivationReport(
          id: 'rep-02',
          photoUrls: [
            'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400',
          ],
          submittedAt: DateTime(2026, 7, 27, 14, 15),
          latitude: -6.1970,
          longitude: 106.8320,
          notes: 'Pemasangan kain terpal baliho utama kencang dan rapi.',
        ),
        ActivationReport(
          id: 'rep-03',
          photoUrls: [
            'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400',
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400',
          ],
          submittedAt: DateTime(2026, 7, 29, 09, 45),
          latitude: -6.1975,
          longitude: 106.8325,
          notes: 'Pembersihan sisa material kayu dan sampah sekitar lokasi.',
        ),
      ],
    ),

    // 2. Sedang Berjalan (Door to Door)
    ActivationActivity(
      id: 'act-02',
      title: 'Pembagian Paket Sembako Peduli Warga Kelurahan Senayan',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Senayan, Kec. Kebayoran Baru, Kota Jakarta Selatan',
      address: 'Kel. Senayan, Kec. Kebayoran Baru, Kota Jakarta Selatan',
      ownerName: 'Siti Nurhaliza',
      ownerPhone: '085712345678',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 28),
      endDate: DateTime(2026, 8, 10),
      completedSteps: 1,
      totalSteps: 4,
      description:
          'Penyerahan bantuan sosial berupa paket sembako dan cenderamata secara langsung ke rumah warga lansia dan membutuhkan.',
      notes:
          'Sapa warga dengan santun, sampaikan salam hangat, serta catat data penerima manfaat secara lengkap.',
      reports: [
        ActivationReport(
          id: 'rep-04',
          photoUrls: [
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
            'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400',
          ],
          submittedAt: DateTime(2026, 7, 29, 11, 20),
          latitude: -6.2250,
          longitude: 106.8050,
          recipientName: 'Budi Santoso',
          recipientNik: '3174011204850001',
          notes: 'Penyerahan paket bansos tahap 1 secara langsung kepada penerima.',
        ),
      ],
    ),

    // 3. Selesai (Pemasangan APK)
    ActivationActivity(
      id: 'act-03',
      title: 'Pemasangan Baliho Silaturahmi Kelurahan Tebet Barat',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Tebet Barat, Kec. Tebet, Kota Jakarta Selatan',
      address: 'Kel. Tebet Barat, Kec. Tebet, Kota Jakarta Selatan',
      ownerName: 'Bambang Hermawan',
      ownerPhone: '081398765432',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 10),
      endDate: DateTime(2026, 7, 24),
      completedSteps: 5,
      totalSteps: 5,
      description:
          'Pemasangan media peraga kampanye baliho ucapan salam hangat dan pesan edukasi politik santun untuk masyarakat Kelurahan Tebet Barat.',
      notes: 'Pemasangan telah selesai 100% dan mendapat respons positif dari warga.',
      reports: [
        ActivationReport(id: 'rep-05', photoUrls: ['https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400'], submittedAt: DateTime(2026, 7, 11), latitude: -6.2300, longitude: 106.8400, notes: 'Survei titik lokasi.'),
        ActivationReport(id: 'rep-06', photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'], submittedAt: DateTime(2026, 7, 13), latitude: -6.2305, longitude: 106.8405, notes: 'Perakitan kerangka.'),
        ActivationReport(id: 'rep-07', photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400'], submittedAt: DateTime(2026, 7, 15), latitude: -6.2310, longitude: 106.8410, notes: 'Penataan media baliho.'),
        ActivationReport(id: 'rep-08', photoUrls: ['https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'], submittedAt: DateTime(2026, 7, 18), latitude: -6.2315, longitude: 106.8415, notes: 'Penguatan tiang penyangga.'),
        ActivationReport(id: 'rep-09', photoUrls: ['https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400'], submittedAt: DateTime(2026, 7, 22), latitude: -6.2320, longitude: 106.8420, notes: 'Serah terima hasil pemasangan.'),
      ],
    ),

    // 4. Terjadwal (Pemasangan APK)
    ActivationActivity(
      id: 'act-04',
      title: 'Pemasangan Spanduk Pesan Kebangsaan Kelurahan Kemang',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Bangka, Kec. Mampang Prapatan, Kota Jakarta Selatan',
      address: 'Kel. Bangka, Kec. Mampang Prapatan, Kota Jakarta Selatan',
      ownerName: 'Dewi Anggraini',
      ownerPhone: '082123456789',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 2),
      endDate: DateTime(2026, 8, 12),
      completedSteps: 0,
      totalSteps: 3,
      description:
          'Rencana penggelaran spanduk APK informasi program kerja kerakyatan di sudut-sudut strategis kelurahan.',
      notes: 'Menunggu distribusi bahan cetak spanduk dari logistik pusat.',
      reports: [],
    ),

    // 5. Dibatalkan (Door to Door)
    ActivationActivity(
      id: 'act-05',
      title: 'Penyaluran Paket Nutrisi Balita Kelurahan Cikini',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Cikini, Kec. Menteng, Kota Jakarta Pusat',
      address: 'Kel. Cikini, Kec. Menteng, Kota Jakarta Pusat',
      ownerName: 'Hendra Setiawan',
      ownerPhone: '087812345678',
      status: ActivationStatus.dibatalkan,
      startDate: DateTime(2026, 7, 15),
      endDate: DateTime(2026, 7, 25),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Kunjungan bantuan sosial pencegahan stunting yang dialihkan jadwalnya mengikuti penyesuaian agenda kesehatan wilayah.',
      notes: 'Kegiatan dibatalkan dan digabungkan ke program penyaluran bulan depan.',
      reports: [],
    ),

    // 6. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-06',
      title: 'Pemasangan Baliho Aspirasi Warga Kelurahan Rawamangun',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Rawamangun, Kec. Pulo Gadung, Kota Jakarta Timur',
      address: 'Kel. Rawamangun, Kec. Pulo Gadung, Kota Jakarta Timur',
      ownerName: 'Rizal Kurnia',
      ownerPhone: '089612345678',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 20),
      endDate: DateTime(2026, 8, 3),
      completedSteps: 2,
      totalSteps: 4,
      description:
          'Pemasangan baliho APK peraga yang memuat gagasan pembangunan wilayah dan ajakan menjaga kesatuan warga.',
      notes: 'Gunakan simpul tali yang kuat agar bertahan menghadapi cuaca hujan dan angin.',
      reports: [
        ActivationReport(id: 'rep-10', photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'], submittedAt: DateTime(2026, 7, 22), latitude: -6.1950, longitude: 106.8820, notes: 'Pengantaran material peraga.'),
        ActivationReport(id: 'rep-11', photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400', 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'], submittedAt: DateTime(2026, 7, 26), latitude: -6.1955, longitude: 106.8825, notes: 'Pemasangan tiang pancang (2 foto).'),
      ],
    ),

    // 7. Terjadwal (Pemasangan APK)
    ActivationActivity(
      id: 'act-07',
      title: 'Pemasangan Baliho Apresiasi Tokoh Kelurahan Kebon Sirih',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat',
      address: 'Kel. Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat',
      ownerName: 'Fitriani Lestari',
      ownerPhone: '081298765432',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 5),
      endDate: DateTime(2026, 8, 18),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Rencana penggelaran baliho APK penghormatan terhadap nilai-nilai kebersamaan bagi warga Kelurahan Kebon Sirih.',
      notes: 'Izin tempat dan koordinasi dengan pemilik lahan sudah tuntas.',
      reports: [],
    ),

    // 8. Selesai (Door to Door)
    ActivationActivity(
      id: 'act-08',
      title: 'Penyaluran Bantuan Sembako Berkah Kelurahan Sunter Agung',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Sunter Agung, Kec. Tanjung Priok, Kota Jakarta Utara',
      address: 'Kel. Sunter Agung, Kec. Tanjung Priok, Kota Jakarta Utara',
      ownerName: 'Agus Pratama',
      ownerPhone: '085612345678',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 1),
      endDate: DateTime(2026, 7, 15),
      completedSteps: 4,
      totalSteps: 4,
      description:
          'Pembagian sembako dan cenderamata peralatan rumah tangga kepada keluarga penerima manfaat di lingkungan RW 05.',
      notes: 'Seluruh paket telah tersalurkan 100% tepat sasaran.',
      reports: [
        ActivationReport(
          id: 'rep-12',
          photoUrls: ['https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400'],
          submittedAt: DateTime(2026, 7, 2),
          latitude: -6.1380,
          longitude: 106.8600,
          recipientName: 'Siti Aminah',
          recipientNik: '3172025508750002',
          notes: 'Pendataan calon penerima bantuan.',
        ),
        ActivationReport(
          id: 'rep-13',
          photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400'],
          submittedAt: DateTime(2026, 7, 5),
          latitude: -6.1385,
          longitude: 106.8605,
          recipientName: 'Joko Susilo',
          recipientNik: '3172021003800004',
          notes: 'Pembagian sembako kluster RT 01-03.',
        ),
        ActivationReport(
          id: 'rep-14',
          photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400'],
          submittedAt: DateTime(2026, 7, 8),
          latitude: -6.1390,
          longitude: 106.8610,
          recipientName: 'Dewi Lestari',
          recipientNik: '3172024411920001',
          notes: 'Pembagian sembako kluster RT 04-06.',
        ),
        ActivationReport(
          id: 'rep-15',
          photoUrls: ['https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'],
          submittedAt: DateTime(2026, 7, 12),
          latitude: -6.1395,
          longitude: 106.8615,
          recipientName: 'Ahmad Subagja',
          recipientNik: '3172021506680003',
          notes: 'Verifikasi akhir TTD penyerahan.',
        ),
      ],
    ),

    // 9. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-09',
      title: 'Pemasangan Baliho Peduli Sesama Kelurahan Palmerah',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Palmerah, Kec. Palmerah, Kota Jakarta Barat',
      address: 'Kel. Palmerah, Kec. Palmerah, Kota Jakarta Barat',
      ownerName: 'Eka Wijaya',
      ownerPhone: '083812345678',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 29),
      endDate: DateTime(2026, 8, 12),
      completedSteps: 1,
      totalSteps: 3,
      description:
          'Pemasangan baliho APK bertema gotong royong dan kemandirian ekonomi warga Kelurahan Palmerah.',
      notes: 'Hindari memasang pada pepohonan atau menutupi papan penunjuk jalan.',
      reports: [
        ActivationReport(id: 'rep-16', photoUrls: ['https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400'], submittedAt: DateTime(2026, 7, 29, 16, 00), latitude: -6.1910, longitude: 106.7910, notes: 'Pengiriman peraga sampai di lokasi.'),
      ],
    ),

    // 10. Terjadwal (Door to Door)
    ActivationActivity(
      id: 'act-10',
      title: 'Pembagian Perlengkapan Sekolah Anak Kelurahan Pasar Minggu',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Pasar Minggu, Kec. Pasar Minggu, Kota Jakarta Selatan',
      address: 'Kel. Pasar Minggu, Kec. Pasar Minggu, Kota Jakarta Selatan',
      ownerName: 'Deni Ramdani',
      ownerPhone: '081512345678',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 10),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Program penyerahan bantuan tas dan alat tulis sekolah dari rumah ke rumah untuk anak yatim dan kurang mampu.',
      notes: 'Pastikan paket bantuan terdata rapi sesuai ukuran dan tingkatan sekolah.',
      reports: [],
    ),

    // 11. Dibatalkan (Pemasangan APK)
    ActivationActivity(
      id: 'act-11',
      title: 'Pemasangan Baliho Harapan Warga Kelurahan Tomang',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Tomang, Kec. Grogol Petamburan, Kota Jakarta Barat',
      address: 'Kel. Tomang, Kec. Grogol Petamburan, Kota Jakarta Barat',
      ownerName: 'Nita Rahmawati',
      ownerPhone: '087712345678',
      status: ActivationStatus.dibatalkan,
      startDate: DateTime(2026, 7, 5),
      endDate: DateTime(2026, 7, 18),
      completedSteps: 0,
      totalSteps: 3,
      description:
          'Pemasangan baliho APK peraga diurungkan karena adanya penataan ulang fungsi ruang terbuka hijau.',
      notes: 'Rencana dialihkan ke lokasi pemukiman Kelurahan Jatipulo.',
      reports: [],
    ),

    // 12. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-12',
      title: 'Pemasangan Spanduk Pesan Kebersamaan Kelurahan Cempaka Putih',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Cempaka Putih Timur, Kec. Cempaka Putih, Kota Jakarta Pusat',
      address: 'Kel. Cempaka Putih Timur, Kec. Cempaka Putih, Kota Jakarta Pusat',
      ownerName: 'Aris Munandar',
      ownerPhone: '081112345678',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 22),
      endDate: DateTime(2026, 8, 4),
      completedSteps: 2,
      totalSteps: 4,
      description:
          'Pemasangan media kain spanduk APK berisi pesan perdamaian dan kerukunan warga di kawasan Cempaka Putih.',
      notes: 'Tetap utamakan estetika dan kebersihan area sekitar lokasi penempatan.',
      reports: [
        ActivationReport(id: 'rep-17', photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'], submittedAt: DateTime(2026, 7, 24), latitude: -6.1780, longitude: 106.8680, notes: 'Survei lokasi ikatan.'),
        ActivationReport(id: 'rep-18', photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400'], submittedAt: DateTime(2026, 7, 28), latitude: -6.1785, longitude: 106.8685, notes: 'Pemasangan spanduk pertama.'),
      ],
    ),

    // 13. Selesai (Pemasangan APK)
    ActivationActivity(
      id: 'act-13',
      title: 'Pemasangan Baliho Gagasan Masa Depan Kelurahan Duren Sawit',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Duren Sawit, Kec. Duren Sawit, Kota Jakarta Timur',
      address: 'Kel. Duren Sawit, Kec. Duren Sawit, Kota Jakarta Timur',
      ownerName: 'Irfan Hakim',
      ownerPhone: '081912345678',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 12),
      endDate: DateTime(2026, 7, 26),
      completedSteps: 3,
      totalSteps: 3,
      description:
          'Pemasangan peraga baliho APK ukuran besar secara aman di area persimpangan Kelurahan Duren Sawit.',
      notes: 'Kegiatan berjalan lancar tanpa kendala teknis.',
      reports: [
        ActivationReport(id: 'rep-19', photoUrls: ['https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400'], submittedAt: DateTime(2026, 7, 14), latitude: -6.2210, longitude: 106.9010, notes: 'Persiapan kerangka.'),
        ActivationReport(id: 'rep-20', photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'], submittedAt: DateTime(2026, 7, 18), latitude: -6.2215, longitude: 106.9015, notes: 'Pemasangan baliho.'),
        ActivationReport(id: 'rep-21', photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400', 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'], submittedAt: DateTime(2026, 7, 24), latitude: -6.2220, longitude: 106.9020, notes: 'Pemeriksaan akhir (2 foto).'),
      ],
    ),

    // 14. Terjadwal (Door to Door)
    ActivationActivity(
      id: 'act-14',
      title: 'Penyaluran Bantuan Sembako Maritim Kelurahan Pluit',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Pluit, Kec. Penjaringan, Kota Jakarta Utara',
      address: 'Kel. Pluit, Kec. Penjaringan, Kota Jakarta Utara',
      ownerName: 'Maya Kartika',
      ownerPhone: '085212345678',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 3),
      endDate: DateTime(2026, 8, 15),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Rencana kunjungan silaturahmi dan penyerahan bantuan beras serta minyak goreng untuk keluarga nelayan pesisir.',
      notes: 'Koordinasi dengan ketua rukun nelayan sebelum pelaksanaan kegiatan.',
      reports: [],
    ),

    // 15. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-15',
      title: 'Pemasangan Baliho Edukasi Politik Kelurahan Jatinegara',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Kampung Melayu, Kec. Jatinegara, Kota Jakarta Timur',
      address: 'Kel. Kampung Melayu, Kec. Jatinegara, Kota Jakarta Timur',
      ownerName: 'Dodi Hermawan',
      ownerPhone: '088112345678',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 27),
      endDate: DateTime(2026, 8, 8),
      completedSteps: 1,
      totalSteps: 3,
      description:
          'Sosialisasi visual melalui baliho APK mengenai pentingnya partisipasi aktif warga dalam pesta demokrasi.',
      notes: 'Pastikan tali ikatan kencang dan konstruksi baliho simetris.',
      reports: [
        ActivationReport(id: 'rep-22', photoUrls: ['https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'], submittedAt: DateTime(2026, 7, 28), latitude: -6.2250, longitude: 106.8650, notes: 'Pemasangan fondasi awal.'),
      ],
    ),

    // 16. Terjadwal (Pemasangan APK)
    ActivationActivity(
      id: 'act-16',
      title: 'Pemasangan Baliho Peduli Pemuda Kelurahan Jagakarsa',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Jagakarsa, Kec. Jagakarsa, Kota Jakarta Selatan',
      address: 'Kel. Jagakarsa, Kec. Jagakarsa, Kota Jakarta Selatan',
      ownerName: 'Taufik Hidayat',
      ownerPhone: '081288889999',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 8),
      endDate: DateTime(2026, 8, 20),
      completedSteps: 0,
      totalSteps: 5,
      description:
          'Pemasangan baliho APK peraga yang menampilkan komitmen pengembangan potensi kreativitas pemuda lokal.',
      notes: 'Lokasi titik penempatan sudah dikonfirmasi dengan masyarakat setempat.',
      reports: [],
    ),

    // 17. Selesai (Door to Door)
    ActivationActivity(
      id: 'act-17',
      title: 'Penyerahan Paket Sembako & Kesehatan Kelurahan Kalideres',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Kalideres, Kec. Kalideres, Kota Jakarta Barat',
      address: 'Kel. Kalideres, Kec. Kalideres, Kota Jakarta Barat',
      ownerName: 'Lia Sundari',
      ownerPhone: '085877778888',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 8),
      endDate: DateTime(2026, 7, 22),
      completedSteps: 3,
      totalSteps: 3,
      description:
          'Kunjungan langsung ke kediaman warga lansia untuk membagikan paket bahan pokok dan vitamin kesehatan.',
      notes: 'Kegiatan didampingi tokoh masyarakat setempat.',
      reports: [
        ActivationReport(
          id: 'rep-23',
          photoUrls: ['https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400'],
          submittedAt: DateTime(2026, 7, 10),
          latitude: -6.1510,
          longitude: 106.7010,
          recipientName: 'Rahmat Hidayat',
          recipientNik: '3173051208700005',
          notes: 'Pengemasan paket bansos.',
        ),
        ActivationReport(
          id: 'rep-24',
          photoUrls: ['https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400'],
          submittedAt: DateTime(2026, 7, 14),
          latitude: -6.1515,
          longitude: 106.7015,
          recipientName: 'Sri Wahyuni',
          recipientNik: '3173055201820002',
          notes: 'Penyerahan bantuan door to door.',
        ),
        ActivationReport(
          id: 'rep-25',
          photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400'],
          submittedAt: DateTime(2026, 7, 20),
          latitude: -6.1520,
          longitude: 106.7020,
          recipientName: 'Endang Kartika',
          recipientNik: '3173056109780001',
          notes: 'Pendataan tanda terima penerima.',
        ),
      ],
    ),

    // 18. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-18',
      title: 'Pemasangan Baliho Senyum Warga Kelurahan Pondok Indah',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Pondok Pinang, Kec. Kebayoran Lama, Kota Jakarta Selatan',
      address: 'Kel. Pondok Pinang, Kec. Kebayoran Lama, Kota Jakarta Selatan',
      ownerName: 'Asep Saepullah',
      ownerPhone: '081366667777',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 24),
      endDate: DateTime(2026, 8, 6),
      completedSteps: 3,
      totalSteps: 4,
      description:
          'Penataan baliho APK gambar pesan ramah dan optimisme pembangunan daerah untuk warga Kebayoran Lama.',
      notes: 'Lakukan pengecekan rutin pada kawat pengikat baliho secara berkala.',
      reports: [
        ActivationReport(id: 'rep-26', photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400'], submittedAt: DateTime(2026, 7, 25), latitude: -6.2700, longitude: 106.7780, notes: 'Bahan kayu siap.'),
        ActivationReport(id: 'rep-27', photoUrls: ['https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'], submittedAt: DateTime(2026, 7, 27), latitude: -6.2705, longitude: 106.7785, notes: 'Perakitan selesai.'),
        ActivationReport(id: 'rep-28', photoUrls: ['https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400'], submittedAt: DateTime(2026, 7, 29), latitude: -6.2710, longitude: 106.7790, notes: 'Baliho terpasang.'),
      ],
    ),

    // 19. Terjadwal (Door to Door)
    ActivationActivity(
      id: 'act-19',
      title: 'Aksi Peduli Sembako Murah Kelurahan Kelapa Gading',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Kelapa Gading Timur, Kec. Kelapa Gading, Kota Jakarta Utara',
      address: 'Kel. Kelapa Gading Timur, Kec. Kelapa Gading, Kota Jakarta Utara',
      ownerName: 'Rina Marlina',
      ownerPhone: '087855556666',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 4),
      endDate: DateTime(2026, 8, 16),
      completedSteps: 0,
      totalSteps: 3,
      description:
          'Rencana pengantaran paket bahan pangan pokok langsung ke pintu rumah keluarga prasejahtera.',
      notes: 'Tim relawan bergerak membawa armada kendaraan operasional kelurahan.',
      reports: [],
    ),

    // 20. Selesai (Pemasangan APK)
    ActivationActivity(
      id: 'act-20',
      title: 'Pemasangan Spanduk Peduli Lingkungan Kelurahan Pancoran',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Pancoran, Kec. Pancoran, Kota Jakarta Selatan',
      address: 'Kel. Pancoran, Kec. Pancoran, Kota Jakarta Selatan',
      ownerName: 'Ginanjar Utama',
      ownerPhone: '081244445555',
      status: ActivationStatus.selesai,
      startDate: DateTime(2026, 7, 14),
      endDate: DateTime(2026, 7, 28),
      completedSteps: 2,
      totalSteps: 2,
      description:
          'Pemasangan spanduk APK imbauan kebersihan lingkungan dan kebersamaan warga Kelurahan Pancoran.',
      notes: 'Pemasangan selesai dan telah didokumentasikan.',
      reports: [
        ActivationReport(id: 'rep-29', photoUrls: ['https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400'], submittedAt: DateTime(2026, 7, 16), latitude: -6.2480, longitude: 106.8480, notes: 'Pengikatan sisi kiri.'),
        ActivationReport(id: 'rep-30', photoUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400'], submittedAt: DateTime(2026, 7, 20), latitude: -6.2485, longitude: 106.8485, notes: 'Pengikatan sisi kanan.'),
      ],
    ),

    // 21. Dibatalkan (Pemasangan APK)
    ActivationActivity(
      id: 'act-21',
      title: 'Pemasangan Baliho Kebangsaan Kelurahan Kebayoran Lama',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Kebayoran Lama Utara, Kec. Kebayoran Lama, Kota Jakarta Selatan',
      address: 'Kel. Kebayoran Lama Utara, Kec. Kebayoran Lama, Kota Jakarta Selatan',
      ownerName: 'Hendra Saputra',
      ownerPhone: '085733334444',
      status: ActivationStatus.dibatalkan,
      startDate: DateTime(2026, 7, 18),
      endDate: DateTime(2026, 7, 29),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Pemasangan baliho APK dibatalkan atas pertimbangan teknis efisiensi pemanfaatan media peraga.',
      notes: 'Bahan cetak baliho disimpan kembali di gudang logistik posko.',
      reports: [],
    ),

    // 22. Sedang Berjalan (Pemasangan APK)
    ActivationActivity(
      id: 'act-22',
      title: 'Pemasangan Baliho Sahabat Masyarakat Kelurahan Cilincing',
      category: ActivationCategory.pemasanganApk,
      location: 'Kel. Cilincing, Kec. Cilincing, Kota Jakarta Utara',
      address: 'Kel. Cilincing, Kec. Cilincing, Kota Jakarta Utara',
      ownerName: 'Dian Permana',
      ownerPhone: '081322223333',
      status: ActivationStatus.sedangBerjalan,
      startDate: DateTime(2026, 7, 26),
      endDate: DateTime(2026, 8, 7),
      completedSteps: 1,
      totalSteps: 5,
      description:
          'Pemasangan baliho APK peraga sosialisasi gagasan perubahan positif untuk kesejahteraan masyarakat Kelurahan Cilincing.',
      notes: 'Koordinasi bersama pemuda setempat berjalan sangat harmonis.',
      reports: [
        ActivationReport(id: 'rep-31', photoUrls: ['https://images.unsplash.com/photo-1518770660439-4636190af475?w=400'], submittedAt: DateTime(2026, 7, 28), latitude: -6.1120, longitude: 106.9120, notes: 'Pemasangan tiang utama.'),
      ],
    ),

    // 23. Terjadwal (Door to Door)
    ActivationActivity(
      id: 'act-23',
      title: 'Penyaluran Paket Kehangatan Lansia Kelurahan Ciracas',
      category: ActivationCategory.doorToDoor,
      location: 'Kel. Ciracas, Kec. Ciracas, Kota Jakarta Timur',
      address: 'Kel. Ciracas, Kec. Ciracas, Kota Jakarta Timur',
      ownerName: 'Wawan Setiawan',
      ownerPhone: '089611112222',
      status: ActivationStatus.terjadwal,
      startDate: DateTime(2026, 8, 6),
      endDate: DateTime(2026, 8, 19),
      completedSteps: 0,
      totalSteps: 4,
      description:
          'Kunjungan silaturahmi rumah ke rumah serta pembagian selimut dan sarung untuk sesepuh dan lansia di lingkungan RW 02.',
      notes: 'Tim relawan siap bergerak sesuai jadwal pembagian zonasi.',
      reports: [],
    ),
  ];
}