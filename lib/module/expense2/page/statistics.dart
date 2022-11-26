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
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kite/module/activity/using.dart';

import '../entity/local.dart';
import '../using.dart';
// TODO: I18n

class ExpenseChart extends StatelessWidget {
  final List<double>? xAxis;
  final Widget Function(double value, TitleMeta meta)? bottomTitle;
  final List<double> dailyExpense;
  final bool? isZero;
  const ExpenseChart(this.dailyExpense, {Key? key, this.isZero, this.xAxis, this.bottomTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final expenseMapping = dailyExpense.asMap();

    List<FlSpot> spots;

    if (isZero != null && isZero == true) {
      spots = expenseMapping.keys.map((i) => FlSpot(xAxis?[i] ?? (i).toDouble(), expenseMapping[i] ?? 0.0)).toList();
    } else {
      spots =
          expenseMapping.keys.map((i) => FlSpot(xAxis?[i] ?? (i + 1).toDouble(), expenseMapping[i] ?? 0.0)).toList();
    }

    return LineChart(
      LineChartData(
        ///触摸控制
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.transparent), touchSpotThreshold: 10),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        lineBarsData: [
          // 每一个 LineChartBarData 代表一条曲线.
          LineChartBarData(
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).secondaryHeaderColor.withAlpha(60),
            ),
            spots: spots,
            color: primaryColor,
            preventCurveOverShooting: false,
            // isCurved: true, //我觉得折线图更好看一点
            barWidth: 2,
            preventCurveOvershootingThreshold: 3.0,
          ),
        ],

        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(),
            leftTitles: AxisTitles(),
            topTitles: AxisTitles(),
            bottomTitles: bottomTitle != null
                ? AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 25, getTitlesWidget: bottomTitle))
                : AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 25))),
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  final List<Transaction> records;

  const StatisticsPage({Key? key, required this.records}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final now = DateTime.now();

  late int selectedYear = now.year;
  late int selectedMonth = now.month;
  List<int> _getYear(List<Transaction> expenseBillDesc) {
    List<int> years = [];

    final currentYear = now.year;
    final int startYear = expenseBillDesc.isNotEmpty ? expenseBillDesc.last.datetime.year : currentYear;
    for (int year = startYear; year <= currentYear; year++) {
      years.add(year);
    }
    return years;
  }

  List<int> _getMonth(List<Transaction> expenseBill, List<int> years, int year) {
    List<int> result = [];
    if (now.year == year) {
      for (int month = 1; month <= now.month; month++) {
        result.add(month);
      }
    } else if (years.first == year) {
      for (int month = expenseBill.last.datetime.month; month <= 12; month++) {
        result.add(month);
      }
    } else {
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
    return result;
  }

  Widget _buildDateSelector() {
    // TODO: 支持查看全年统计, 此时 chart line 也需要修改.
    final List<int> years = _getYear(widget.records);
    final List<int> months = _getMonth(widget.records, years, selectedYear);

    // TODO: 年月不超过当前日期.
    final yearWidgets = years.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();
    final monthWidgets = months.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();

    final titleStyle = Theme.of(context).textTheme.headline2;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          PopupMenuButton(
            onSelected: (int value) => setState(() {
              selectedYear = value;
              final monthList = _getMonth(widget.records, years, selectedYear);
              if (!monthList.toSet().contains(selectedMonth)) {
                selectedMonth = monthList[0];
              }
            }),
            child: Text('$selectedYear 年', style: titleStyle),
            itemBuilder: (_) => yearWidgets,
          ),
          PopupMenuButton(
            onSelected: (int value) => setState(() => selectedMonth = value),
            child: Text(' $selectedMonth 月', style: titleStyle),
            itemBuilder: (_) => monthWidgets,
          ),
        ],
      ),
    );
  }

  // TODO: 这个函数应该放在 DAO 或 service
  List<Transaction> _filterExpense() {
    return widget.records
        .where((element) => element.datetime.year == selectedYear && element.datetime.month == selectedMonth)
        .toList();
  }

  static int _getDayCountOfMonth(int year, int month) {
    final int daysFeb = (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? 29 : 28;
    List<int> days = [31, daysFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  Widget _buildChartView() {
    // 得到该年该月有多少天, 生成数组记录每一天的消费.
    final List<double> daysAmount = List.filled(_getDayCountOfMonth(selectedYear, selectedMonth), 0.00);
    // 便利该月消费情况, 加到上述统计列表中.
    _filterExpense().forEach(
        (e) => daysAmount[e.datetime.day - 1] += ((delta) => delta < 0 ? -delta : 0)(e.balanceAfter - e.balanceBefore));

    if (daysAmount.every((double e) => e.abs() < 0.01)) {
      return const SizedBox(height: 70, child: Center(child: Text('该月无消费数据')));
    }

    final width = MediaQuery.of(context).size.width - 70;
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: Text('支出对比', style: Theme.of(context).textTheme.headline2),
            ),
            // const SizedBox(height: 5),
            Center(
              child: SizedBox(height: width * 0.5, width: width, child: ExpenseChart(daysAmount)),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildClassifiedStat() {
    // 各分类下消费的统计
    List<double> sumByClassification = List.filled(TransactionType.values.length, 0.0);
    for (final line in _filterExpense()) {
      sumByClassification[line.type.index] +=
          ((delta) => delta < 0 ? -delta : 0)(line.balanceAfter - line.balanceBefore);
    }
    final backgroundColor = Theme.of(context).secondaryHeaderColor;

    double sum = sumByClassification.fold(0.0, (previousValue, element) => previousValue += element);

    return TransactionType.values.where((element) => element != TransactionType.consume).map(
      (expenseType) {
        final double sumInType = sumByClassification[expenseType.index];
        final double percentage = sum != 0 ? sumInType / sum : 0;

        return ListTile(
          leading: Icon(expenseType.icon),
          title: Text(expenseType.localized(), style: Theme.of(context).textTheme.subtitle1),
          subtitle: LinearProgressIndicator(value: percentage, backgroundColor: backgroundColor),
          // 下方 SizedBox 用于限制文字宽度, 使左侧进度条的右端对齐.
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¥ ${sumInType.toStringAsFixed(2)}'),
              SizedBox(
                width: 60,
                child: Text(
                  '${(percentage * 100).toStringAsFixed(2)}%',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          dense: true,
        );
      },
    ).toList();
  }

  Widget _buildClassificationView() {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            child: Text(i18n.expenseCats, style: Theme.of(context).textTheme.headline2),
          ),
          Column(
            children: _buildClassifiedStat(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildDateSelector(),
          _buildChartView(),
          _buildClassificationView(),
        ],
      ),
    );
  }
}
