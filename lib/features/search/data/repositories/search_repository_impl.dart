import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../../../../firebase_options.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/i_search_repository.dart';

@LazySingleton(as: ISearchRepository)
class SearchRepositoryImpl implements ISearchRepository {
  final DioClient _dioClient;

  SearchRepositoryImpl(this._dioClient);

  @override
  Future<List<Place>> searchPlaces(String query) async {
    try {
      final apiKey = DefaultFirebaseOptions.currentPlatform.apiKey;
      final Map<String, dynamic> headers = {
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'places.id,places.displayName,places.formattedAddress,places.photos',
      };

      if (!kIsWeb) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          headers['X-Android-Package'] = 'com.jetravelplus.travelbuddy';
          headers['X-Android-Cert'] = 'D2219B90F7EB192272B34E79DA334CE4E61C1A8B';
        } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
          headers['X-Ios-Bundle-Identifier'] = 'com.jetravelplus.travelbuddy';
        }
      }

      final response = await _dioClient.dio.post(
        '/v1/places:searchText',
        data: {'textQuery': query},
        options: Options(headers: headers),
      );

      final List<dynamic> placesJson = response.data['places'] ?? [];
      
      return placesJson.map((json) {
        final id = json['id'] as String;
        final name = (json['displayName']?['text'] as String?) ?? 'Lieu sans nom';
        final address = (json['formattedAddress'] as String?) ?? '';
        
        // Construction de l'URL de la photo (si dispo)
        String imageUrl = 'https://images.unsplash.com/photo-1500835595327-8307e77073a3?q=80&w=800'; // Fallback
        final photos = json['photos'] as List<dynamic>?;
        if (photos != null && photos.isNotEmpty) {
          final photoName = photos[0]['name'] as String;
          imageUrl = 'https://places.googleapis.com/v1/$photoName/media?maxHeightPx=400&maxWidthPx=800&key=$apiKey';
        }

        return Place(
          id: id,
          name: name,
          description: address,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la recherche Google Places : $e');
    }
  }
}
