import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/i_itinerary_repository.dart';

final itineraryRepositoryProvider = Provider<IItineraryRepository>((ref) {
  return getIt<IItineraryRepository>();
});

/// StreamProvider qui expose la liste des trajets en temps réel depuis Firestore.
final tripsProvider = StreamProvider<List<Trip>>((ref) {
  final repository = ref.watch(itineraryRepositoryProvider);
  return repository.getTrips();
});
