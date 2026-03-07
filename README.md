# Travel Buddy 🧳

Application mobile et web Flutter permettant de **rechercher des destinations** et de **gérer des itinéraires de voyage** en temps réel, avec une architecture robuste et une gestion avancée de la connectivité.

---

## 📸 Architecture

Ce projet suit les principes de la **Clean Architecture** et du pattern **Feature-first** :

```
lib/
├── core/
│   ├── api/             # Client HTTP (DioClient)
│   ├── di/              # Injection de dépendances (GetIt + Injectable)
│   ├── notifications/   # Service Firebase Cloud Messaging & Web Service Worker
│   ├── providers/       # Providers globaux (Connectivity, etc.)
│   ├── router/          # Routage de l'application (GoRouter)
│   └── theme/           # Design System & Thèmes
│
├── features/
│   ├── search/          # Recherche de lieux (Dio + Firestore)
│   └── itinerary/       # Gestion des trajets (Firestore Real-time)
│
└── main.dart            # Configuration globale (Firebase, Theme, Router)

functions/               # Cloud Functions (TypeScript)
├── src/
│   ├── triggers/        # Déclencheurs Firestore (ex: onTripCreated)
│   ├── services/        # Logique métier (ex: Notifications FCM)
│   └── models/          # Interfaces TypeScript partagées
```

---

## ✨ Fonctionnalités Clés

- 🌐 **Monitoring Connectivité** : Indicateur visuel "En ligne/Hors-ligne" dynamique avec système de "Heartbeat" (ping) pour une fiabilité maximale sur Web et Mobile.
- 🔄 **Synchro Temps Réel** : Les modifications de trajets (titre, dates) sont répercutées instantanément sur tous les écrans via des Streams Firestore réactifs.
- ⚡ **Expérience UX Premium** :
  - **Shimmer Skeletons** : Effets de chargement élégants pour les listes de lieux et de trajets.
  - **Hero Animations** : Transitions fluides des images entre la recherche et les détails.
- 🔔 **Notifications Push** :
  - Support Multi-plateforme (iOS, Android, Web via Service Worker).
  - Notifications en premier-plan (Foreground) via SnackBars globaux.
  - Automation via Cloud Functions TypeScript.

---

## ⚙️ Choix techniques

| Technologie | Rôle | Justification |
|---|---|---|
| **Flutter** | Framework UI | Productivité et consistance UI sur Mobile & Web |
| **Riverpod** | Gestion d'état | Réactivité, Streams Firestore simplifiés, testabilité |
| **Firebase** | Backend | Auth, Firestore (temps réel), Messaging, Cloud Functions |
| **TypeScript** | Backend (Functions) | Typage fort pour une logique serveur sécurisée |
| **Freezed** | Modèles | Immutabilité et sécurité des données |
| **Shimmer** | Animation | Meilleure perception de la vitesse de chargement (UX) |

---

## 🚀 Installation et Déploiement

### Application Flutter
1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutterfire configure` (pour régénérer les configs Firebase)
4. `flutter run`

### Cloud Functions
1. `cd functions`
2. `npm install`
3. `npm run build`
4. `firebase deploy --only functions`

---

## 🧪 Qualité & CI/CD

- **Tests** : Utilisation de **Fakes Firebase** (`fake_cloud_firestore`, `firebase_auth_mocks`) pour des tests unitaires rapides et fiables sans mocks manuels fragiles.
- **CI/CD** : Pipeline **GitLab CI** automatisé avec étapes de :
  - `analyze` (Linting Dart & TS)
  - `test` (Unit tests)
  - `build` (Génération des binaires)

---

## 📋 Variables d'environnement

- **Firebase Config** : Automatisée via `firebase_options.dart`.
- **FCM Web** : Nécessite `firebase-messaging-sw.js` dans le dossier `web/`.
