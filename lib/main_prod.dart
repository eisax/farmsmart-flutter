import 'app_bootstrap.dart';
import 'model/repositories/flamelink_repository_provider.dart';

void main() {
  runFarmSmartApp(
    environment: 'production',
    buildFlavor: 'Production',
    repositoryProvider: FlameLinkRepositoryProvider(),
    lockPortraitOrientation: true,
    useFirebase: true,
  );
}
