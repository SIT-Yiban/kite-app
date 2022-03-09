import 'package:hive/hive.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/domain/expense/service/expense.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao/expense.dart';
import 'entity/expense.dart';
import 'storage/expense.dart';

class ExpenseInitializer {
  static late ExpenseRemoteDao expenseRemote;
  static late ExpenseLocalStorage expenseRecord;

  static Future<void> init({required ASession ssoSession}) async {
    registerAdapter(ExpenseRecordAdapter());
    registerAdapter(ExpenseTypeAdapter());
    final expenseRecordBox = await Hive.openBox<ExpenseRecord>('expenseSetting');
    expenseRecord = ExpenseLocalStorage(expenseRecordBox);

    expenseRemote = ExpenseRemoteService(ssoSession);
  }
}
