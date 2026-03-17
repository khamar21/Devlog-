import 'dart:convert';
import 'dart:io';

// Simple mock server for DevLog API.
// Run with: dart run tool/mock_server.dart

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
  print('Mock server listening on http://localhost:3000');

  await for (final req in server) {
    final path = req.uri.path;
    final method = req.method;

    try {
      if (path == '/api/auth/login' && method == 'POST') {
        final body = await utf8.decoder.bind(req).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final email = data['email'] as String? ?? '';
        final password = data['password'] as String? ?? '';

        // Accept a single test user
        if (email == 'test@local' && password == 'Password123!') {
          final resp = {
            'token': 'local-test-token',
            'user': {'id': '1', 'name': 'Local Test', 'email': email}
          };
          _json(req.response, 200, resp);
        } else {
          _json(req.response, 401, {'message': 'Invalid credentials'});
        }
      } else if (path == '/api/auth/register' && method == 'POST') {
        final body = await utf8.decoder.bind(req).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final name = data['name'] as String? ?? 'New User';
        final email = data['email'] as String? ?? 'unknown@local';

        final resp = {
          'id': '2',
          'name': name,
          'email': email,
        };
        _json(req.response, 201, resp);
      } else {
        _json(req.response, 404, {'message': 'Not found'});
      }
    } catch (e, st) {
      _json(req.response, 500, {'error': e.toString(), 'stack': st.toString()});
    }
  }
}

void _json(HttpResponse res, int status, Object body) {
  res.statusCode = status;
  res.headers.contentType = ContentType.json;
  res.write(jsonEncode(body));
  res.close();
}
