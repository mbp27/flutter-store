import 'package:http/http.dart' as http;

class AuthHttp {
  static const String _baseUrl = 'dev.pitjarus.co';
  static const String _path = 'api/sariroti_md/index.php';

  Future<http.Response> loginTest({
    required String username,
    required String password,
  }) {
    Map<String, dynamic> body = {
      "username": username,
      "password": password,
    };

    return http.post(
      Uri.https(_baseUrl, '$_path/login/loginTest'),
      body: body,
    );
  }
}
