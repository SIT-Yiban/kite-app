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
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:kite/module/activity/using.dart';
import 'package:kite/module/expense2/dao/getter.dart';
import 'package:kite/module/expense2/entity/remote.dart';

class ExpenseGetService implements ExpenseGetDao {
  static DateFormat tsFormat = DateFormat("yyyymmddHHMMSS");
  static const String keyX = "YWRjNGFjNjgyMmZkNDYyNzgwZjg3OGI4NmNiOTQ2ODg=";
  static const urlX = "aHR0cHM6Ly94Z2Z5LnNpdC5lZHUuY24veWt0YXBpL3NlcnZpY2VzL3F1ZXJ5dHJhbnNzZXJ2aWNlL3F1ZXJ5dHJhbnM=";
  static const ua =
      "User-Agent': 'Mozilla/5.0 (Linux; Android 11; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/105.0.5195.136 Mobile Safari/537.36 uni-app Html5Plus/1.0 (Immersed/35.555553)";
  final ISession session;

  ExpenseGetService(this.session);

  @override
  Future<DatapackRaw> get(String studentID, {required DateTime from, required DateTime to}) async {
    String curTs = tsFormat.format(DateTime.now());
    String fromTs = tsFormat.format(from);
    String toTs = tsFormat.format(to);
    String auth = composeAuth(studentID, fromTs, toTs, curTs);
    String url = utf8.decode(base64.decode(urlX));
    final res = await session.request(url, ReqMethod.get,
        para: {
          'timestamp': curTs,
          'starttime': fromTs,
          'endtime': toTs,
          'sign': auth,
          'sign_method': 'HMAC',
          'stuempno': studentID,
        },
        options: SessionOptions(headers: {"User-Agent": ua}));
    return anaylzeJson(res.data);
  }

  DatapackRaw anaylzeJson(dynamic data) {
    var jsonData = utf8.decode(data);
    var res = json.decode(jsonData);
    return DatapackRaw.fromJson(res);
  }

  String composeAuth(String studentId, String from, String to, String cur) {
    String realKey = utf8.decode(base64.decode(keyX));
    String full = studentId + from + to + cur;
    var msg = utf8.encode(full);
    var key = utf8.encode(realKey);
    var hmac = Hmac(sha1, key);
    return hmac.convert(msg).toString();
  }
}
