import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'token_storage.g.dart';

@Riverpod(keepAlive: true)
Future<TokenStorage> tokenStorage(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return TokenStorage(prefs);
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

class TokenStorage {
  final SharedPreferences _prefs;
  static const _tokenKey = 'auth_token';

  TokenStorage(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }
}
