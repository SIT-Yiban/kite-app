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

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kite/design/utils.dart';
import 'package:kite/events/bus.dart';
import 'package:kite/events/events.dart';
import 'package:kite/exception/session.dart';
import 'package:kite/global/global.dart';
import 'package:kite/module/login/init.dart';
import 'package:kite/module/shared/service/weather.dart';
import 'package:kite/module/timetable/using.dart';
import 'package:kite/override/entity.dart';
import 'package:kite/override/init.dart';
import 'package:kite/quick_button/init.dart';
import 'package:kite/user_widget/color_saturation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../brick_maker.dart';
import '../entity/home.dart';
import '../homepage_factory.dart';
import '../init.dart';
import '../magic_brick/index.dart';
import '../user_widget/drawer.dart';
import '../user_widget/greeting.dart';
import 'background.dart';

class HomeItemGroup extends StatelessWidget {
  final List<Widget> items;

  const HomeItemGroup(this.items, {super.key});

  Widget buildGlassmorphismBg() {
    return GlassmorphismBackground(sigmaX: 5, sigmaY: 12, colors: [
      const Color(0xFFffffff).withOpacity(0.8),
      const Color(0xFF000000).withOpacity(0.8),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            buildGlassmorphismBg(),
            Column(
              children: items,
            ),
          ],
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final overrideFunctionNotifier = ValueNotifier<FunctionOverrideInfo?>(null);
  double saturation = 1;

  @override
  void initState() {
    super.initState();
    Log.info('开始加载首页');

    Future.delayed(Duration.zero, () async {
      // Remove auto launch timetable function permanently
      /* if (Kv.home.autoLaunchTimetable ?? false) {
        Navigator.of(context).pushNamed(RouteTable.timetable);
      }*/
      // 非新生才执行该网络检查逻辑
      if (Auth.hasLoggedIn && await HomeInit.ssoSession.checkConnectivity()) {
        if (!mounted) return;
        showBasicFlash(
          context,
          i18n.homepageCampusNetworkConnected.text(),
          duration: const Duration(seconds: 3),
        );
      }
    });

    _onHomeRefresh(context);
    // 非新生且使用手机
    if (Auth.hasLoggedIn && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
      QuickButton.init(context);
    }
    Global.eventBus.on(EventNameConstants.onCampusChange, (_) => _updateWeather());
    Global.eventBus.on(EventNameConstants.onHomeItemReorder, (_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Build Home');
    return ColorSaturationFilteredWidget(
      saturation: saturation,
      child: Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          child: buildBody(context),
          onHorizontalDragEnd: (d) {
            // 速度达标，展示drawer
            if (d.velocity.pixelsPerSecond.dx > 100) {
              _scaffoldKey.currentState?.openDrawer();
            }
          },
        ),
        drawer: const KiteDrawer(),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  void _updateWeather() {
    Log.info('更新天气');
    Future.delayed(const Duration(milliseconds: 800), () async {
      try {
        final weather = await WeatherService().getCurrentWeather(Kv.home.campus);
        Global.eventBus.emit(EventNameConstants.onWeatherUpdate, weather);
      } catch (_) {}
    });
  }

  Future<void> _doLogin(BuildContext context, OACredential oaCredential) async {
    await HomeInit.ssoSession.loginPassive(oaCredential);

    if (Kv.auth.personName == null) {
      final personName = await LoginInit.authServerService.getPersonName();
      Kv.auth.personName = personName;
    }
  }

  /// 显示检查网络的flash
  void _showCheckNetwork(BuildContext context, {Widget? title}) {
    showBasicFlash(
      context,
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(Icons.dangerous),
        title ?? i18n.homepageCampusNetworkDisconnected.text(),
        TextButton(
          child: i18n.openNetworkToolBtn.text(),
          onPressed: () => Navigator.of(context).pushNamed(RouteTable.networkTool),
        )
      ]),
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _onHomeRefresh(
    BuildContext context, {
    bool loginSso = false, // 默认不登录oa，使用懒加载的方式登录
  }) async {
    final oaCredential = Auth.oaCredential;
    if (loginSso && oaCredential != null) {
      // 如果未登录 (老用户直接进入 Home 页不会处于登录状态, 但新用户经过 login 页时已登录)
      try {
        await _doLogin(context, oaCredential);
        if (!mounted) return;
        showBasicFlash(context, i18n.kiteLoggedInTip.text());
      } on Exception catch (e) {
        // 如果是认证相关问题, 弹出相应的错误信息.
        if (e is UnknownAuthException || e is CredentialsInvalidException) {
          showBasicFlash(context, Text('${i18n.loginFailedWarn}: $e'));
        } else {
          // 如果是网络问题, 提示检查网络.
          _showCheckNetwork(context, title: i18n.networkXcpWarn.text());
        }
      } catch (e, s) {
        Catcher.reportCheckedError(e, s);
      }
    }
    if (HomeInit.ssoSession.isOnline) {
      Global.eventBus.emit(EventNameConstants.onHomeRefresh);
    }
    FireOn.homepage(HomeRefreshEvent(isOnline: HomeInit.ssoSession.isOnline));
    _refreshController.refreshCompleted(resetFooterState: true);

    // 下拉也要更新一下天气 :D
    _updateWeather();

    // TODO 未设置缓存策略，暂时先直接清空缓存
    Kv.override.cache = null;
    FunctionOverrideInit.cachedService.get().then((value) {
      Global.eventBus.emit(
        EventNameConstants.onRouteRefresh,
        value,
      );
      final locale = Kv.pref.locale;
      if (locale != null && locale.languageCode == "zh") {
        overrideFunctionNotifier.value = value;
        if (!mounted) return;
        setState(() => saturation = value.homeColorSaturation);
      }
    });
  }

  Widget _buildTitleLine(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        onDoubleTap: () => Navigator.of(context).pushNamed(RouteTable.easterEgg),
        child: Center(child: SvgPicture.asset('assets/home/kite.svg', width: 80.w, height: 80.h)),
      ),
    );
  }

  List<Widget> buildBricksWidgets(List<ExtraHomeItem>? extraItemList, List<HomeItemHideInfo>? hideInfoList) {
    // print(extraItemList);
    final userType = Auth.lastUserType;
    List<FType> list = Kv.home.homeItems ?? BrickMaker.makeDefaultBricks();
    final filter = HomeItemHideInfoFilter(hideInfoList ?? []);

    // 先遍历一遍，过滤相邻重复元素
    FType lastItem = list.first;
    for (int i = 1; i < list.length; ++i) {
      if (lastItem == list[i]) {
        list.removeAt(i);
        i -= 1;
      } else {
        lastItem = list[i];
      }
    }

    final separator = SizedBox(height: 12.h);
    final List<Widget> result = [];
    List<Widget> currentGroup = [];

    for (final item in list) {
      if (item == FType.separator) {
        result.addAll([
          HomeItemGroup([...currentGroup]),
          separator
        ]);
        currentGroup.clear();
      } else {
        if (userType == null || !filter.willHide(item, userType)) {
          final brick = HomepageFactory.buildBrickWidget(context, item);
          if (brick != null) {
            currentGroup.add(brick);
          }
        }
      }
    }
    if (currentGroup.isNotEmpty) {
      result.add(HomeItemGroup([...currentGroup]));
      currentGroup.clear();
    }

    if (extraItemList != null) {
      result.addAll([
        HomeItemGroup(
          extraItemList.map((e) => buildBrickWidgetByExtraHomeItem(context, e)).toList(),
        ),
        separator,
      ]);
    }

    return [
      const GreetingWidget(),
      separator,
      ...result,
      separator,
      Image.asset('assets/home/bottom.png'),
    ];
  }

  Widget buildMainBody() {
    Widget buildByChildren(List<Widget> items) {
      return SliverList(
        // Functions
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: items[index],
          ),
          childCount: items.length,
        ),
      );
    }

    return ValueListenableBuilder<FunctionOverrideInfo?>(
      valueListenable: overrideFunctionNotifier,
      builder: (context, data, child) => buildByChildren(
        buildBricksWidgets(
          data?.extraHomeItem,
          data?.homeItemHide,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(0x3F),
            Theme.of(context).isDark ? BlendMode.colorBurn : BlendMode.dst,
          ),
          child: const HomeBackground(),
        ),
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          header: BezierHeader(bezierColor: Colors.white54, rectHeight: 20),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white70),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                // AppBar
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(RouteTable.settings),
                    icon: const Icon(Icons.settings, color: Colors.white70),
                  ),
                ],
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: _buildTitleLine(context),
                ),
                expandedHeight: 0.6.sh,
                backgroundColor: Colors.transparent,
                centerTitle: false,
                elevation: 0,
                pinned: false,
              ),
              buildMainBody(),
            ],
          ),
          onRefresh: () => _onHomeRefresh(context, loginSso: true),
        ),
      ],
    );
  }

  @override
  void dispose() {
    Global.eventBus.off(EventNameConstants.onCampusChange);
    Global.eventBus.off(EventNameConstants.onHomeItemReorder);
    _refreshController.dispose();
    super.dispose();
  }

  Widget? buildFloatingActionButton() {
    if (!UniversalPlatform.isDesktopOrWeb) {
      return null;
    }
    return FloatingActionButton(
      child: const Icon(Icons.refresh),
      onPressed: () async {
        // 刷新页面
        Log.info('浮动按钮被点击');
        // 触发下拉刷新
        final pos = _refreshController.position!;
        await pos.animateTo(-100, duration: const Duration(milliseconds: 800), curve: Curves.fastLinearToSlowEaseIn);
      },
    );
  }
}
