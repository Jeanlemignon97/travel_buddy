import '../../domain/entities/trip.dart';
import '../../../search/domain/entities/place.dart';

/// Contrat d'accès aux données pour la fonctionnalité d'itinéraires.
///
/// Abstraction de la couche **domain** pour la gestion des trajets. Permet
/// de découpler les use-cases et la présentation de l'implémentation Firestore.
///
/// Respect du principe SOLID « Inversion de Dépendance ».
abstract class IItineraryRepository {
  /// Retourne un stream temps réel de la liste des trajets de l'utilisateur.
  ///
  /// Émet une nouvelle liste à chaque modification dans Firestore.
  /// Les trajets sont triés par date croissante.
  Stream<List<Trip>> getTrips();

  /// Persiste un nouveau [trip] dans la source de données.
  ///
  Future<void> addTrip(Trip trip);

  /// Supprime un [Trip] existant de la source de données via son [tripId].
  Future<void> deleteTrip(String tripId);

  // ── Gestion des Lieux liés aux Trajets (Sous-collections) ──

  /// Ajoute un [Place] provenant de la recherche à un [Trip] spécifique.
  Future<void> addPlaceToTrip(String tripId, Place place);

  /// Retourne la liste en temps réel des lieux sauvegardés pour un [Trip] donné.
  Stream<List<Place>> getPlacesForTrip(String tripId);

  /// Retire un lieu spécifique d'un [Trip].
  Future<void> removePlaceFromTrip(String tripId, String placeId);
}
