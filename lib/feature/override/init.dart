import 'package:kite/network/session.dart';
import 'package:kite/feature/override/interface.dart';

import 'cache.dart';
import 'mock.dart';
import 'service.dart';

class FunctionOverrideInitializer {
  static late FunctionOverrideServiceDao cachedService;

  static void init({
    required Session kiteSession,
    required FunctionOverrideStorageDao storageDao,
  }) {
/*    cachedService = FunctionOverrideCachedService(
      serviceDao: FunctionOverrideService(kiteSession),
      storageDao: storageDao,
    );*/
    // TODO: Temporarily disabled for I18n development
    cachedService = FunctionOverrideDisabled();
    // cachedService = FunctionOverrideMock();
  }
}
