import '../entities/place.dart';

/// Contrat d'accès aux données pour la fonctionnalité de recherche de lieux.
///
/// Cette interface fait partie de la couche **domain** et respecte le principe
/// de l'Inversion de Dépendance (SOLID). La couche présentation et les
/// use-cases ne dépendent que de cette abstraction, jamais de
/// l'implémentation concrète dans la couche data.
abstract class ISearchRepository {
  /// Recherche des lieux correspondant au [query] donné.
  ///
  /// - Retourne une [List<Place>] (potentiellement vide) si la recherche réussit.
  /// - Lève une [Exception] en cas d'erreur réseau ou serveur.
  ///
  /// Le paramètre [query] doit être une chaîne non vide (validée en amont
  /// dans [SearchPlacesUseCase]).
  Future<List<Place>> searchPlaces(String query);
}
