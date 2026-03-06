import '../entities/user_entity.dart';

/// Contrat d'accès pour l'authentification.
abstract class IAuthRepository {
  /// Stream permettant d'écouter les changements d'état de connexion.
  /// Émet [UserEntity] si connecté, `null` sinon.
  Stream<UserEntity?> authStateChanges();

  /// Récupère l'utilisateur actuel s'il est connecté.
  UserEntity? get currentUser;

  /// Connecte un utilisateur existant avec son email et mot de passe.
  Future<UserEntity> signIn(String email, String password);

  /// Inscrit un nouvel utilisateur avec son email et mot de passe.
  Future<UserEntity> signUp(String email, String password);

  /// Déconnecte l'utilisateur actuel.
  Future<void> signOut();
}
