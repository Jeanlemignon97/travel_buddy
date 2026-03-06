import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// Représente un utilisateur authentifié dans l'application.
///
/// Cette entité sert d'abstraction agnostique de notre couche domaine
/// (indépendante de Firebase) pour représenter qui utilise l'application.
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    String? displayName,
  }) = _UserEntity;
}
