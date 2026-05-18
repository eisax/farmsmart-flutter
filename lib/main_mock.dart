import 'app_bootstrap.dart';
import 'model/repositories/mock_repository_provider.dart';

void main() {
  runFarmSmartApp(
    environment: 'development',
    buildFlavor: 'Development',
    repositoryProvider: MockRepositoryProvider(),
    useFirebase: false,
  );
}
