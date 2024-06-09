import 'worker.dart';

class WorkerManager {
  // Private constructor
  WorkerManager._();

  // Singleton instance
  static WorkerManager? _instance;

  // Getter for the singleton instance
  static WorkerManager get instance {
    _instance ??= WorkerManager._();
    return _instance!;
  }

  WorkerInformations? clientInformations;

  LoggedWorker? loggedUser;
}

