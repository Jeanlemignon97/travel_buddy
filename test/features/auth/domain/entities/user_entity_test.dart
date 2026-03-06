import 'package:flutter_test/flutter_test.dart';
import 'package:travel_buddy/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should create a UserEntity with correct values', () {
      const user = UserEntity(
        id: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
    });

    test('should support equality', () {
      const user1 = UserEntity(
        id: '123',
        email: 'test@example.com',
      );
      const user2 = UserEntity(
        id: '123',
        email: 'test@example.com',
      );

      expect(user1, equals(user2));
    });

    test('should allow displayName to be null', () {
      const user = UserEntity(
        id: '123',
        email: 'test@example.com',
        displayName: null,
      );

      expect(user.displayName, isNull);
    });
  });
}
