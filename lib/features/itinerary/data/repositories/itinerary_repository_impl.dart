import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/trip.dart';
import '../../domain/repositories/i_itinerary_repository.dart';

@LazySingleton(as: IItineraryRepository)
class ItineraryRepositoryImpl implements IItineraryRepository {
  final FirebaseFirestore _firestore;

  static const String _collection = 'trips';

  ItineraryRepositoryImpl(this._firestore);

  @override
  Stream<List<Trip>> getTrips() {
    return _firestore
        .collection(_collection)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Firestore stores Timestamp; convert it to a serializable format
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate().toIso8601String();
        }
        return Trip.fromJson({'id': doc.id, ...data});
      }).toList();
    });
  }

  @override
  Future<void> addTrip(Trip trip) async {
    final data = trip.toJson();
    // Convert DateTime to Firestore Timestamp for proper querying
    data['date'] = Timestamp.fromDate(trip.date);
    // Use the trip's id as the document ID, or let Firestore auto-generate
    if (trip.id.isNotEmpty) {
      await _firestore.collection(_collection).doc(trip.id).set(data);
    } else {
      await _firestore.collection(_collection).add(data);
    }
  }
}
