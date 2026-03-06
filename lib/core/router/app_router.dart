import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Placeholder pour l'écran de recherche
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Search Screen')),
    );
  }
}

// Placeholder pour l'écran d'itinéraire
class ItineraryScreen extends StatelessWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Itinerary Screen')),
    );
  }
}

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
