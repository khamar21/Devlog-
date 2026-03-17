// ------------------------------
// Appwrite Client – Updated for SDK v12+
// ------------------------------
import 'package:appwrite/appwrite.dart';
import 'package:devlog_flutter_ui/config/environment.dart';

class AppwriteClient {
  static Client? _client;
  static Account? _account;
  static Databases? _databases;

  /// Main Appwrite client
  static Client get client {
    _client ??= Client()
      ..setEndpoint(Environment.appwritePublicEndpoint)
      ..setProject(Environment.appwriteProjectId)
      ..setSelfSigned(status: true); // For localhost / https testing
    return _client!;
  }

  /// Account API instance
  static Account get account => _account ??= Account(client);

  /// Databases API instance
  static Databases get databases => _databases ??= Databases(client);
}

/// ------------------------------------------------------
/// GLOBAL CLIENT (alias the same instance to avoid drift)
/// ------------------------------------------------------
final Client client = AppwriteClient.client;

/// ------------------------------------------------------
/// HEALTH PING EXTENSION — SDK 20.3.2 compatible
/// ------------------------------------------------------
// Note: Prefer using ApiService.pingAppwrite() for health checks
