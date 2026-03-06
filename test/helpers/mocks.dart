import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as auth_mocks;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_buddy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:travel_buddy/features/itinerary/domain/repositories/i_itinerary_repository.dart';

// On utilise MockFirebaseAuth de firebase_auth_mocks pour un comportement réaliste
class MockFirebaseAuth extends auth_mocks.MockFirebaseAuth {
  MockFirebaseAuth({super.signedIn, super.mockUser});
}

class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockIAuthRepository extends Mock implements IAuthRepository {}
class MockIItineraryRepository extends Mock implements IItineraryRepository {}
