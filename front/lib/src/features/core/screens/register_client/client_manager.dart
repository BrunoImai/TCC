import 'client.dart';

class ClientManager {
  // Private constructor
  ClientManager._();

  // Singleton instance
  static ClientManager? _instance;

  // Getter for the singleton instance
  static ClientManager get instance {
    _instance ??= ClientManager._();
    return _instance!;
  }

  ClientInformations? clientInformations;
}

