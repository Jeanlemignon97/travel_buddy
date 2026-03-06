import 'package:flutter/material.dart';

import '../../domain/entities/place.dart';
import '../widgets/save_place_bottom_sheet.dart';

/// Écran affichant les détails d'un lieu sélectionné.
///
/// Utilise une [CustomScrollView] avec un [SliverAppBar] pour animer
/// l'image de couverture (grâce à [Hero]).
class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    required this.place,
    super.key,
  });

  /// Le lieu passé depuis l'écran de recherche.
  final Place place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // AppBar avec l'image étirable
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorScheme.surface,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'place_image_${place.id}',
                child: Image.network(
                  place.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              // Un léger dégradé pour s'assurer que l'icône de retour (blanche) reste visible
              titlePadding: EdgeInsets.zero,
              title: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                height: 60,
              ),
            ),
          ),

          // Contenu de la page
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Section Adresse / Description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: colorScheme.secondary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          place.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Zone prévue pour des actions supplémentaires (Google Maps, Météo...)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'À propos',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Les informations supplémentaires comme les horaires, les avis ou la météo pourront être affichées ici en utilisant d\'autres APIs Google.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  // Marge pour s'assurer qu'on peut défiler sous le FAB
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bouton Flottant (Action principale)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (_) => SavePlaceBottomSheet(place: place),
          );
        },
        icon: const Icon(Icons.bookmark_add),
        label: const Text('Sauvegarder'),
      ),
    );
  }
}
