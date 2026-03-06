import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/search/domain/entities/place.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/search/presentation/screens/place_details_screen.dart';
import '../../features/itinerary/domain/entities/trip.dart';
import '../../features/itinerary/presentation/screens/itinerary_screen.dart';
import '../../features/itinerary/presentation/screens/trip_details_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../presentation/screens/main_screen.dart';

/// Provider pour le routeur de l'application, réactif à l'état d'authentification.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Si l'état d'authentification est encore en chargement, on ne fait rien
      if (authState.isLoading) return null;

      final isAuth = authState.valueOrNull != null;
      final isLoggingIn = state.matchedLocation == '/auth';

      // Si non connecté et essaie d'accéder à une autre page -> go /auth
      if (!isAuth && !isLoggingIn) return '/auth';
      
      // Si connecté et est sur /auth -> go /
      if (isAuth && isLoggingIn) return '/';

      return null; // Pas de redirection nécessaire
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branche 1 : Recherche
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const SearchScreen(),
                routes: [
                  GoRoute(
                    path: 'placeDetails',
                    builder: (context, state) {
                      final place = state.extra as Place;
                      return PlaceDetailsScreen(place: place);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branche 2 : Itinéraires
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/itinerary',
                builder: (context, state) => const ItineraryScreen(),
                routes: [
                  GoRoute(
                    path: 'tripDetails', // => /itinerary/tripDetails
                    builder: (context, state) {
                      final trip = state.extra as Trip;
                      return TripDetailsScreen(trip: trip);
                    },
                  ),
                  GoRoute(
                    path: 'placeDetails', // => /itinerary/placeDetails
                    builder: (context, state) {
                      final place = state.extra as Place;
                      return PlaceDetailsScreen(place: place);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branche 3 : Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
