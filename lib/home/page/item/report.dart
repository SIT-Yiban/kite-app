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
import 'package:flutter/material.dart';
import 'package:kite/global/global.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/module/symbol.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/dsl.dart';

import 'index.dart';

class ReportTempItem extends StatefulWidget {
  const ReportTempItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportTempItemState();
}

class _ReportTempItemState extends State<ReportTempItem> {
  String? content;

  /// 用于限制仅弹出一次对话框
  bool hasWarnedDialog = false;

  @override
  void initState() {
    Global.eventBus.on(EventNameConstants.onHomeRefresh, _onHomeRefresh);

    return super.initState();
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onHomeRefresh, _onHomeRefresh);
    super.dispose();
  }

  void _onHomeRefresh(_) async {
    final String result = await _buildContent();
    if (!mounted) return;
    setState(() => content = result);
  }

  Future<void> dialogRemind() async {
    if (hasWarnedDialog) return;
    final rs = Kv.report;
    if (rs.enable == null || rs.enable == false) return;

    final now = DateTime.now();
    final expectH = rs.time!.hour;
    final expectM = rs.time!.minute;
    final actualH = now.hour;
    final actualM = now.minute;

    // 超时了
    if (actualH * 60 + actualM > expectH * 60 + expectM) return;

    // 弹框提醒
    final select = await showAlertDialog(
      context,
      title: i18n.reportTempHelper,
      content: i18n.reportTempRequest.txt,
      actionWidgetList: [
        ElevatedButton(onPressed: () {}, child: i18n.yes.txt),
        TextButton(onPressed: () {}, child: i18n.notNow.txt),
      ],
    );
    // 用户没有选择确认上报
    if (select == null || select == 1) return;

    if (!mounted) return;
    await Navigator.of(context).pushNamed(RouteTable.reportTemp);
    hasWarnedDialog = true;
  }

  String _generateContent(ReportHistory history) {
    final today = DateTime.now();
    // 上次上报时间不等于今日时间，表示未上报
    if (history.date != (today.year * 10000 + today.month * 100 + today.day)) {
      Future.delayed(Duration.zero, dialogRemind);
      return i18n.reportTempUnreportedToday;
    }
    final tempState = history.isNormal == 0 ? i18n.reportTempNormal : i18n.reportTempAbnormal;
    return '${i18n.reportTempReportedToday}, $tempState ${history.place}';
  }

  Future<String> _buildContent() async {
    late ReportHistory? history;

    try {
      history = await ReportTempInit.reportService.getRecentHistory(Kv.auth.currentUsername ?? '');
    } catch (e) {
      return '${i18n.failed}: ${e.runtimeType}';
    }
    if (history == null) {
      return i18n.reportTempNoReportRecords;
    }
    // 别忘了本地缓存更新一下.
    Kv.home.lastReport = history;
    return _generateContent(history);
  }

  @override
  Widget build(BuildContext context) {
    // 如果是第一次加载 (非下拉导致的渲染), 加载缓存的上报记录.
    if (content == null) {
      final ReportHistory? lastReport = Kv.home.lastReport;
      // 如果本地没有缓存记录, 加载默认文本. 否则加载记录.
      if (lastReport != null) {
        content = _generateContent(lastReport);
      }
    }
    return HomeFunctionButton(
      route: RouteTable.reportTemp,
      icon: 'assets/home/icon_report.svg',
      title: i18n.ftype_reportTemp,
      subtitle: content ?? i18n.ftype_reportTemp,
    );
  }
}
