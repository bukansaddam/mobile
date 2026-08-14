import 'package:akar/core/errors/failures.dart';
import '../entities/location_suggestion.dart';
import '../repositories/location_repository.dart';

class GetLocationSuggestionsUseCase {
  final LocationRepository repository;

  GetLocationSuggestionsUseCase(this.repository);

  Future<Either<Failure, List<LocationSuggestion>>> call(String query) {
    return repository.getLocationSuggestions(query);
  }
}
