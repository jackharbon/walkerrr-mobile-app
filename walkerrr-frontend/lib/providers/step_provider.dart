import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

int globalSteps = 0;

class StepsContext {
  updateGlobalSteps(newGlobalSteps) {
    globalSteps = newGlobalSteps;
    print('---- StepContext on step_provider:\n$globalSteps');
  }
}
