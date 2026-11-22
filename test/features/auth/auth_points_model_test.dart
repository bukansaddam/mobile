import 'package:flutter_test/flutter_test.dart';
import 'package:akar/features/auth/data/models/auth_model.dart';
import 'package:akar/features/auth/domain/entities/auth_mapper.dart';

void main() {
  group('UserModel points parsing tests', () {
    test('parses points from root points field as int', () {
      final json = {'id': 1, 'name': 'Budi', 'points': 120};
      final user = UserModel.fromJson(json);
      expect(user.points, 120);
      expect(user.toDomain().points, 120);
    });

    test('parses points from total_points or point fallback', () {
      final jsonTotal = {'id': 1, 'total_points': '250'};
      expect(UserModel.fromJson(jsonTotal).points, 250);

      final jsonPoint = {'id': 1, 'point': 45};
      expect(UserModel.fromJson(jsonPoint).points, 45);
    });

    test(
      'parses points from public_member and village_member nested objects',
      () {
        final jsonPublic = {
          'id': 1,
          'public_member': {'points': 80},
        };
        expect(UserModel.fromJson(jsonPublic).points, 80);

        final jsonVillage = {
          'id': 1,
          'village_member': {'total_points': 95},
        };
        expect(UserModel.fromJson(jsonVillage).points, 95);
      },
    );

    test('parses decimal numbers and decimal strings to integer', () {
      final jsonDecimalNum = {'id': 1, 'points': 150.7};
      expect(UserModel.fromJson(jsonDecimalNum).points, 150);

      final jsonDecimalStr = {'id': 1, 'points': '150.5'};
      expect(UserModel.fromJson(jsonDecimalStr).points, 150);

      final jsonDecimalZero = {'id': 1, 'points': '150.00'};
      expect(UserModel.fromJson(jsonDecimalZero).points, 150);
    });

    test('clamps negative points to 0', () {
      final jsonNegativeNum = {'id': 1, 'points': -10};
      expect(UserModel.fromJson(jsonNegativeNum).points, 0);

      final jsonNegativeStr = {'id': 1, 'points': '-25'};
      expect(UserModel.fromJson(jsonNegativeStr).points, 0);
    });

    test('defaults to 0 on missing or invalid points', () {
      final jsonMissing = {'id': 1};
      expect(UserModel.fromJson(jsonMissing).points, 0);

      final jsonInvalid = {'id': 1, 'points': 'invalid_number'};
      expect(UserModel.fromJson(jsonInvalid).points, 0);
    });
  });
}
