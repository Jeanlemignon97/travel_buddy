import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_buddy/features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'package:travel_buddy/features/itinerary/domain/entities/trip.dart';
import 'package:travel_buddy/features/search/domain/entities/place.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;
  late ItineraryRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    // Création d'un faux utilisateur connecté
    final user = MockUser(
      uid: 'user123',
      email: 'test@example.com',
      displayName: 'Test User',
    );
    mockAuth = MockFirebaseAuth(mockUser: user, signedIn: true);

    repository = ItineraryRepositoryImpl(fakeFirestore, mockAuth);
  });

  group('ItineraryRepositoryImpl', () {
    final trip = Trip(
      id: 'trip1',
      title: 'Voyage',
      destination: 'Paris',
      date: DateTime(2025),
      userId: 'user123',
    );

    test('addTrip stores trip in firestore', () async {
      await repository.addTrip(trip);

      final doc = await fakeFirestore.collection('trips').doc('trip1').get();

      expect(doc.exists, true);
      expect(doc.data()?['title'], 'Voyage');
      expect(doc.data()?['userId'], 'user123');
    });

    test('deleteTrip removes trip from firestore', () async {
      await fakeFirestore.collection('trips').doc('trip1').set({
        'id': 'trip1',
        'title': 'Voyage',
        'destination': 'Paris',
        'date': DateTime(2025).toIso8601String(),
        'userId': 'user123',
      });

      await repository.deleteTrip('trip1');

      final doc = await fakeFirestore.collection('trips').doc('trip1').get();
      expect(doc.exists, false);
    });

    test('addPlaceToTrip adds place to subcollection', () async {
      await repository.addTrip(trip);

      const place = Place(
        id: 'p1',
        name: 'Tour Eiffel',
        description: '',
        imageUrl: '',
      );

      await repository.addPlaceToTrip('trip1', place);

      final doc = await fakeFirestore
          .collection('trips')
          .doc('trip1')
          .collection('places')
          .doc('p1')
          .get();

      expect(doc.exists, true);
      expect(doc.data()?['name'], 'Tour Eiffel');
    });

    test('getTrips returns only user trips sorted by date', () async {
      // Trip 1 (User 123) - Futur
      await repository.addTrip(trip);
      
      // Trip 2 (User 123) - Passé
      await repository.addTrip(trip.copyWith(id: 'trip2', date: DateTime(2024)));
      
      // Trip 3 (Autre User)
      await fakeFirestore.collection('trips').doc('trip3').set({
        'id': 'trip3',
        'userId': 'other_user',
        'title': 'Pas à moi',
        'date': DateTime.now().toIso8601String(),
      });

      final trips = await repository.getTrips().first;

      expect(trips.length, 2);
      expect(trips.first.id, 'trip2'); // Trié par date croissante
      expect(trips.last.id, 'trip1');
    });
  });
}
