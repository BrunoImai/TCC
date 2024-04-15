import 'central.dart';

class CentralManager {
  // Private constructor
  CentralManager._();

  // Singleton instance
  static CentralManager? _instance;

  // Getter for the singleton instance
  static CentralManager get instance {
    _instance ??= CentralManager._();
    return _instance!;
  }

  // Other properties and methods of the singleton class
  LoggedCentral? loggedUser;

}
