import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import '/provider/provides.dart';

final locator = GetIt.instance;
final appData = locator.get<GetStorage>();

void diSetup() {
  locator.registerSingleton<GetStorage>(GetStorage());
  // locator.registerSingleton<WebViewController>(WebViewController());
  locator.registerSingleton<DistanceProvider>(DistanceProvider());
  locator.registerSingleton<GenericDi>(GenericDi());
  locator.registerSingleton<PlcaeMarkAddress>(PlcaeMarkAddress());
}
