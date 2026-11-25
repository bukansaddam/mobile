import 'package:akar/features/linmas/jaga_tanah/domain/entities/jaga_tanah_region_entity.dart';

enum _RegencyType { none, kabupaten, kota }

class JagaTanahRegionMatcher {
  JagaTanahRegionMatcher._();

  static final RegExp _punctuationPattern = RegExp(r'''[.,\-/'"()]''');
  static final RegExp _multiSpacePattern = RegExp(r'\s+');
  static final RegExp _provincePrefixPattern = RegExp(
    r'^(?:provinsi|prov)\s+',
  );
  static final RegExp _districtPrefixPattern = RegExp(
    r'^(?:kecamatan|kec)\s+',
  );
  static final RegExp _villagePrefixPattern = RegExp(
    r'^(?:desa|kelurahan|kel|nagari|gampong|kampung|pekon)\s+',
  );
  static final RegExp _adminPrefixPattern = RegExp(
    r'^(?:administrasi|adm)\s+',
  );

  static const Map<String, String> _provinceAliases = {
    'daerah khusus ibukota jakarta': 'dki jakarta',
    'jakarta': 'dki jakarta',
    'daerah istimewa yogyakarta': 'di yogyakarta',
    'yogyakarta': 'di yogyakarta',
    'diy': 'di yogyakarta',
    'nanggroe aceh darussalam': 'aceh',
    'nad': 'aceh',
    'kep bangka belitung': 'kepulauan bangka belitung',
    'bangka belitung': 'kepulauan bangka belitung',
    'kep riau': 'kepulauan riau',
  };

  static List<JagaTanahRegionEntity> filterByQuery(
    List<JagaTanahRegionEntity> items,
    String query,
  ) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) return items;

    final tokens = normalizedQuery.split(' ');
    final startsWithMatches = <JagaTanahRegionEntity>[];
    final containsMatches = <JagaTanahRegionEntity>[];

    for (final item in items) {
      final normalizedName = _normalize(item.name);
      if (!tokens.every(normalizedName.contains)) continue;
      if (normalizedName.startsWith(normalizedQuery)) {
        startsWithMatches.add(item);
      } else {
        containsMatches.add(item);
      }
    }

    return [...startsWithMatches, ...containsMatches];
  }

  static JagaTanahRegionEntity? findBestMatch(
    List<JagaTanahRegionEntity> candidates,
    String? rawName, {
    required JagaTanahRegionLevel level,
  }) {
    if (candidates.isEmpty || rawName == null) return null;
    final normalizedRaw = _normalize(rawName);
    if (normalizedRaw.isEmpty) return null;

    if (level == JagaTanahRegionLevel.regency) {
      return _findBestRegencyMatch(candidates, normalizedRaw);
    }

    // Priority 1: exact normalized match
    for (final candidate in candidates) {
      if (_normalize(candidate.name) == normalizedRaw) {
        return candidate;
      }
    }

    final rawBase = _canonicalBase(normalizedRaw, level);
    if (rawBase.isEmpty) return null;

    // Priority 2: exact match after stripping prefixes and applying aliases
    for (final candidate in candidates) {
      final candBase = _canonicalBase(_normalize(candidate.name), level);
      if (candBase == rawBase) {
        return candidate;
      }
    }

    // Priority 3: whole-word containment match (min 3 chars)
    return _bestContainmentMatch(
      candidates,
      rawBase,
      baseOf: (candidate) => _canonicalBase(_normalize(candidate.name), level),
    );
  }

  static JagaTanahRegionEntity? _findBestRegencyMatch(
    List<JagaTanahRegionEntity> candidates,
    String normalizedRaw,
  ) {
    final raw = _parseRegency(normalizedRaw);
    if (raw.baseName.isEmpty) return null;

    // Priority 1: exact match on full normalized typed name
    for (final candidate in candidates) {
      final candNorm = _normalize(candidate.name);
      if (candNorm == normalizedRaw) return candidate;
      final cand = _parseRegency(candNorm);
      if (cand.typedName == raw.typedName) return candidate;
    }

    // Priority 2: exact baseName match with non-conflicting admin type
    JagaTanahRegionEntity? baseFallback;
    for (final candidate in candidates) {
      final cand = _parseRegency(_normalize(candidate.name));
      if (_regencyConflicts(raw.type, cand.type)) continue;
      if (cand.baseName != raw.baseName) continue;
      if (cand.type == _RegencyType.kabupaten) return candidate;
      baseFallback ??= candidate;
    }
    if (baseFallback != null) return baseFallback;

    // Priority 3: whole-word containment on baseName with non-conflicting type
    final nonConflicting = candidates
        .where(
          (c) => !_regencyConflicts(raw.type, _parseRegency(_normalize(c.name)).type),
        )
        .toList();

    return _bestContainmentMatch(
      nonConflicting,
      raw.baseName,
      baseOf: (candidate) => _parseRegency(_normalize(candidate.name)).baseName,
      preferCandidate: (a, b) {
        final aIsKab = _parseRegency(_normalize(a.name)).type == _RegencyType.kabupaten;
        final bIsKab = _parseRegency(_normalize(b.name)).type == _RegencyType.kabupaten;
        return aIsKab && !bIsKab;
      },
    );
  }

  static JagaTanahRegionEntity? _bestContainmentMatch(
    List<JagaTanahRegionEntity> candidates,
    String rawBase, {
    required String Function(JagaTanahRegionEntity candidate) baseOf,
    bool Function(JagaTanahRegionEntity challenger, JagaTanahRegionEntity current)?
    preferCandidate,
  }) {
    final rawTokens = rawBase.split(' ').toSet();
    JagaTanahRegionEntity? best;
    int bestOverlap = -1;
    int bestLengthDiff = 1 << 30;

    for (final candidate in candidates) {
      final candBase = baseOf(candidate);
      if (!_isWholeWordContainment(rawBase, candBase)) continue;

      final candTokens = candBase.split(' ').toSet();
      final overlap = rawTokens.intersection(candTokens).length;
      final lengthDiff = (rawBase.length - candBase.length).abs();

      final isBetter =
          best == null ||
          overlap > bestOverlap ||
          (overlap == bestOverlap && lengthDiff < bestLengthDiff) ||
          (overlap == bestOverlap &&
              lengthDiff == bestLengthDiff &&
              preferCandidate != null &&
              preferCandidate(candidate, best));

      if (isBetter) {
        best = candidate;
        bestOverlap = overlap;
        bestLengthDiff = lengthDiff;
      }
    }

    return best;
  }

  static bool _isWholeWordContainment(String a, String b) {
    if (a.isEmpty || b.isEmpty) return false;
    final shorter = a.length <= b.length ? a : b;
    final longer = a.length <= b.length ? b : a;
    if (shorter.length < 3) return false;
    return ' $longer '.contains(' $shorter ');
  }

  static String _canonicalBase(String normalized, JagaTanahRegionLevel level) {
    switch (level) {
      case JagaTanahRegionLevel.province:
        final stripped = normalized.replaceFirst(_provincePrefixPattern, '').trim();
        return _provinceAliases[stripped] ?? stripped;
      case JagaTanahRegionLevel.regency:
        return _parseRegency(normalized).baseName;
      case JagaTanahRegionLevel.district:
        return normalized.replaceFirst(_districtPrefixPattern, '').trim();
      case JagaTanahRegionLevel.village:
        return normalized.replaceFirst(_villagePrefixPattern, '').trim();
    }
  }

  static ({_RegencyType type, String typedName, String baseName}) _parseRegency(
    String normalized,
  ) {
    var type = _RegencyType.none;
    var rest = normalized;

    if (rest.startsWith('kabupaten ')) {
      type = _RegencyType.kabupaten;
      rest = rest.substring('kabupaten '.length).trim();
    } else if (rest.startsWith('kab ')) {
      type = _RegencyType.kabupaten;
      rest = rest.substring('kab '.length).trim();
    } else if (rest.startsWith('kota ')) {
      type = _RegencyType.kota;
      rest = rest.substring('kota '.length).trim();
    }

    final baseName = rest.replaceFirst(_adminPrefixPattern, '').trim();
    final typedName = switch (type) {
      _RegencyType.kabupaten => 'kabupaten $baseName',
      _RegencyType.kota => 'kota $baseName',
      _RegencyType.none => baseName,
    };

    return (type: type, typedName: typedName, baseName: baseName);
  }

  static bool _regencyConflicts(_RegencyType a, _RegencyType b) {
    return (a == _RegencyType.kabupaten && b == _RegencyType.kota) ||
        (a == _RegencyType.kota && b == _RegencyType.kabupaten);
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(_punctuationPattern, ' ')
        .replaceAll(_multiSpacePattern, ' ')
        .trim();
  }
}
