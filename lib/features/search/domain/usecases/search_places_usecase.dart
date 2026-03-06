import 'package:injectable/injectable.dart';

import '../entities/place.dart';
import '../repositories/i_search_repository.dart';

/// Use-case responsable de la recherche de lieux géographiques.
///
/// Encapsule la règle métier principale de la feature **search** :
/// - Une requête vide ou ne contenant que des espaces retourne immédiatement
///   une liste vide, sans appel réseau.
/// - Une requête valide est déléguée à [ISearchRepository].
///
/// Enregistré comme `lazySingleton` dans le graphe de dépendances Injectable.
@lazySingleton
class SearchPlacesUseCase {
  final ISearchRepository _repository;

  /// Crée une instance en injectant le [ISearchRepository].
  SearchPlacesUseCase(this._repository);

  /// Exécute la recherche de lieux pour la [query] donnée.
  ///
  /// Retourne une liste vide sans appel réseau si [query] est vide ou
  /// ne contient que des espaces.
  ///
  /// Lève une [Exception] si le repository échoue (erreur réseau/serveur).
  Future<List<Place>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchPlaces(query);
  }
}
