import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Client HTTP centralisé basé sur [Dio].
///
/// Enregistré comme `singleton` dans le graphe de dépendances Injectable, ce
/// client est réutilisé par tous les repositories de la couche data. Il configure :
///
/// - Une `baseUrl` (à remplacer par l'URL réelle de l'API en production)
/// - Des timeouts de connexion et de réception
/// - Un [LogInterceptor] pour tracer toutes les requêtes/réponses dans la console
///
/// Usage :
/// ```dart
/// final response = await dioClient.dio.get('/places/search', queryParameters: {'q': 'Paris'});
/// ```
@singleton
class DioClient {
  final Dio _dio;

  /// Initialise [Dio] avec les options de base et le [LogInterceptor].
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://places.googleapis.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )..interceptors.add(LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
          ));

  /// Instance [Dio] configurée, prête pour les requêtes HTTP.
  Dio get dio => _dio;
}
