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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/home/page/item/electricity.dart';
import 'package:kite/launcher.dart';
import 'package:kite/override/entity.dart';
import 'package:kite/route.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/scanner.dart';
import 'package:kite/util/user.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../entity/home.dart';
import 'exam.dart';
import 'expense.dart';
import 'freshman.dart';
import 'library.dart';
import 'mail.dart';
import 'notice.dart';
import 'office.dart';
import 'report.dart';
import 'upgrade.dart';

class HomeFunctionButton extends StatelessWidget {
  final String? route;
  final String? icon;
  final Widget? iconWidget;
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;

  HomeFunctionButton({
    this.route,
    this.onPressed,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    Key? key,
  }) : super(key: key) {
    assert(icon != null || iconWidget != null);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline4?.copyWith(color: Colors.black54);
    final subtitleStyle = Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.black54);

    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
      child: ListTile(
        leading:
            iconWidget ?? SvgPicture.asset(icon!, height: 30.h, width: 30.w, color: Theme.of(context).primaryColor),
        title: Text(title, style: titleStyle),
        subtitle: Text(subtitle ?? '', style: subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        // dense: true,
        onTap: () {
          if (onPressed != null) {
            onPressed!();
            return;
          }
          if (route != null) {
            Navigator.of(context).pushNamed(route!);
          }
        },
        style: ListTileStyle.list,
      ),
    );
  }
}

class FunctionButtonFactory {
  static final Map<FunctionType, WidgetBuilder> builders = {
    FunctionType.upgrade: (context) => const UpgradeItem(),
    FunctionType.kiteBulletin: (context) => const KiteBulletinItem(),
    FunctionType.timetable: (context) => HomeFunctionButton(
          route: RouteTable.timetable,
          icon: 'assets/home/icon_timetable.svg',
          title: FunctionType.timetable.localized(),
          subtitle: FunctionType.timetable.localizedDesc(),
        ),
    FunctionType.reportTemp: (context) => const ReportTempItem(),
    FunctionType.examArrangement: (context) => const ExamArrangementItem(),
    FunctionType.classroomBrowser: (context) => HomeFunctionButton(
          route: RouteTable.classroomBrowser,
          icon: 'assets/home/icon_classroom.svg',
          title: FunctionType.classroomBrowser.localized(),
          subtitle: FunctionType.classroomBrowser.localizedDesc(),
        ),
    FunctionType.activity: (context) => HomeFunctionButton(
          route: RouteTable.activity,
          icon: 'assets/home/icon_event.svg',
          title: FunctionType.activity.localized(),
          subtitle: FunctionType.activity.localizedDesc(),
        ),
    FunctionType.expense: (context) => const ExpenseItem(),
    FunctionType.examResult: (context) => HomeFunctionButton(
          route: RouteTable.examResult,
          icon: 'assets/home/icon_score.svg',
          title: FunctionType.examResult.localized(),
          subtitle: FunctionType.examResult.localizedDesc(),
        ),
    FunctionType.library: (context) => const LibraryItem(),
    FunctionType.application: (context) => const ApplicationItem(),
    FunctionType.eduEmail: (context) => const EduEmailItem(),
    FunctionType.oaAnnouncement: (context) => HomeFunctionButton(
          route: RouteTable.oaAnnouncement,
          icon: 'assets/home/icon_bulletin.svg',
          title: FunctionType.oaAnnouncement.localized(),
          subtitle: FunctionType.oaAnnouncement.localizedDesc(),
        ),
    FunctionType.yellowPages: (context) => HomeFunctionButton(
          route: RouteTable.yellowPages,
          icon: 'assets/home/icon_contact.svg',
          title: FunctionType.yellowPages.localized(),
          subtitle: FunctionType.yellowPages.localizedDesc(),
        ),
    FunctionType.game: (context) => HomeFunctionButton(
          route: RouteTable.game,
          icon: 'assets/home/icon_game.svg',
          title: FunctionType.game.localized(),
          subtitle: FunctionType.game.localizedDesc(),
        ),
    FunctionType.wiki: (context) => HomeFunctionButton(
          route: RouteTable.wiki,
          icon: 'assets/home/icon_wiki.svg',
          title: FunctionType.wiki.localized(),
          subtitle: FunctionType.wiki.localizedDesc(),
        ),
    FunctionType.separator: (context) => Container(),
    FunctionType.bbs: (context) => UniversalPlatform.isDesktopOrWeb
        ? Container()
        : HomeFunctionButton(
            route: RouteTable.bbs,
            icon: 'assets/home/icon_bbs.svg',
            title: FunctionType.bbs.localized(),
            subtitle: FunctionType.bbs.localizedDesc(),
          ),
    FunctionType.scanner: (context) => UniversalPlatform.isDesktopOrWeb
        ? Container()
        : HomeFunctionButton(
            onPressed: () async {
              final result = await scan(context);
              Log.info('扫码结果: $result');
              if (result != null) GlobalLauncher.launch(result);
            },
            // icon: 'assets/home/icon_bbs.svg',
            iconWidget: Icon(Icons.qr_code_scanner, size: 30.h, color: Theme.of(context).primaryColor),
            title: FunctionType.scanner.localized(),
            subtitle: FunctionType.scanner.localizedDesc(),
          ),
    FunctionType.freshman: (context) => const FreshmanItem(),
    FunctionType.switchAccount: (context) => HomeFunctionButton(
          route: RouteTable.login,
          iconWidget: Icon(Icons.switch_account, size: 30.h, color: Theme.of(context).primaryColor),
          title: FunctionType.switchAccount.localized(),
          subtitle: FunctionType.switchAccount.localizedDesc(),
        ),
    FunctionType.electricityBill: (context) => const ElectricityBillItem(),
    FunctionType.kiteBoard: (context) => HomeFunctionButton(
          route: RouteTable.kiteBoard,
          icon: 'assets/home/icon_board.svg',
          title: FunctionType.kiteBoard.localized(),
          subtitle: FunctionType.kiteBoard.localizedDesc(),
        ),
  };

  static Widget createFunctionButton(BuildContext context, FunctionType type) {
    final builder = builders[type];
    if (builder == null) {
      throw UnimplementedError("未实现的功能项: ${type.name}");
    }
    return builder(context);
  }
}

Widget buildHomeFunctionButtonByExtraHomeItem(BuildContext context, ExtraHomeItem item) {
  return HomeFunctionButton(
    title: item.title,
    subtitle: item.description,
    iconWidget: SvgPicture.network(
      item.iconUrl,
      height: 30.h,
      width: 30.w,
      color: Theme.of(context).primaryColor,
    ),
    route: item.route,
  );
}

class HomeItemHideInfoFilter {
  // Map<functionName, Set<userType>>
  Map<String, Set<String>> map = {};

  HomeItemHideInfoFilter(List<HomeItemHideInfo> hideInfoList) {
    for (final hideInfo in hideInfoList) {
      for (final functionName in hideInfo.nameList) {
        for (final userType in hideInfo.userTypeList) {
          if (!map.containsKey(functionName)) map[functionName] = {};
          map[functionName]!.add(userType);
        }
      }
    }
  }

  // if true then should be hide
  bool accept(FunctionType functionType, UserType userType) {
    if (!map.containsKey(functionType.name)) return false;
    return map[functionType.name]!.contains(userType.name);
  }
}
