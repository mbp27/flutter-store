import 'dart:convert';
import 'dart:io';

import 'package:pitjarusstore/data/http/auth_http.dart';
import 'package:pitjarusstore/data/models/store.dart';
import 'package:pitjarusstore/data/providers/store_provider.dart';

class AuthProvider {
  final _authHttp = AuthHttp();
  final _storeProvider = StoreProvider();

  /// Login with username
  Future<void> loginTest({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _authHttp.loginTest(
        username: username,
        password: password,
      );
      if (response.statusCode == 404) {
        throw 'Terdapat kesalahan';
      } else {
        final body = json.decode(response.body) as Map;
        if (response.statusCode == 200) {
          if (body['status'] == 'failure') {
            throw body['message'];
          }
          final stores = body['stores'] as List;
          await _storeProvider.clear();
          await _storeProvider.batchInsert(
            stores.map((e) => Store.fromMap(e)).toList(),
          );
        }
      }
    } on SocketException {
      throw 'Periksa koneksi internet';
    } catch (e) {
      rethrow;
    }
  }

  /// For logout current user
  Future<void> logout() async {
    try {
      await _storeProvider.clear();
    } catch (e) {
      rethrow;
    }
  }

  /// For check if user is logged in or not
  Future<bool> isLoggedIn() async {
    try {
      return (await _storeProvider.getStores()).isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
