import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<Map<String, dynamic>?> loginUser(String email, String password);
  Future<void> cacheToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box _authBox;

  AuthLocalDataSourceImpl() : _authBox = Hive.box('authBox');

  @override
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    /// dummy credentials check
    if (email == 'admin@plexus.com' && password == 'password123') {
      return {
        'user': {'email': email, 'name': 'Admin User'},
        'token': 'fake_jwt_token_123',
      };
    }
    return null;
  }

  @override
  Future<void> cacheToken(String token) async {
    await _authBox.put('token', token);
  }
}
