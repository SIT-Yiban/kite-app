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

import 'dart:core';

import '../entity/list.dart';

class ScScoreSummary {
  /// Subject report (主题报告)
  final double lecture;

  /// Social practice (社会实践)
  final double practice;

  /// Innovation, entrepreneurship and creativity.(创新创业创意)
  final double creation;

  /// Campus safety and civilization.(校园安全文明)
  final double safetyEdu;

  /// Charity and Volunteer.(公益志愿)
  final double voluntary;

  /// Campus culture.(校园文化)
  final double campus;

  const ScScoreSummary({
    this.lecture = 0,
    this.practice = 0,
    this.creation = 0,
    this.safetyEdu = 0,
    this.voluntary = 0,
    this.campus = 0,
  });

  @override
  String toString() {
    return 'ScScoreSummary{themeReport: $lecture, socialPractice: $practice, '
        'creativity: $creation, safetyCivilization: $safetyEdu, '
        'charity: $voluntary, campusCulture: $campus}';
  }
}

class ScScoreItem {
  /// 活动编号
  final int activityId;

  /// 活动类型
  final ActivityType type;

  /// 分数
  final double amount;

  ScScoreItem(this.activityId, this.type, this.amount);

  @override
  String toString() {
    return 'ScScoreItem{activityId: $activityId, category: $type, amount: $amount}';
  }
}

class ScActivityApplication {
  /// 申请编号
  final int applyId;

  /// 活动编号
  final int activityId;

  /// 活动标题
  final String title;

  /// 申请时间
  final DateTime time;

  /// 活动状态
  final String status;

  ScActivityApplication(this.applyId, this.activityId, this.title, this.time, this.status);

  @override
  String toString() {
    return 'ScActivityItem{activityId: $activityId, time: $time, status: $status}';
  }
}

class ScJoinedActivity {
  /// 申请编号
  final int applyId;

  /// 活动编号
  final int activityId;

  /// 活动标题
  final String title;

  /// 申请时间
  final DateTime time;

  /// 活动状态
  final String status;

  /// 总得分
  final double amount;

  ScJoinedActivity(this.applyId, this.activityId, this.title, this.time, this.status, this.amount);
}
