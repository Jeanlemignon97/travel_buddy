import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/place.dart';
import '../../domain/usecases/search_places_usecase.dart';

final searchPlacesUseCaseProvider = Provider<SearchPlacesUseCase>((ref) {
  // Optionnel: utiliser GetIt pour récupérer l'UseCase (puisque GetIt est utilisé pour le reste de l'injection)
  // Ou injecter les dépendances manuellement ici
  return getIt<SearchPlacesUseCase>();
});

final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Place>>>((ref) {
  final useCase = ref.watch(searchPlacesUseCaseProvider);
  return SearchNotifier(useCase);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<Place>>> {
  final SearchPlacesUseCase _useCase;

  SearchNotifier(this._useCase) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
        state = const AsyncValue.data([]);
        return;
    }

    state = const AsyncValue.loading();
    try {
      final results = await _useCase(query);
      state = AsyncValue.data(results);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
