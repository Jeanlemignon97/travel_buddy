import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:travel_buddy/features/search/domain/entities/place.dart';
import 'package:travel_buddy/features/search/domain/repositories/i_search_repository.dart';
import 'package:travel_buddy/features/search/domain/usecases/search_places_usecase.dart';

// ────────────────────────────────────────────────────────────────────
// Mock du repository généré avec mocktail
// ────────────────────────────────────────────────────────────────────
class MockSearchRepository extends Mock implements ISearchRepository {}

// Données de test réutilisables
final tPlace = Place(
  id: '1',
  name: 'Paris',
  description: 'Ville Lumière',
  imageUrl: 'https://example.com/paris.jpg',
);

void main() {
  late SearchPlacesUseCase useCase;
  late MockSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockSearchRepository();
    useCase = SearchPlacesUseCase(mockRepository);
  });

  group('SearchPlacesUseCase', () {
    group('call()', () {
      test('retourne une liste de places quand la requête est valide', () async {
        // Arrange
        const query = 'Paris';
        when(() => mockRepository.searchPlaces(query))
            .thenAnswer((_) async => [tPlace]);

        // Act
        final result = await useCase(query);

        // Assert
        expect(result, equals([tPlace]));
        verify(() => mockRepository.searchPlaces(query)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('retourne une liste vide si la requête est vide', () async {
        // Act
        final result = await useCase('');

        // Assert
        expect(result, isEmpty);
        verifyZeroInteractions(mockRepository);
      });

      test('retourne une liste vide si la requête ne contient que des espaces', () async {
        // Act
        final result = await useCase('   ');

        // Assert
        expect(result, isEmpty);
        verifyZeroInteractions(mockRepository);
      });

      test('propage les exceptions lancées par le repository', () async {
        // Arrange
        const query = 'Tokyo';
        when(() => mockRepository.searchPlaces(query))
            .thenThrow(Exception('Erreur réseau'));

        // Act & Assert
        expect(() => useCase(query), throwsException);
      });

      test('retourne une liste vide si le repository ne retourne rien', () async {
        // Arrange
        const query = 'Timbuktu';
        when(() => mockRepository.searchPlaces(query))
            .thenAnswer((_) async => []);

        // Act
        final result = await useCase(query);

        // Assert
        expect(result, isEmpty);
        verify(() => mockRepository.searchPlaces(query)).called(1);
      });
    });
  });
}
