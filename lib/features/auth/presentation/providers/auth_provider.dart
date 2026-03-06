import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';

/// Provider pour injecter le repository d'authentification.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return getIt<IAuthRepository>();
});

/// StreamProvider qui écoute en continu l'état de l'utilisateur (connecté/déconnecté).
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});
