import '../../domain/entities/trip.dart';

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
  /// Si le trip possède un [Trip.id] non vide, l'opération est un `set` (upsert).
  /// Sinon, Firestore génère un identifiant unique automatiquement.
  Future<void> addTrip(Trip trip);
}
