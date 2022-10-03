/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
class R {
  R._();

  static const appName = "上应小风筝";
  static const kiteUserAgreementName = "《上应小风筝用户协议》";
  static const kiteUserAgreementUrl = "https://kite.sunnysab.cn/license/";
  static const kiteWikiUrlFeatures = "https://kite.sunnysab.cn/wiki/kite-app/features/";
  static const forgotLoginPwdUrl =
      "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";
  static const easyConnectDownloadUrl = "https://www.sit.edu.cn/xxfw/list.htm";
  static const kiteAboutUrl = "https://kite.sunnysab.cn/about/";
  static const kiteBbsUrl = "https://support.qq.com/products/386124";
  static const kiteFeedbackUrl = "https://support.qq.com/product/377648";
  static const kiteWikiUrl = "https://kite.sunnysab.cn/wiki/";
}

class CampusCode {
  CampusCode._();

  static const fengxian = 1;
  static const xuhui = 2;
}

class WeatherCode {
  WeatherCode._();

  /// campus 1
  @CampusCode.fengxian
  static const fengxian = "101021000";

  /// campus 2
  @CampusCode.xuhui
  static const xuhui = "101021200";

  static from({required int campus}) => campus == 1 ? fengxian : xuhui;
}
