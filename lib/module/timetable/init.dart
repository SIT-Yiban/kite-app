/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'using.dart';

import 'cache.dart';
import 'service/kite.dart';
import 'service/school.dart';
import 'storage/timetable.dart';

class TimetableInit {
  static late TimetableService timetableService;
  static late TimetableStorage timetableStorage;
  static late KiteTimetableService kiteTimetableService;
  static late TableCache tableCache;

  static Future<void> init({
    required ISession eduSession,
    required ISession kiteSession,
    required Box<dynamic> timetableBox,
  }) async {
    timetableService = TimetableService(eduSession);
    timetableStorage = TimetableStorage(timetableBox);
    tableCache = TableCache();
    kiteTimetableService = KiteTimetableService(kiteSession);
  }
}
