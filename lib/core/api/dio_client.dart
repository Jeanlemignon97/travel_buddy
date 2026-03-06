import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.example.com', // Base URL fictive pour l'instant
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

  Dio get dio => _dio;
}
