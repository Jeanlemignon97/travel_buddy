import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// Handler de messages Firebase reçus lorsque l'application est en arrière-plan.
///
/// Doit être une fonction **top-level** (exigence de Firebase Messaging).
/// Elle est enregistrée via [FirebaseMessaging.onBackgroundMessage].
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM Background] Message reçu: ${message.messageId}');
  debugPrint('[FCM Background] Données: ${message.data}');
}

/// Service de gestion des notifications push Firebase (FCM).
///
/// Responsabilités :
/// - Demander les permissions de notification (iOS/macOS)
/// - Logger le token FCM de l'appareil (utile pour les tests et le débogage)
/// - Écouter et logger les messages reçus en **premier plan**, **arrière-plan**
///   et lorsque l'app est **terminée**
///
/// Ce service est injecté comme `singleton` via Injectable et initialisé au
/// démarrage de l'application dans `main.dart`.
@singleton
class NotificationService {
  final FirebaseMessaging _messaging;

  /// Crée le service en injectant l'instance [FirebaseMessaging].
  NotificationService(this._messaging);

  /// Initialise tous les comportements liés aux notifications push.
  ///
  /// Doit être appelé après [Firebase.initializeApp()] dans `main()`.
  /// Les étapes :
  /// 1. Enregistre le handler d'arrière-plan
  /// 2. Demande les permissions utilisateur
  /// 3. Récupère et logue le token FCM
  /// 4. Configure les listeners foreground / opened-app / initial-message
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
