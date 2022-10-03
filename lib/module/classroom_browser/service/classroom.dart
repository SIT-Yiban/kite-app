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

import '../dao/remote.dart';
import '../entity/classroom.dart';
import '../using.dart';

class ClassroomService implements ClassroomRemoteDao {
  static const _classroomUrl = '/classroom/available';

  final ISession session;
  const ClassroomService(this.session);

  @override
  Future<List<AvailableClassroom>> queryAvailableClassroom(int campus, String date) async {
    final response = await session.request('$_classroomUrl?campus=$campus&date=$date', ReqMethod.get);
    final List classrooms = response.data;

    return classrooms.map((e) => AvailableClassroom.fromJson(e as Map<String, dynamic>)).toList();
  }
}
