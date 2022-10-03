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
class Saying {
  final String text;
  final String sayer;

  const Saying(this.text, this.sayer);

  static const List<Saying> sayings = [
    Saying('书籍是人类思想的宝库', '乌申斯基'),
    Saying('读书百遍，其义自见', '《三国志》'),
    Saying('书籍是前人的经验', '拉布雷'),
    Saying('读书破万卷，下笔如有神', '唐杜甫'),
    Saying('书籍是生活的加速器', '尼克拉耶娃'),
    Saying('读书好，多读书，读好书', '冰心'),
    Saying('书痴者文必工，艺痴者技必良', '蒲松龄'),
    Saying('书籍是巨大的力量', '列宁《读书名言》'),
    Saying('过去一切时代的精华尽在书中', '卡莱尔'),
    Saying('读书忌死读，死读钻牛角', '叶圣陶'),
    Saying('书籍使人变得思想奔放', '革拉特珂夫'),
    Saying('好书是伟大心灵的富贵血脉', '弥尔顿'),
    Saying('书到用时方恨少，事非经过不知难', '陈廷焯'),
    Saying('书籍是造就灵魂的工具', '雨果'),
    Saying('读万卷书，行万里路', '刘彝'),
    Saying('不读书的人，思想就会停止', '狄德罗'),
    Saying('不怕读得少，只怕记不牢', '徐特立'),
    Saying('熟读唐诗三百首，不会作诗也会吟', '孙洙'),
    Saying('读书以过目成诵为能，最是不济事', '郑板桥'),
    Saying('读不在三更五鼓，功只怕一曝十寒', '郭沫若'),
    Saying('书卷多情似故人，晨昏忧乐每相亲', '于谦'),
    Saying('发奋识遍天下字，立志读尽人间书', '苏轼'),
    Saying('读过一本好书，像交了一个益友', '藏克家'),
    Saying('黑发不知勤学早，白首方悔读书迟', '颜真卿'),
    Saying('旧书不厌百回读，熟读精思子自知', '苏轼'),
    Saying('读书志在圣贤，为官心存君国', '朱用纯'),
    Saying('仅次于选择益友，就是选择好书', '考尔德'),
    Saying('和书籍生活在一起，永远不会叹气', '罗曼罗兰'),
    Saying('立身以立学为先，立学以读书为本', '欧阳修'),
    Saying('鸟欲高飞先振翅，人求上进先读书', '李若禅'),
    Saying('书籍是朋友，虽然没有热情，但是非常忠实', '雨果'),
    Saying('读书之乐何处寻，数点梅花天地心', '朱熹'),
    Saying('凿壁偷光，聚萤作囊，忍贫读书，车胤匡衡', '许名奎'),
    Saying('书山有路勤为径，学海无涯苦作舟', '唐代文学家韩愈'),
    Saying('书籍是屹立在时间的汪洋大海中的灯塔', '惠普尔'),
    Saying('读书当将破万卷，求知不叫一疑存', '《关于读书的名言》'),
    Saying('读书是在别人思想的帮助下，建立起自己的思想', '鲁巴金'),
    Saying('人的影响短暂而微弱，书的影响则广泛而深远', '普希金'),
    Saying('早知今日读书是，悔作从前任侠非', '李欣'),
    Saying('读书足以怡情，足以傅彩，足以长才', '培根'),
    Saying('读一本好书，就是和许多高尚的人谈话', '歌德'),
    Saying('读书也像开矿一样沙里淘金', '赵树理'),
    Saying('立志宜思真品格，读书须尽苦功夫', '阮元'),
    Saying('读书不知味，不如束高阁，蠢鱼尔何如，终日食糟粕', '袁牧'),
    Saying('书籍是青年人不可分离的生命伴侣和导师', '高尔基'),
    Saying('书籍是青年人不可分离的生活伴侣和导师', '高尔基'),
    Saying('读书足以恬情，足以博采，足以长才', '培根'),
    Saying('外物之味，久则可厌，读书之味，愈久愈深', '程颢'),
    Saying('书犹药也，善读可以医愚', '刘向'),
    Saying('立品直须同白玉，读书何止到青云', '《力成文学》'),
    Saying('光阴给我们经验，读书给我们知识', '奥斯特洛夫斯基'),
    Saying('读书越多，越感到腹中空虚', '雪莱'),
    Saying('黑发不知勤学早，白发方悔读书迟', '颜真卿'),
    Saying('养心莫若寡欲，至乐无如读书', '郑成功'),
    Saying('读书之乐乐陶陶，起并明月霜天高', '朱熹'),
    Saying('饭可以一日不吃，觉可以一日不睡，书不可以一日不读', '毛泽东'),
    Saying('有时候读书是一种巧妙地避开思考的方法', '赫尔普斯'),
    Saying('除了野蛮国家，整个世界都被书统治着', '福尔特尔'),
    Saying('磋砣莫遗韶光老，人生惟有读书好', '《宋诗纪要》'),
    Saying('劝君莫将油炒菜，留与儿孙夜读书', '《增广贤文》'),
    Saying('读书也像开矿一样，沙里淘金', '赵树理'),
    Saying('读书是我唯一的娱乐', '富兰克林'),
    Saying('各种蠢事，在每天读书的影响下，仿佛在火上一样，渐渐溶化', '雨果'),
    Saying('勤者读书夜达旦，青藤绕屋花连云', '《对联集锦》'),
    Saying('韬略终须建新国，奋发还得读良书', '郭沫若'),
  ];
}
