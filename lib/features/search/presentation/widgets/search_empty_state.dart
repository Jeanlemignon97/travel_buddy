import 'package:flutter/material.dart';

/// Widget affiché quand la recherche ne retourne aucun résultat.
class SearchEmptyState extends StatelessWidget {
  /// Message principal affiché à l'utilisateur.
  final String message;

  /// Icône illustrant l'état vide.
  final IconData icon;

  const SearchEmptyState({
    super.key,
    this.message = 'Aucun résultat trouvé.\nEssayez une autre destination.',
    this.icon = Icons.travel_explore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              child: Icon(icon, size: 48, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
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
