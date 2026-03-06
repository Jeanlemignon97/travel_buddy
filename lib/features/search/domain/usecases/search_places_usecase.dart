import 'package:injectable/injectable.dart';

import '../entities/place.dart';
import '../repositories/i_search_repository.dart';

@lazySingleton
class SearchPlacesUseCase {
  final ISearchRepository _repository;

  SearchPlacesUseCase(this._repository);

  Future<List<Place>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchPlaces(query);
  }
}
