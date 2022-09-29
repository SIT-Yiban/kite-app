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
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';
/// REAL. THE PAYLOAD IS IN PINYIN. DONT BLAME ANYONE BUT THE SCHOOL.
/// More reading: https://github.com/sunnysab/zf-tools/blob/master/TRANSLATION.md
@JsonSerializable()
class ExamRoom {
  /// 课程名称
  @JsonKey(name: 'kcmc')
  String courseName = '';

  /// 考试时间. 若无数据, 列表未空.
  @JsonKey(name: 'kssj', fromJson: _stringToList)
  List<DateTime> time = [];

  /// 考试地点
  @JsonKey(name: 'cdmc')
  String place = '';

  /// 考试校区
  @JsonKey(name: 'cdxqmc')
  String campus = '';

  /// 考试座号
  @JsonKey(name: 'zwh', fromJson: _stringToInt)
  int seatNumber = 0;

  /// 是否重修
  @JsonKey(name: 'cxbj', defaultValue: '未知')
  String isSecondExam = '';

  ExamRoom();

  factory ExamRoom.fromJson(Map<String, dynamic> json) => _$ExamRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ExamRoomToJson(this);

  @override
  String toString() {
    return 'ExamRoom{courseName: $courseName, time: $time, place: $place, campus: $campus, seatNumber: $seatNumber, isSecondExam: $isSecondExam}';
  }

  static int _stringToInt(String s) => int.tryParse(s) ?? 0;

  static List<DateTime> _stringToList(String s) {
    List<DateTime> result = [];
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm');

    try {
      final date = s.split('(')[0];
      final time = s.split('(')[1].replaceAll(')', '');
      String start = '$date ${time.split('-')[0]}';
      String end = '$date ${time.split('-')[1]}';

      final startTime = dateFormat.parse(start);
      final endTime = dateFormat.parse(end);

      result.add(startTime);
      result.add(endTime);
    } catch (_) {}

    return result;
  }
}
