import 'package:flutter_test/flutter_test.dart';
import 'package:akar/features/linmas/demografi/tokoh/data/models/tokoh_model.dart';
import 'package:akar/features/linmas/demografi/tokoh/presentation/bloc/tokoh_bloc/tokoh_bloc.dart';

void main() {
  group('TokohModel Tests', () {
    test('fromJson parses standard backend JSON correctly', () {
      final json = {
        'id': 101,
        'name': 'Haji Sulaiman',
        'phone': '081234567890',
        'gender': 'laki_laki',
        'institute_id': 5,
        'institute_name': 'Kelurahan Menteng',
        'institute_position': 'Ketua RW',
        'affiliations': 'Agama',
        'professions': 'Tokoh Agama',
        'organization_id': 12,
        'organization_name': 'Dewan Kemakmuran Masjid',
        'organization_position': 'Penasihat',
        'ethnic': 'Jawa',
        'created_at': '2026-09-21T10:00:00.000Z',
        'updated_at': '2026-09-21T10:30:00.000Z',
      };

      final model = TokohModel.fromJson(json);

      expect(model.id, '101');
      expect(model.nama, 'Haji Sulaiman');
      expect(model.noTelp, '081234567890');
      expect(model.jenisKelamin, 'Laki-laki');
      expect(model.instituteId, 5);
      expect(model.namaInstitusi, 'Kelurahan Menteng');
      expect(model.jabatanInstitusi, 'Ketua RW');
      expect(model.afiliasi, 'Agama');
      expect(model.profesi, 'Tokoh Agama');
      expect(model.organizationId, 12);
      expect(model.namaOrganisasi, 'Dewan Kemakmuran Masjid');
      expect(model.jabatanOrganisasi, 'Penasihat');
      expect(model.suku, 'Jawa');
      expect(model.createdAt, isNotNull);
      expect(model.updatedAt, isNotNull);
    });

    test('toApiJson serializes exactly matching user contract', () {
      const model = TokohModel(
        id: '101',
        nama: 'Haji Sulaiman',
        noTelp: '081234567890',
        jenisKelamin: 'Laki-laki',
        instituteId: 5,
        jabatanInstitusi: 'Ketua RW',
        afiliasi: 'Agama',
        profesi: 'Tokoh Agama',
        organizationId: 12,
        jabatanOrganisasi: 'Penasihat',
        suku: 'Jawa',
      );

      final apiJson = model.toApiJson();

      expect(apiJson, {
        'name': 'Haji Sulaiman',
        'phone': '081234567890',
        'gender': 'laki_laki',
        'institute_id': 5,
        'institute_position': 'Ketua RW',
        'affiliations': 'Agama',
        'professions': 'Tokoh Agama',
        'organization_id': 12,
        'organization_position': 'Penasihat',
        'ethnic': 'Jawa',
      });
    });

    test('toApiJson converts perempuan properly', () {
      const model = TokohModel(
        nama: 'Ibu Fatimah',
        noTelp: '081299998888',
        jenisKelamin: 'Perempuan',
        instituteId: 0,
        jabatanInstitusi: '',
        afiliasi: 'Ormas',
        profesi: 'Pendidik',
        organizationId: 0,
        jabatanOrganisasi: '',
        suku: 'Sunda',
      );

      final apiJson = model.toApiJson();

      expect(apiJson['gender'], 'perempuan');
      expect(apiJson['institute_id'], 0);
      expect(apiJson['organization_id'], 0);
    });

    test('TokohResponseModel parses paginated data and meta', () {
      final json = {
        'success': true,
        'message': 'Success',
        'data': [
          {
            'id': 1,
            'name': 'Budi Santoso',
            'phone': '081111111111',
            'gender': 'laki_laki',
            'institute_id': 0,
            'institute_position': '',
            'affiliations': 'Politik',
            'professions': 'Wiraswasta',
            'organization_id': 0,
            'organization_position': '',
            'ethnic': 'Betawi',
          }
        ],
        'meta': {
          'current_page': 1,
          'per_page': 10,
          'total': 25,
          'last_page': 3,
        }
      };

      final response = TokohResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Success');
      expect(response.data.length, 1);
      expect(response.data.first.nama, 'Budi Santoso');
      expect(response.meta?.currentPage, 1);
      expect(response.meta?.perPage, 10);
      expect(response.meta?.total, 25);
      expect(response.meta?.lastPage, 3);
    });

    test('TokohEvent supports affiliations and professions filter properties', () {
      const getEvent = GetTokohEvent(
        affiliations: 'Agama',
        professions: 'Pendidik',
        search: 'Budi',
      );
      expect(getEvent.affiliations, 'Agama');
      expect(getEvent.professions, 'Pendidik');
      expect(getEvent.search, 'Budi');

      const setAffEvent = SetTokohFilterEvent.affiliations('Ormas');
      expect(setAffEvent.hasAffiliations, isTrue);
      expect(setAffEvent.affiliations, 'Ormas');

      const setProfEvent = SetTokohFilterEvent.professions('Dokter');
      expect(setProfEvent.hasProfessions, isTrue);
      expect(setProfEvent.professions, 'Dokter');
    });
  });
}
