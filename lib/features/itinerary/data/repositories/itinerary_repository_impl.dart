import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/trip.dart';
import '../../../search/domain/entities/place.dart';
import '../../domain/repositories/i_itinerary_repository.dart';

/// Implémentation concrète de [IItineraryRepository] utilisant Cloud Firestore.
///
/// Gère la persistance et la récupération en temps réel des trajets
/// de l'utilisateur via la collection Firestore `trips`.
///
/// Enregistré comme `lazySingleton` avec Injectable, lié à [IItineraryRepository].
@LazySingleton(as: IItineraryRepository)
class ItineraryRepositoryImpl implements IItineraryRepository {
  final FirebaseFirestore _firestore;

  static const String _collection = 'trips';

  /// Crée l'implémentation en injectant l'instance [FirebaseFirestore].
  ItineraryRepositoryImpl(this._firestore);

  /// Retourne un [Stream] en temps réel de tous les trajets triés par date.
  ///
  /// Les mises à jour Firestore sont reflétées immédiatement dans le stream.
  /// Les [Timestamp] Firestore sont convertis en [DateTime] pour correspondre
  /// au modèle [Trip].
  ///
  /// Lève une exception si la lecture Firestore échoue.
  @override
  Stream<List<Trip>> getTrips() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Insert the document ID directly into the map to ensure Freezed parses it
        data['id'] = doc.id;
        
        // Firestore stores Timestamp; convert it to a serializable format
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate().toIso8601String();
        }
        return Trip.fromJson(data);
      }).toList();
    });
  }

  /// Ajoute ou remplace un [Trip] dans la collection Firestore.
  ///
  /// Si [trip.id] est non vide, le document est créé/ecrasé avec cet ID.
  /// Sinon, Firestore génère un ID automatique.
  ///
  /// Les [DateTime] sont convertis en [Timestamp] Firestore pour permettre
  /// un tri et des requêtes efficaces côté serveur.
  ///
  /// Lève une [DioException] ou une [Exception] en cas d'échec.
  @override
  Future<void> addTrip(Trip trip) async {
    final data = trip.toJson();
    // Convert DateTime to Firestore Timestamp for proper querying
    data['date'] = Timestamp.fromDate(trip.date);
    if (trip.id.isNotEmpty) {
      await _firestore.collection(_collection).doc(trip.id).set(data);
    } else {
      await _firestore.collection(_collection).add(data);
    }
  }

  /// Supprime un trajet spécifique de Firestore via son [tripId].
  @override
  Future<void> deleteTrip(String tripId) async {
    await _firestore.collection(_collection).doc(tripId).delete();
  }

  // ── Gestion des Lieux liés aux Trajets (Sous-collections) ──

  @override
  Future<void> addPlaceToTrip(String tripId, Place place) async {
    final subCollection = _firestore.collection(_collection).doc(tripId).collection('places');
    
    // On utilise l'ID du lieu fourni par Google Places comme clé de document
    // pour éviter les doublons accidentels s'il l'ajoute deux fois.
    await subCollection.doc(place.id).set({
      'id': place.id,
      'name': place.name,
      'description': place.description,
      'imageUrl': place.imageUrl,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Place>> getPlacesForTrip(String tripId) {
    return _firestore
        .collection(_collection)
        .doc(tripId)
        .collection('places')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Place(
          id: data['id'] as String,
          name: data['name'] as String,
          description: data['description'] as String,
          imageUrl: data['imageUrl'] as String,
        );
      }).toList();
    });
  }

  @override
  Future<void> removePlaceFromTrip(String tripId, String placeId) async {
    await _firestore
        .collection(_collection)
        .doc(tripId)
        .collection('places')
        .doc(placeId)
        .delete();
  }
}
