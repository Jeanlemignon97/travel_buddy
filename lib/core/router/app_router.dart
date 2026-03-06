import 'package:go_router/go_router.dart';

import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/itinerary/presentation/screens/itinerary_screen.dart';

/// Configuration du routeur de l'application.
///
/// Utilise [GoRouter] avec deux routes principales :
/// - `/` : [SearchScreen] — recherche de destinations
/// - `/itinerary` : [ItineraryScreen] — gestion des trajets
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/itinerary',
      builder: (context, state) => const ItineraryScreen(),
    ),
  ],
);
