import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/place.dart';
import '../../../itinerary/presentation/providers/itinerary_provider.dart';

/// Un BottomSheet permettant de sélectionner un trajet existant pour y
/// ajouter un [Place].
class SavePlaceBottomSheet extends ConsumerWidget {
  const SavePlaceBottomSheet({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tripsAsync = ref.watch(tripsProvider);

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.paddingOf(context).bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poignée (Handle)
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Sauvegarder dans...',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choisissez l\'itinéraire dans lequel vous souhaitez ajouter ${place.name}.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tripsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur : $err')),
              data: (trips) {
                if (trips.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.luggage_outlined, size: 48, color: colorScheme.outline),
                        const SizedBox(height: 16),
                        const Text('Aucun itinéraire disponible.'),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: trips.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return Consumer(
                      builder: (context, ref, child) {
                        final placesAsync = ref.watch(tripPlacesProvider(trip.id));

                        return placesAsync.when(
                          loading: () => const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Chargement...'),
                          ),
                          error: (err, _) => ListTile(
                            title: Text('Erreur', style: TextStyle(color: colorScheme.error)),
                          ),
                          data: (places) {
                            final isSaved = places.any((p) => p.id == place.id);

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isSaved ? colorScheme.secondaryContainer : colorScheme.primaryContainer,
                                child: Icon(
                                  isSaved ? Icons.check : Icons.flight_takeoff, 
                                  color: isSaved ? colorScheme.onSecondaryContainer : colorScheme.onPrimaryContainer,
                                ),
                              ),
                              title: Text(trip.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(trip.destination),
                              trailing: Icon(
                                isSaved ? Icons.remove_circle_outline : Icons.add_circle_outline,
                                color: isSaved ? colorScheme.error : null,
                              ),
                              onTap: () async {
                                try {
                                  final repo = ref.read(itineraryRepositoryProvider);
                                  if (isSaved) {
                                    await repo.removePlaceFromTrip(trip.id, place.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${place.name} retiré de ${trip.title}')),
                                      );
                                    }
                                  } else {
                                    await repo.addPlaceToTrip(trip.id, place);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${place.name} ajouté à ${trip.title}')),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Erreur: $e')),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
