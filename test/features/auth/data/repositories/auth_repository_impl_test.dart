import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_buddy/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  group('AuthRepositoryImpl with Fakes', () {
    test('signIn returns UserEntity on success', () async {
      final mockAuth = MockFirebaseAuth();
      // On pré-enregistre l'utilisateur dans le faux Auth
      // Note: firebase_auth_mocks gère la création si on veut,
      // mais ici on teste le repository qui appelle l'API.

      final repository = AuthRepositoryImpl(mockAuth);

      // Pour simuler un compte existant dans le fake, on peut utiliser signUp d'abord
      // ou configurer le mockAuth plus finement.
      // Mais AuthRepositoryImpl.signIn appelle juste signInWithEmailAndPassword.

      // Création de compte via le repo
      final signedUp = await repository.signUp('test@example.com', 'password');
      expect(signedUp.email, 'test@example.com');

      // Connexion via le repo
      final signedIn = await repository.signIn('test@example.com', 'password');
      expect(signedIn.id, isNotEmpty);
      expect(signedIn.email, 'test@example.com');
    });

    test('signOut clears current user', () async {
      final user = MockUser(uid: '123');
      final mockAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final repository = AuthRepositoryImpl(mockAuth);

      expect(mockAuth.currentUser, isNotNull);
      await repository.signOut();
      expect(mockAuth.currentUser, isNull);
    });

    test('authStateChanges emits user then null', () async {
      final mockAuth = MockFirebaseAuth();
      final repository = AuthRepositoryImpl(mockAuth);

      final stream = repository.authStateChanges();

      // Simuler des changements
      await mockAuth.createUserWithEmailAndPassword(
        email: 'a@b.com',
        password: '123',
      );
      await mockAuth.signOut();

      expect(
        stream,
        emitsInOrder([
          isNull, // État initial
          isNotNull, // Après signUp/signIn
          isNull, // Après signOut
        ]),
      );
    });
  });
}
