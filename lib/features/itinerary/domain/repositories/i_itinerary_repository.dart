import '../../domain/entities/trip.dart';

abstract class IItineraryRepository {
  /// Returns a real-time stream of the user's trips from Firestore.
  Stream<List<Trip>> getTrips();

  /// Adds a new trip to Firestore.
  Future<void> addTrip(Trip trip);
}
