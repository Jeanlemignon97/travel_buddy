# Travel Buddy 🧳

Application mobile Flutter (iOS & Android) permettant de **rechercher des destinations** et de **gérer des itinéraires de voyage** en temps réel, avec un support de notifications push.

---

## 📸 Architecture

Ce projet suit les principes de la **Clean Architecture** et du pattern **Feature-first** :

```
lib/
├── core/
│   ├── api/             # Client HTTP (DioClient)
│   ├── di/              # Injection de dépendances (GetIt + Injectable)
│   ├── notifications/   # Service Firebase Cloud Messaging
│   ├── router/          # Routage de l'application (GoRouter)
│   └── theme/           # Thème global (à venir)
│
├── features/
│   ├── search/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/        # PlaceModel (Freezed + JsonSerializable)
│   │   │   └── repositories/  # SearchRepositoryImpl (Dio)
│   │   ├── domain/
│   │   │   ├── entities/      # Place
│   │   │   ├── repositories/  # ISearchRepository (interface)
│   │   │   └── usecases/      # SearchPlacesUseCase
│   │   └── presentation/
│   │       ├── providers/     # searchProvider (Riverpod StateNotifier)
│   │       ├── screens/
│   │       └── widgets/
│   │
│   └── itinerary/
│       ├── data/
│       │   └── repositories/  # ItineraryRepositoryImpl (Firestore)
│       ├── domain/
│       │   ├── entities/      # Trip (Freezed)
│       │   ├── repositories/  # IItineraryRepository (interface)
│       │   └── usecases/
│       └── presentation/
│           ├── providers/     # tripsProvider (Riverpod StreamProvider)
│           ├── screens/
│           └── widgets/
│
└── main.dart            # Point d'entrée (Firebase + GetIt + Riverpod)
```

### Flux de données

```
UI (Widget)
   │
   ▼
Provider (Riverpod)   ◄──── StreamProvider pour Firestore (temps réel)
   │
   ▼
UseCase (Domain)
   │
   ▼
Repository Interface (Domain)
   │
   ▼
Repository Impl (Data)  ──►  DioClient (REST API) / Firestore
```

---

## ⚙️ Choix techniques

| Technologie | Rôle | Justification |
|---|---|---|
| **Flutter** | Framework UI cross-platform | Productivité, performances natives iOS/Android |
| **Riverpod** | Gestion d'état | Type-safe, testable, pas de `BuildContext` requis |
| **Dio** | Client HTTP | Intercepteurs, gestion d'erreurs avancée, timeouts |
| **Freezed** | Modèles immutables | Sécurité, `copyWith`, `==`, `toString` auto-générés |
| **GoRouter** | Navigation déclarative | Routage URL-based, deep links, guards |
| **GetIt + Injectable** | Injection de dépendances | Léger, efficace, génération de code via annotations |
| **Cloud Firestore** | Base de données temps réel | Streams natifs, synchronisation offline |
| **Firebase Messaging** | Notifications push | Intégration Firebase unifiée |
| **Mocktail** | Tests unitaires | API simple pour mocker les dépendances en Dart |

### Principes appliqués

- ✅ **Clean Architecture** – Séparation Domain / Data / Presentation
- ✅ **SOLID** – Inversion de dépendance via les interfaces de repository
- ✅ **Feature-first** – Organisation modulaire et scalable
- ✅ **Immutabilité** – Modèles Freezed dans toutes les couches

---

## 🚀 Lancer le projet

### Prérequis

- Flutter SDK `^3.11.0`
- Dart `^3.11.0`
- Compte Firebase avec projet configuré
- `flutterfire_cli` installé globalement

### 1. Cloner et installer les dépendances

```bash
git clone git@gitlab.com:flutter_personal_project/travel_buddy.git
cd travel_buddy
flutter pub get
```

### 2. Configurer Firebase

> ⚠️ Le fichier `google-services.json` (Android) et `GoogleService-Info.plist` (iOS) ne sont pas versionnés pour des raisons de sécurité. Vous devez les générer via la CLI Firebase :

```bash
# Installer flutterfire_cli si ce n'est pas fait
dart pub global activate flutterfire_cli

# Générer les fichiers de configuration Firebase
flutterfire configure
```

### 3. Générer le code (Freezed, JsonSerializable, Injectable)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Lancer l'application

```bash
flutter run
```

### 5. Lancer les tests

```bash
flutter test
```

---

## 🧪 Tests

Les tests unitaires se trouvent dans `test/` et suivent la même arborescence que `lib/`.

```bash
flutter test test/features/search/domain/usecases/search_places_usecase_test.dart
```

Couverture actuelle :

| Use-Case | Tests |
|---|---|
| `SearchPlacesUseCase` | ✅ 5 cas (query valide, vide, espaces, exception, résultat vide) |

---

## 📋 Variables d'environnement

| Clé | Description |
|---|---|
| `baseUrl` dans `DioClient` | URL de l'API REST (à remplacer par la vraie URL) |
| Firebase config | Générée via `flutterfire configure` |
