import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// Représente un trajet / voyage planifié par l'utilisateur.
///
/// Entité centrale de la feature **itinerary**. Immutable et générée
/// via Freezed pour l'égalité structurelle, `copyWith` et `toJson`/`fromJson`.
///
/// Stocké dans la collection Firestore `trips`.
///
/// Exemple :
/// ```dart
/// final trip = Trip(
///   id: 'abc123',
///   title: 'Vacances à Rome',
///   destination: 'Rome, Italie',
///   date: DateTime(2025, 8, 15),
/// );
/// ```
@freezed
class Trip with _$Trip {
  /// Construit un [Trip] avec toutes ses propriétés requises.
  const factory Trip({
    /// Identifiant unique du trajet (clé du document Firestore).
    required String id,

    /// Titre descriptif du trajet affiché dans l'interface.
    required String title,

    /// Destination principale du voyage (ville, pays).
    required String destination,

    /// Date de départ ou de début du voyage.
    required DateTime date,

    /// Identifiant de l'utilisateur ayant créé ce voyage.
    /// Peut être null pour les anciens voyages locaux créés avant l'implémentation de l'Auth.
    String? userId,
  }) = _Trip;

  /// Désérialise un [Trip] depuis une [Map] JSON (ex : snapshot Firestore).
  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
