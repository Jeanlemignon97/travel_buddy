import 'package:go_router/go_router.dart';

import '../../features/search/domain/entities/place.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/search/presentation/screens/place_details_screen.dart';
import '../../features/itinerary/domain/entities/trip.dart';
import '../../features/itinerary/presentation/screens/itinerary_screen.dart';
import '../../features/itinerary/presentation/screens/trip_details_screen.dart';
import '../../presentation/screens/main_screen.dart';

/// Configuration du routeur de l'application.
///
/// Utilise [GoRouter] avec un [StatefulShellRoute] pour maintenir l'état
/// de la navigation entre les onglets (Recherche et Itinéraires).
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
      ],
    ),
  ],
);
