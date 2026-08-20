import 'package:geolocator/geolocator.dart';
import '../models/panic_model.dart';

abstract class PanicRemoteDatasource {
  Future<List<NearbyMemberModel>> fetchNearbyMembers(double lat, double lng);
  Future<PanicAlertResultModel> postPanicAlert({
    required double lat,
    required double lng,
    String? selectedMemberId,
    String? note,
  });
}

class PanicRemoteDatasourceImpl implements PanicRemoteDatasource {
  @override
  Future<List<NearbyMemberModel>> fetchNearbyMembers(
    double lat,
    double lng,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final baseLat = lat != 0.0 ? lat : -6.2088;
    final baseLng = lng != 0.0 ? lng : 106.8456;

    final membersData = [
      // Radius 500m (2 Anggota)
      {
        'id': 'member_1',
        'name': 'Budi Santoso',
        'role': 'Petugas Respon Cepat',
        'latOffset': 0.0012,
        'lngOffset': 0.0012,
        'phone': '081234567891',
      },
      {
        'id': 'member_2',
        'name': 'Ahmad Hidayat',
        'role': 'Koordinator Lapangan',
        'latOffset': -0.0018,
        'lngOffset': 0.0015,
        'phone': '081298765432',
      },
      // Radius 1km (+2 Anggota)
      {
        'id': 'member_3',
        'name': 'Siti Rahma',
        'role': 'Petugas Pertolongan Pertama',
        'latOffset': 0.0055,
        'lngOffset': -0.0050,
        'phone': '081311223344',
      },
      {
        'id': 'member_4',
        'name': 'Rian Pratama',
        'role': 'Anggota Patroli Teritorial',
        'latOffset': -0.0062,
        'lngOffset': -0.0058,
        'phone': '081566778899',
      },
      // Radius 3km (+2 Anggota)
      {
        'id': 'member_5',
        'name': 'Eko Susilo',
        'role': 'Tim Keamanan Sektor',
        'latOffset': 0.0140,
        'lngOffset': 0.0120,
        'phone': '081899001122',
      },
      {
        'id': 'member_6',
        'name': 'Fajar Nugroho',
        'role': 'Petugas Patroli Motor',
        'latOffset': -0.0180,
        'lngOffset': 0.0150,
        'phone': '081900112233',
      },
      // Radius 5km (+2 Anggota)
      {
        'id': 'member_7',
        'name': 'Hendra Wijaya',
        'role': 'Petugas Sub-Sektor Polsek',
        'latOffset': 0.0300,
        'lngOffset': -0.0260,
        'phone': '082111223344',
      },
      {
        'id': 'member_8',
        'name': 'Bambang Tri',
        'role': 'Komandan Satgas Kabupaten',
        'latOffset': -0.0330,
        'lngOffset': -0.0290,
        'phone': '082222334455',
      },
    ];

    final resultList = membersData.map((data) {
      final mLat = baseLat + (data['latOffset'] as double);
      final mLng = baseLng + (data['lngOffset'] as double);
      final distanceInMeters = Geolocator.distanceBetween(
        baseLat,
        baseLng,
        mLat,
        mLng,
      );

      final distanceStr = distanceInMeters >= 1000
          ? '${(distanceInMeters / 1000).toStringAsFixed(1)} km dari lokasi Anda'
          : '${distanceInMeters.round()} m dari lokasi Anda';

      return NearbyMemberModel(
        id: data['id'] as String,
        name: data['name'] as String,
        role: data['role'] as String,
        distanceText: distanceStr,
        latitude: mLat,
        longitude: mLng,
        phone: data['phone'] as String,
        isOnline: true,
      );
    }).toList();

    // Sort by distance nearest first
    resultList.sort((a, b) {
      final distA = int.tryParse(a.distanceText.split(' ')[0]) ?? 0;
      final distB = int.tryParse(b.distanceText.split(' ')[0]) ?? 0;
      return distA.compareTo(distB);
    });

    return resultList;
  }

  @override
  Future<PanicAlertResultModel> postPanicAlert({
    required double lat,
    required double lng,
    String? selectedMemberId,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final alertId =
        'SOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    return PanicAlertResultModel(
      isSuccess: true,
      alertId: alertId,
      timestamp: DateTime.now(),
      message:
          'Sinyal darurat (SOS) ID $alertId berhasil dikirim! Tim tanggap darurat telah menerima koordinat Anda.',
    );
  }
}
