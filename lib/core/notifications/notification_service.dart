import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// Handler de messages en arrière-plan (doit être une fonction top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM Background] Message reçu: ${message.messageId}');
  debugPrint('[FCM Background] Données: ${message.data}');
}

@singleton
class NotificationService {
  final FirebaseMessaging _messaging;

  NotificationService(this._messaging);

  Future<void> initialize() async {
    // Enregistrer le handler d'arrière-plan
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Demander les permissions (iOS / macOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[FCM] Statut des permissions: ${settings.authorizationStatus}');

    // Log du token FCM
    final token = await _messaging.getToken();
    debugPrint('[FCM] Token: $token');

    // Rafraîchissement du token
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] Token rafraîchi: $newToken');
    });

    // Messages reçus en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FCM Foreground] Message reçu: ${message.messageId}');
      if (message.notification != null) {
        debugPrint('[FCM Foreground] Titre: ${message.notification!.title}');
        debugPrint('[FCM Foreground] Corps: ${message.notification!.body}');
      }
      debugPrint('[FCM Foreground] Données: ${message.data}');
    });

    // Message ayant ouvert l'application depuis l'arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[FCM] App ouverte via notification: ${message.messageId}');
    });

    // Message initial si l'app était terminée
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('[FCM] Message initial (app terminée): ${initialMessage.messageId}');
    }
  }
}
