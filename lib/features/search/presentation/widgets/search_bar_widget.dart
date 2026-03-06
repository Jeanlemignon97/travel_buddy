import 'package:flutter/material.dart';

/// Barre de recherche personnalisée Material 3 avec animation d'activation.
///
/// Affiche un champ de texte stylisé avec une icône de recherche et,
/// lorsqu'il est actif, un bouton pour effacer le contenu.
class SearchBarWidget extends StatefulWidget {
  /// Callback déclenché à chaque modification du texte.
  final ValueChanged<String> onChanged;

  /// Callback déclenché quand le champ est soumis (touche "Entrée").
  final ValueChanged<String>? onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Rechercher une destination…',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.close),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: _clear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
