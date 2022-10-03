import '../entity/info.dart';
import '../entity/relationship.dart';
import '../entity/statistics.dart';

abstract class FreshmanDao {
  Future<FreshmanInfo> getInfo();

  Future<void> update({Contact? contact, bool? visible});

  Future<List<Mate>> getRoommates();

  Future<List<Familiar>> getFamiliars();

  Future<List<Mate>> getClassmates();

  Future<Analysis> getAnalysis();

  Future<void> postAnalysisLog();
}
