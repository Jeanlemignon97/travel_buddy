import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Statuts de connectivité simplifié.
enum ConnectivityStatus {
  online,
  offline,
}

/// Provider qui écoute les changements de connectivité en temps réel.
/// Sur Web, on évite le "ping" HTTP car il est bloqué par CORS.
final connectivityProvider = StreamProvider<ConnectivityStatus>((ref) async* {
  final connectivity = Connectivity();
  
  // Fonction pour vérifier le "réel" accès Internet (Ping)
  // UNIQUEMENT pour le mobile/desktop, car CORS bloque cela sur Web.
  Future<bool> hasInternet() async {
    if (kIsWeb) return true; // On fait confiance au navigateur sur Web
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  // Émission initiale sécurisée
  ConnectivityStatus currentStatus = ConnectivityStatus.online;
  try {
    final initialList = await connectivity.checkConnectivity();
    final systemOnline = initialList.any((r) => r != ConnectivityResult.none);
    if (!systemOnline) {
      currentStatus = ConnectivityStatus.offline;
    } else if (!kIsWeb) {
      // Sur mobile, on vérifie si le Wi-fi a vraiment internet
      final realOnline = await hasInternet();
      currentStatus = realOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;
    }
  } catch (e) {
    debugPrint('[Connectivity] Error in initial check: $e');
  }
  yield currentStatus;

  // Contrôleur pour gérer les flux
  final controller = StreamController<ConnectivityStatus>();

  // 1. Écouteur système
  final sub = connectivity.onConnectivityChanged.listen(
    (results) async {
      final systemOnline = results.any((r) => r != ConnectivityResult.none);
      if (!systemOnline) {
        if (!controller.isClosed) controller.add(ConnectivityStatus.offline);
      } else {
        // Si Web, on croit le navigateur. Si mobile, on ping.
        final realOnline = kIsWeb ? true : await hasInternet();
        if (!controller.isClosed) {
          controller.add(realOnline ? ConnectivityStatus.online : ConnectivityStatus.offline);
        }
      }
    },
    onError: (err) => debugPrint('[Connectivity] Stream error: $err'),
  );

  // 2. Heartbeat périodique (Uniquement hors Web pour éviter CORS)
  Timer? timer;
  if (!kIsWeb) {
    timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      final realOnline = await hasInternet();
      if (!controller.isClosed) {
        controller.add(realOnline ? ConnectivityStatus.online : ConnectivityStatus.offline);
      }
    });
  }

  ref.onDispose(() {
    sub.cancel();
    timer?.cancel();
    controller.close();
  });

  yield* controller.stream.distinct();
});
