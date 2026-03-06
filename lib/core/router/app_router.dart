import 'package:go_router/go_router.dart';

import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/itinerary/presentation/screens/itinerary_screen.dart';
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
            ),
          ],
        ),
        // Branche 2 : Itinéraires
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/itinerary',
              builder: (context, state) => const ItineraryScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
