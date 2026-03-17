# Development tools

## Mock server

Run a local mock server which implements a tiny subset of the DevLog API (auth/register and auth/login).

Start the mock:

```powershell
dart run tool/mock_server.dart
```

Default mock credentials:
- email: test@local
- password: Password123!

Switch `ApiService` to use the mock from your Flutter code before calling API methods:

```dart
import 'package:devlog/data/api_service.dart';

void main() {
  ApiService.useLocalMock();
  runApp(const DevLogProApp());
}
```
