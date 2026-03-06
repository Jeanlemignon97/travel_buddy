import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_buddy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:travel_buddy/features/auth/domain/entities/user_entity.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepositoryImpl authRepository;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authRepository = AuthRepositoryImpl(mockFirebaseAuth);
    mockUser = MockUser();
  });

  group('AuthRepositoryImpl', () {
    const email = 'test@example.com';
    const password = 'password123';

    test('signIn returns UserEntity on success', () async {
      final mockCredential = MockUserCredential();
      
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(email);
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockCredential.user).thenReturn(mockUser);
      
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockCredential);

      final result = await authRepository.signIn(email, password);

      expect(result.id, '123');
      expect(result.email, email);
      expect(result.displayName, 'Test User');
    });

    test('signIn throws exception on FirebaseAuthException', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => authRepository.signIn(email, password),
        throwsA(isA<Exception>()),
      );
    });

    test('signUp returns UserEntity on success', () async {
      final mockCredential = MockUserCredential();
      
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(email);
      when(() => mockCredential.user).thenReturn(mockUser);
      
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockCredential);

      final result = await authRepository.signUp(email, password);

      expect(result.id, '123');
      expect(result.email, email);
    });

    test('signOut calls FirebaseAuth.signOut', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      await authRepository.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
    
    test('authStateChanges returns Stream of UserEntity', () async {
      when(() => mockUser.uid).thenReturn('123');
      when(() => mockUser.email).thenReturn(email);
      
      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.fromIterable([mockUser, null]));

      final result = authRepository.authStateChanges();

      expect(result, emitsInOrder([
        isA<UserEntity>().having((u) => u.id, 'id', '123'),
        isNull,
      ]));
    });
  });
}
