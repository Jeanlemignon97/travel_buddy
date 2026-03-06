import '../entities/place.dart';

abstract class ISearchRepository {
  Future<List<Place>> searchPlaces(String query);
}
