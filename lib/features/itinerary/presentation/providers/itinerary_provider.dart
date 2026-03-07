import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/trip.dart';
import '../../../search/domain/entities/place.dart';
import '../../domain/repositories/i_itinerary_repository.dart';

final itineraryRepositoryProvider = Provider<IItineraryRepository>((ref) {
  return getIt<IItineraryRepository>();
});

/// StreamProvider qui expose la liste des trajets en temps réel depuis Firestore.
final tripsProvider = StreamProvider<List<Trip>>((ref) {
  final repository = ref.watch(itineraryRepositoryProvider);
  return repository.getTrips();
});

/// Fournisseur d'état (Stream) exposant la liste des lieux d'un trajet précis.
final tripPlacesProvider = StreamProvider.family<List<Place>, String>((ref, tripId) {
  final repository = getIt<IItineraryRepository>();
  return repository.getPlacesForTrip(tripId);
});

/// Fournisseur qui retourne un trajet spécifique à partir du pool de trajets chargés.
/// Permet de garder l'écran de détails synchronisé si le trajet est modifié en DB.
final singleTripProvider = Provider.family<Trip?, String>((ref, tripId) {
  final tripsAsync = ref.watch(tripsProvider);
  return tripsAsync.maybeWhen(
    data: (trips) => trips.cast<Trip?>().firstWhere(
          (t) => t?.id == tripId,
          orElse: () => null,
        ),
    orElse: () => null,
  );
});
