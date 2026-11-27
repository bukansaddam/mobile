import 'package:akar/core/errors/failures.dart';

import 'package:akar/features/masyarakat/complaint/domain/entities/location_suggestion.dart';
import 'package:akar/features/masyarakat/complaint/domain/repositories/location_repository.dart';

class GetLocationSuggestionsUseCase {
  final LocationRepository repository;

  GetLocationSuggestionsUseCase(this.repository);

  Future<Either<Failure, List<LocationSuggestion>>> call(String query) {
    return repository.getLocationSuggestions(query);
  }
}
