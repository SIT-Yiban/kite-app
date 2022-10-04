/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import '../using.dart';

import '../dao/report.dart';
import '../entity/record.dart';

class ReportService implements ReportDao {
  final ISession session;

  const ReportService(this.session);

  static const String _historyUrl = 'http://xgfy.sit.edu.cn/report/report/getMyReport';

  @override
  Future<List<ReportHistory>> getHistoryList(String userId) async {
    final response = await session.request(
      _historyUrl,
      ReqMethod.post,
      data: {
        'usercode': userId,
        'batchno': '', // TODO：batchno 填入今天日期？yyyyMMdd
      },
      options: SessionOptions(
        contentType: HeaderConstants.jsonContentType,
        responseType: SessionResType.json,
      ),
    );

    final Map<String, dynamic> data = response.data;
    final responseCode = data['code'];
    if (responseCode == 0) {
      final List userHistory = data['data'];
      return userHistory.map((e) => ReportHistory.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('($responseCode) ${data['msg']}');
  }

  // 获取最新一次历史
  @override
  Future<ReportHistory?> getRecentHistory(String userId) async {
    final historyList = await getHistoryList(userId);
    ReportHistory? result;
    try {
      // 元素不存在时，first getter 会抛出异常.
      result = historyList.first;
    } catch (_) {}
    return result;
  }
}
