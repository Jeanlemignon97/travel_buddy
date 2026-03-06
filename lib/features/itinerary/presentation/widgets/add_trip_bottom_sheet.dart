import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/i_itinerary_repository.dart';
import '../../../search/domain/repositories/i_search_repository.dart';

/// Bottom sheet permettant à l'utilisateur de créer un nouveau [Trip].
///
/// Contient un formulaire avec des champs pour le titre, la destination
/// et la date. Utilise [IItineraryRepository] via GetIt pour la persistance.
class AddTripBottomSheet extends ConsumerStatefulWidget {
  const AddTripBottomSheet({super.key});

  @override
  ConsumerState<AddTripBottomSheet> createState() => _AddTripBottomSheetState();
}

class _AddTripBottomSheetState extends ConsumerState<AddTripBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final trip = Trip(
        id: '',
        title: _titleController.text.trim(),
        destination: _destinationController.text.trim(),
        date: _selectedDate,
      );
      await getIt<IItineraryRepository>().addTrip(trip);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'Nouveau trajet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // Champ titre
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre du voyage',
                hintText: 'Ex: Vacances à Tokyo',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
            ),
            const SizedBox(height: 16),

            // Champ destination avec Autocomplete (Villes)
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                final query = textEditingValue.text;
                if (query.trim().isEmpty) return const Iterable<String>.empty();
                
                // Petit délai pour éviter de spammer l'API
                await Future.delayed(const Duration(milliseconds: 300));
                if (query != textEditingValue.text) {
                  return const Iterable<String>.empty();
                }

                try {
                  final repo = getIt<ISearchRepository>();
                  return await repo.getCityPredictions(query);
                } catch (e) {
                  return const Iterable<String>.empty();
                }
              },
              onSelected: (String selection) {
                _destinationController.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                // Synchroniser notre contrôleur pour la soumission
                fieldTextEditingController.addListener(() {
                  _destinationController.text = fieldTextEditingController.text;
                });
                
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Destination (Ville)',
                    hintText: 'Ex: Tokyo, Japon',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: MediaQuery.of(context).size.width - 48, // Padding de la modale
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_city, size: 20, color: Colors.grey),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(option)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Sélecteur de date
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date de départ',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}/'
                  '${_selectedDate.month.toString().padLeft(2, '0')}/'
                  '${_selectedDate.year}',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Bouton de validation
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Ajouter le trajet',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
