import 'package:kite/abstract/abstract_service.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/util/logger.dart';

import 'entity.dart';
import 'interface.dart';

class FunctionOverrideService extends AService implements FunctionOverrideServiceDao {
  FunctionOverrideService(super.session);

  @override
  Future<FunctionOverrideInfo> get() async {
    Log.info('获取拉取动态路由配置');
    final response = await session.request('https://kite.sunnysab.cn/override.json', RequestMethod.get);
    return FunctionOverrideInfo.fromJson(response.data);
  }
}
