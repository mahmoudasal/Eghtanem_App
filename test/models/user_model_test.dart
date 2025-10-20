import 'package:flutter_test/flutter_test.dart';
import 'package:eghtanem_app/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from JSON', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
    });

    test('should convert UserModel to JSON', () {
      final user = UserModel(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@example.com');
    });
  });
}
