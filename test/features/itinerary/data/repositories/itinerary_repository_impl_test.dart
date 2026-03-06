import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_buddy/features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'package:travel_buddy/features/itinerary/domain/entities/trip.dart';
import 'package:travel_buddy/features/search/domain/entities/place.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockFirebaseAuth;
  late ItineraryRepositoryImpl repository;
  late MockCollectionReference mockCollection;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(Trip(
      id: '',
      title: '',
      destination: '',
      date: DateTime.now(),
    ));
    registerFallbackValue(const Place(id: '', name: '', description: '', imageUrl: ''));
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    repository = ItineraryRepositoryImpl(mockFirestore, mockFirebaseAuth);
    mockCollection = MockCollectionReference();
    mockUser = MockUser();

    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('user123');
  });

  group('ItineraryRepositoryImpl', () {
    final trip = Trip(
      id: 'trip1',
      title: 'Voyage',
      destination: 'Paris',
      date: DateTime(2025),
      userId: 'user123',
    );

    test('addTrip calls firestore set when ID is provided', () async {
      final mockDoc = MockDocumentReference();
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.set(any())).thenAnswer((_) async => {});

      await repository.addTrip(trip);

      verify(() => mockCollection.doc('trip1')).called(1);
    });

    test('deleteTrip calls firestore delete', () async {
      final mockDoc = MockDocumentReference();
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.delete()).thenAnswer((_) async => {});

      await repository.deleteTrip('trip1');

      verify(() => mockDoc.delete()).called(1);
    });

    test('addPlaceToTrip adds to subcollection', () async {
      final mockDoc = MockDocumentReference();
      final mockSubCollection = MockCollectionReference();
      final mockSubDoc = MockDocumentReference();
      
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.collection('places')).thenReturn(mockSubCollection);
      when(() => mockSubCollection.doc(any())).thenReturn(mockSubDoc);
      when(() => mockSubDoc.set(any())).thenAnswer((_) async => {});

      const place = Place(id: 'p1', name: 'Tour Eiffel', description: '', imageUrl: '');
      await repository.addPlaceToTrip('trip1', place);

      verify(() => mockSubCollection.doc('p1')).called(1);
    });

    test('removePlaceFromTrip deletes from subcollection', () async {
      final mockDoc = MockDocumentReference();
      final mockSubCollection = MockCollectionReference();
      final mockSubDoc = MockDocumentReference();
      
      when(() => mockCollection.doc(any())).thenReturn(mockDoc);
      when(() => mockDoc.collection('places')).thenReturn(mockSubCollection);
      when(() => mockSubCollection.doc(any())).thenReturn(mockSubDoc);
      when(() => mockSubDoc.delete()).thenAnswer((_) async => {});

      await repository.removePlaceFromTrip('trip1', 'p1');

      verify(() => mockSubDoc.delete()).called(1);
    });
  });
}
