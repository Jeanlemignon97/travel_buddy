import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';

/// Représente un lieu géographique dans le domaine de l'application.
///
/// Cette entité est l'objet central de la feature **search**. Elle est
/// immutable et créée via Freezed pour profiter de l'égalité structurelle,
/// du `copyWith` et d'un `toString` lisible.
///
/// Exemple :
/// ```dart
/// final place = Place(
///   id: '1',
///   name: 'Paris',
///   description: 'Ville Lumière',
///   imageUrl: 'https://example.com/paris.jpg',
/// );
/// ```
@freezed
class Place with _$Place {
  /// Construit un [Place] avec toutes ses propriétés requises.
  const factory Place({
    /// Identifiant unique du lieu (ex: id provenant de l'API).
    required String id,

    /// Nom affiché du lieu (ex: "Paris", "Tour Eiffel").
    required String name,

    /// Courte description du lieu destinée à l'affichage dans les cartes.
    required String description,

    /// URL de l'image représentative du lieu.
    required String imageUrl,
  }) = _Place;
}
