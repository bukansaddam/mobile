import 'package:flutter_test/flutter_test.dart';
import 'package:akar/features/linmas/demografi/institusi/data/models/institusi_category_model.dart';

void main() {
  group('InstitusiCategoryModel Tests', () {
    test('fromJson parses standard JSON correctly', () {
      final json = {
        'id': 13,
        'label': 'Pemerintahan & Birokrasi',
        'code': 'inst_pemerintahan',
        'is_active': true,
        'domain': 'institution',
        'color': '#10B981',
      };

      final model = InstitusiCategoryModel.fromJson(json);

      expect(model.id, 13);
      expect(model.label, 'Pemerintahan & Birokrasi');
      expect(model.code, 'inst_pemerintahan');
      expect(model.isActive, isTrue);
      expect(model.domain, 'institution');
      expect(model.color, '#10B981');
    });

    test('fromJson falls back to name or title if label is null', () {
      final json1 = {'id': '10', 'name': 'Kesehatan', 'is_active': false};
      final model1 = InstitusiCategoryModel.fromJson(json1);
      expect(model1.id, 10);
      expect(model1.label, 'Kesehatan');
      expect(model1.isActive, isFalse);

      final json2 = {'title': 'Pendidikan'};
      final model2 = InstitusiCategoryModel.fromJson(json2);
      expect(model2.label, 'Pendidikan');
      expect(model2.isActive, isTrue);
    });

    test('toJson produces correct Map', () {
      const model = InstitusiCategoryModel(
        id: 1,
        label: 'Keamanan & Ketertiban',
        code: 'inst_keamanan',
        isActive: true,
        domain: 'institution',
        color: '#3B82F6',
      );

      final json = model.toJson();

      expect(json, {
        'id': 1,
        'label': 'Keamanan & Ketertiban',
        'code': 'inst_keamanan',
        'is_active': true,
        'domain': 'institution',
        'color': '#3B82F6',
      });
    });
  });
}
