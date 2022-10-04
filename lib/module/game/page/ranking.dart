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
import 'package:flutter_svg/flutter_svg.dart';
import '../using.dart';

import '../entity/rank.dart';
import '../init.dart';

class GameRanking extends StatelessWidget {
  static const _colorMapping = [Colors.red, Colors.deepOrange, Colors.orange];
  final int gameId;

  const GameRanking(this.gameId, {Key? key}) : super(key: key);

  /// 构建排行榜行, 下标从 1 开始
  Widget _buildItem(BuildContext context, int index, GameRankingItem item) {
    final color = index > 3 ? Colors.yellow : GameRanking._colorMapping[index - 1];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: Text(index.toString()),
      ),
      minLeadingWidth: 40,
      title: Text(item.studentId),
      trailing: Text(item.score.toString()),
      onTap: () {},
    );
  }

  Widget emptyRanking(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/game/no_content.svg'),
          Text(
            '今日还没有人上榜\n快来一局吧！',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }

  void gotoMyself() {
    // scrollController.jumpTo();
  }

  Widget _buildRankView(BuildContext context, List<GameRankingItem> list) {
    if (list.isEmpty) return emptyRanking(context);

    list.sort((a, b) => b.score - a.score);
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        children: Iterable.generate(list.length, (int i) {
          return _buildItem(context, i + 1, list[i]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyFutureBuilder<List<GameRankingItem>>(
      futureGetter: () => GameInit.rankingService.getGameRanking(gameId),
      enablePullRefresh: true,
      builder: (context, list) {
        return _buildRankView(context, list);
      },
    );
  }
}
