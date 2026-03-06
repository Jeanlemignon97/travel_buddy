import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/i_search_repository.dart';
import '../models/place_model.dart';

@LazySingleton(as: ISearchRepository)
class SearchRepositoryImpl implements ISearchRepository {
  final DioClient _dioClient;

  SearchRepositoryImpl(this._dioClient);

  @override
  Future<List<Place>> searchPlaces(String query) async {
    try {
      // Endpoint fictif pour l'instant
      final response = await _dioClient.dio.get('/places/search', queryParameters: {'q': query});
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        return data.map((json) {
          final model = PlaceModel.fromJson(json);
          // Mapping vers l'entité du domaine (ici, le modèle et l'entité sont très similaires, mais c'est une bonne pratique)
          return Place(
            id: model.id,
            name: model.name,
            description: model.description,
            imageUrl: model.imageUrl,
          );
        }).toList();
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Gérer les erreurs Dio spécifiques
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Une erreur est survenue: $e');
    }
  }
}
