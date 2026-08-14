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
      {
        'id': 'member_1',
        'name': 'Budi Santoso (Tim Tanggap 1)',
        'role': 'Petugas Respon Cepat',
        'latOffset': 0.0012,
        'lngOffset': 0.0015,
        'phone': '081234567891',
      },
      {
        'id': 'member_2',
        'name': 'Ahmad Hidayat (Tim Tanggap 2)',
        'role': 'Koordinator Lapangan',
        'latOffset': -0.0018,
        'lngOffset': 0.0012,
        'phone': '081298765432',
      },
      {
        'id': 'member_3',
        'name': 'Siti Rahma (Tim Medis)',
        'role': 'Petugas Pertolongan Pertama',
        'latOffset': 0.0025,
        'lngOffset': -0.0020,
        'phone': '081311223344',
      },
      {
        'id': 'member_4',
        'name': 'Rian Pratama (Patroli Teritorial)',
        'role': 'Anggota Patroli',
        'latOffset': -0.0028,
        'lngOffset': -0.0026,
        'phone': '081566778899',
      },
      {
        'id': 'member_5',
        'name': 'Dedi Kurniawan (Reaksi Cepat)',
        'role': 'Petugas Lapangan',
        'latOffset': 0.0008,
        'lngOffset': -0.0032,
        'phone': '081788990011',
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

      return NearbyMemberModel(
        id: data['id'] as String,
        name: data['name'] as String,
        role: data['role'] as String,
        distanceText: '${distanceInMeters.round()} m dari lokasi Anda',
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
