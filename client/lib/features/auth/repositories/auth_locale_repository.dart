import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_locale_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocaleRepository authLocaleRepository(Ref ref) {
  return AuthLocaleRepository();
}
class AuthLocaleRepository {
  late SharedPreferences _sharedPreferences ;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  } 

  Future<void> setToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      await _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    final token = _sharedPreferences.getString('x-auth-token');
    if (token == null || token.isEmpty) return null;
    return token;
  }
}