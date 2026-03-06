import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/itinerary_provider.dart';
import '../widgets/add_trip_bottom_sheet.dart';
import '../widgets/trip_card.dart';
import '../widgets/trip_card_skeleton.dart';

/// Écran affichant les itinéraires de l'utilisateur en temps réel depuis Firestore.
///
/// Utilise un [StreamProvider] Riverpod ([tripsProvider]) pour écouter les
/// changements en temps réel. Un [FloatingActionButton] ouvre l'[AddTripBottomSheet]
/// pour créer un nouveau trajet.
class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  void _openAddTrip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddTripBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          'Mes Itinéraires',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTrip(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau trajet'),
      ),
      body: tripsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: 5,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: TripCardSkeleton(),
          ),
        ),
        error: (error, _) => _ItineraryError(message: error.toString()),
        data: (trips) {
          if (trips.isEmpty) {
            return const _ItineraryEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TripCard(
                  trip: trip,
                  onTap: () {
                    context.push('/itinerary/tripDetails', extra: trip);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── Widget privé : état vide ────────────────────────────────────────────────

class _ItineraryEmptyState extends StatelessWidget {
  const _ItineraryEmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.luggage_outlined,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun voyage planifié',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Appuyez sur le bouton + pour\najouter votre premier trajet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget privé : erreur ───────────────────────────────────────────────────

class _ItineraryError extends StatelessWidget {
  final String message;
  const _ItineraryError({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Impossible de charger les trajets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
