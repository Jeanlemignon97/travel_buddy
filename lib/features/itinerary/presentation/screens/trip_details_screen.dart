import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/i_itinerary_repository.dart';
import '../providers/itinerary_provider.dart';
import '../widgets/add_trip_bottom_sheet.dart';

/// Un écran affichant les détails d'un trajet spécifique, permettant de voir les
/// lieux associés (à venir), et de supprimer le trajet.
class TripDetailsScreen extends ConsumerWidget {
  const TripDetailsScreen({
    required this.trip,
    super.key,
  });

  /// Le trajet sélectionné.
  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(trip.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Modifier ce trajet',
            onPressed: () => _showEditSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: colorScheme.error,
            tooltip: 'Supprimer ce trajet',
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── En-tête coloré avec les infos de base ──
            Container(
              color: colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.flight_takeoff, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    trip.destination,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_month, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(trip.date),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Section Lieux Visitées ──
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lieux à visiter',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  ref.watch(tripPlacesProvider(trip.id)).when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Erreur: $err')),
                    data: (places) {
                      if (places.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 64,
                                  color: colorScheme.outlineVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun lieu n\'a encore été ajouté.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Naviguer vers l'onglet Recherche via MainScreen shell
                                    context.go('/');
                                  },
                                  icon: const Icon(Icons.search),
                                  label: const Text('Explorer des lieux'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: places.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final place = places[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Hero(
                                tag: 'place_image_${place.id}',
                                child: place.imageUrl.isNotEmpty
                                    ? Image.network(
                                        place.imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            _buildPlaceholder(),
                                      )
                                    : _buildPlaceholder(),
                              ),
                            ),
                            title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: colorScheme.error,
                              onPressed: () async {
                                final repo = ref.read(itineraryRepositoryProvider);
                                await repo.removePlaceFromTrip(trip.id, place.id);
                              },
                            ),
                            onTap: () {
                              // Navigue vers les détails du lieu depuis l'onglet Itinéraire
                              // en utilisant le chemin défini dans app_router.dart sous la branche Itinéraire
                              context.push('/itinerary/placeDetails', extra: place);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTripBottomSheet(trip: trip),
    );
  }

  /// Ouvre une boîte de dialogue pour confirmer la suppression.
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce trajet ?'),
        content: Text('Le voyage vers ${trip.destination} sera définitivement supprimé.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop(); // Fermer la modale
              try {
                final repo = getIt<IItineraryRepository>();
                await repo.deleteTrip(trip.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le trajet a été supprimé.')),
                  );
                  context.pop(); // Retour à la liste
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de la suppression: $e')),
                  );
                }
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  /// Formateur de date simple
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
