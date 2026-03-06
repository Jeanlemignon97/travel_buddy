import 'package:flutter_test/flutter_test.dart';
import 'package:travel_buddy/features/itinerary/domain/entities/trip.dart';

void main() {
  group('Trip', () {
    final date = DateTime(2025, 12, 25);
    
    test('should create a Trip with correct values', () {
      final trip = Trip(
        id: 'abc',
        title: 'Voyage Noël',
        destination: 'Paris',
        date: date,
        userId: 'user1',
      );

      expect(trip.id, 'abc');
      expect(trip.title, 'Voyage Noël');
      expect(trip.destination, 'Paris');
      expect(trip.date, date);
      expect(trip.userId, 'user1');
    });

    test('fromJson should return a valid Trip', () {
      final json = {
        'id': 'abc',
        'title': 'Voyage Noël',
        'destination': 'Paris',
        'date': date.toIso8601String(),
        'userId': 'user1',
      };

      final result = Trip.fromJson(json);

      expect(result.id, 'abc');
      expect(result.title, 'Voyage Noël');
      expect(result.date, date);
    });

    test('toJson should return a valid Map', () {
      final trip = Trip(
        id: 'abc',
        title: 'Voyage Noël',
        destination: 'Paris',
        date: date,
        userId: 'user1',
      );

      final result = trip.toJson();

      expect(result['id'], 'abc');
      expect(result['title'], 'Voyage Noël');
      expect(result['userId'], 'user1');
    });
  });
}
