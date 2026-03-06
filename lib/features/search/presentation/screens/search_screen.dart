import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../widgets/place_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_empty_state.dart';

/// Écran principal de recherche de destinations.
///
/// Utilise Riverpod ([searchProvider]) pour réagir aux états :
/// - **initial** : invite à taper une recherche
/// - **loading** : affiche un [CircularProgressIndicator]
/// - **data** : liste de [PlaceCard]
/// - **error** : message d'erreur stylisé avec option de retry
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';

  void _onSearchChanged(String value) {
    setState(() => _query = value);
    ref.read(searchProvider.notifier).search(value);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[SearchScreen] Starting build...');
    final searchState = ref.watch(searchProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          'Travel Buddy',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Barre de recherche ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SearchBarWidget(
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchChanged,
            ),
          ),

          // ── Corps dynamique ─────────────────────────────────────────
          Expanded(
            child: searchState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorView(
                message: error.toString(),
                onRetry: () => ref.read(searchProvider.notifier).search(_query),
              ),
              data: (places) {
                if (_query.trim().isEmpty) {
                  return const SearchEmptyState(
                    icon: Icons.explore_outlined,
                    message: 'Tapez une destination pour\ncommencer votre recherche.',
                  );
                }
                if (places.isEmpty) {
                  return const SearchEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: places.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PlaceCard(place: places[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget privé : vue d'erreur ─────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

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
                Icons.wifi_off_rounded,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Une erreur est survenue',
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
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
