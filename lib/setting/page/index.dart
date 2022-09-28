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
import 'dart:io';

import 'package:dynamic_color_theme/dynamic_color_theme.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kite/global/global.dart';
import 'package:kite/global/hive_initializer.dart';
import 'package:kite/global/init.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/route.dart';
import 'package:kite/storage/dao/pref.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/storage/storage/admin.dart';
import 'package:kite/storage/storage/develop.dart';
import 'package:kite/util/dsl.dart';
import 'package:kite/util/file.dart';
import 'package:kite/util/flash.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/user.dart';
import 'package:kite/util/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';

import 'home.dart';
import 'storage.dart';

class SettingPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final bool isFreshman = AccountUtils.getUserType() == UserType.freshman;

  SettingPage({Key? key}) : super(key: key);

  Widget _negativeActionBuilderCancel(context, controller, _) {
    return TextButton(
      onPressed: () {
        controller.dismiss();
      },
      child: i18n.cancel.txt,
    );
  }

  Widget _negativeActionBuilderNotNow(context, controller, _) {
    return TextButton(
      onPressed: () {
        controller.dismiss();
      },
      child: i18n.notNow.txt,
    );
  }

  Future<void> _onChangeBgImage() async {
    final saveToPath = '${(await getApplicationDocumentsDirectory()).path}/kite1/background';

    if (UniversalPlatform.isDesktop) {
      String? srcPath = await FileUtils.pickImageByFilePicker();
      if (srcPath == null) return;
      await File(srcPath).copy(saveToPath);
    } else {
      XFile? image = await FileUtils.pickImageByImagePicker();
      await image?.saveTo(saveToPath);
    }
    KvStorageInitializer.home.background = saveToPath;
    Global.eventBus.emit(EventNameConstants.onBackgroundChange);
  }

  void _testPassword(BuildContext context) async {
    final user = KvStorageInitializer.auth.currentUsername;
    final password = KvStorageInitializer.auth.ssoPassword;
    try {
      EasyLoading.instance.userInteractions = false;
      EasyLoading.show(status: i18n.loggingIn);
      await Global.ssoSession.login(user!, password!);
      EasyLoading.showSuccess(i18n.loginCredentialsValidatedTip);
    } catch (e) {
      showBasicFlash(context, Text('${i18n.loginFailedWarn}: ${e.toString().split('\n')[0]}'),
          duration: const Duration(seconds: 3));
    } finally {
      EasyLoading.dismiss();
      EasyLoading.instance.userInteractions = true;
    }
  }

  void _gotoWelcome(BuildContext context) {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed(RouteTable.welcome);

    Log.info('重启成功');
  }

  void _onLogout(BuildContext context) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        title: i18n.logout.txt,
        content: i18n.logoutKiteWarn.txt,
        negativeActionBuilder: _negativeActionBuilderCancel,
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async {
                Log.info('退出登录');

                if (isFreshman) {
                  KvStorageInitializer.freshman
                    ..freshmanAccount = null
                    ..freshmanName = null
                    ..freshmanSecret = null;
                } else {
                  KvStorageInitializer.auth
                    ..currentUsername = null
                    ..ssoPassword = null;
                }

                await Initializer.init();

                controller.dismiss();
                _gotoWelcome(context);
              },
              child: i18n.continue_.txt);
        });
  }

  void _onClearStorage(BuildContext context) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        title: i18n.settingsWipeKiteData.txt,
        // TODO: Dedicated descriptions for mobile and desktop.
        content: i18n.settingsWipeKiteDataDesc.txt,
        negativeActionBuilder: _negativeActionBuilderCancel,
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () async {
                await HiveBoxInitializer.clear(); // 清除存储
                await Initializer.init();
                await controller.dismiss();
                _gotoWelcome(context);
              },
              child: i18n.continue_.txt);
        });
  }

  _buildLanguagePrefSelector(BuildContext ctx) {
    final Locale curLocale;
    final savedLocale = KvStorageInitializer.pref.locale;
    if (savedLocale == null) {
      final defaultLocale = Localizations.localeOf(ctx);
      KvStorageInitializer.pref.locale = defaultLocale;
      curLocale = defaultLocale;
    } else {
      curLocale = savedLocale;
    }
    return DropDownSettingsTile<Locale>(
      title: i18n.settingsLanguage,
      subtitle: i18n.settingsLanguageSub,
      leading: const Icon(Icons.translate_rounded),
      settingKey: PrefKey.locale,
      values: {
        Lang.enLocale: i18n.language_en,
        Lang.zhLocale: i18n.language_zh,
        Lang.zhTwLocale: i18n.language_zh_TW,
      },
      selected: curLocale,
      onChange: (value) {
        // TODO: Test on mobile
          Phoenix.rebirth(ctx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _passwordController.text = KvStorageInitializer.auth.ssoPassword ?? '';
    return SettingsScreen(title: i18n.settingsTitle, children: [
      // Personalize
      SettingsGroup(
        title: i18n.personalizeTitle,
        children: <Widget>[
          ColorPickerSettingsTile(
            title: i18n.settingsThemeColor,
            leading: const Icon(Icons.palette_outlined),
            settingKey: ThemeKeys.themeColor,
            defaultValue: KvStorageInitializer.theme.color,
            onChange: (newColor) => DynamicColorTheme.of(context).setColor(
              color: newColor,
              shouldSave: true, // saves it to shared preferences
            ),
          ),
          _buildLanguagePrefSelector(context),
          SwitchSettingsTile(
            settingKey: ThemeKeys.isDarkMode,
            defaultValue: KvStorageInitializer.theme.isDarkMode,
            title: i18n.settingsDarkMode,
            subtitle: i18n.settingsDarkModeSub,
            leading: const Icon(Icons.dark_mode),
            onChange: (value) => DynamicColorTheme.of(context).setIsDark(isDark: value, shouldSave: false),
          ),
        ],
      ),
      // TODO: A new personalize system
      SettingsGroup(
        title: i18n.homepage,
        children: <Widget>[
          RadioSettingsTile<int>(
            title: i18n.settingsHomepageWallpaperMode,
            settingKey: HomeKeyKeys.backgroundMode,
            values: <int, String>{
              1: i18n.realtimeWeather,
              2: i18n.staticPicture,
            },
            selected: KvStorageInitializer.home.backgroundMode,
            onChange: (value) {
              KvStorageInitializer.home.backgroundMode = value;
              Global.eventBus.emit(EventNameConstants.onBackgroundChange);
            },
          ),
          DropDownSettingsTile<int>(
            title: i18n.settingsCampus,
            subtitle: i18n.settingsCampusSub,
            leading: const Icon(Icons.location_on),
            settingKey: HomeKeyKeys.campus,
            values: <int, String>{
              1: i18n.fengxian,
              2: i18n.xuhui,
            },
            selected: KvStorageInitializer.home.campus,
            onChange: (value) {
              KvStorageInitializer.home.campus = value;
              Global.eventBus.emit(EventNameConstants.onCampusChange);
            },
          ),
          SimpleSettingsTile(
              title: i18n.settingsWallpaper,
              subtitle: i18n.settingsWallpaperSub,
              leading: const Icon(Icons.photo_size_select_actual_outlined),
              onTap: _onChangeBgImage),
          if (!isFreshman)
            SimpleSettingsTile(
              title: i18n.settingsFuncRearrange,
              subtitle: i18n.settingsFuncRearrangeSub,
              leading: const Icon(Icons.menu),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeSettingPage())),
            ),
        ],
      ),
      SettingsGroup(title: i18n.networking, children: <Widget>[
        SwitchSettingsTile(
          settingKey: '/network/useProxy',
          defaultValue: KvStorageInitializer.network.useProxy,
          title: i18n.settingsHttpProxy,
          subtitle: i18n.settingsHttpProxySub,
          leading: const Icon(Icons.vpn_key),
          onChange: (value) async {
            KvStorageInitializer.network.useProxy = value;
            await Initializer.init();
          },
          childrenIfEnabled: [
            TextInputSettingsTile(
              title: i18n.settingsProxyAddress,
              settingKey: '/network/proxy',
              initialValue: KvStorageInitializer.network.proxy,
              validator: proxyValidator,
              onChange: (value) async {
                KvStorageInitializer.network.proxy = value;
                if (KvStorageInitializer.network.useProxy) {
                  await Initializer.init();
                }
              },
            ),
            SimpleSettingsTile(
                title: i18n.settingsTestConnect2School,
                subtitle: i18n.settingsTestConnect2SchoolSub,
                onTap: () {
                  Navigator.pushNamed(context, '/connectivity');
                }),
          ],
        ),
      ]),
      // Account
      SettingsGroup(
        title: i18n.account,
        children: <Widget>[
          if (!isFreshman)
            SimpleSettingsTile(
              title: i18n.studentID,
              subtitle: KvStorageInitializer.auth.currentUsername ?? "",
              leading: const Icon(Icons.person_rounded),
              onTap: () {
                // Copy the student ID to clipboard
                final id = KvStorageInitializer.auth.currentUsername;
                if (id != null) {
                  Clipboard.setData(ClipboardData(text: id));
                  showBasicFlash(context, i18n.studentIdCopy2ClipboardTip.txt);
                }
              },
            ),
          if (!isFreshman)
            ModalSettingsTile(
              title: i18n.settingsChangeOaPwd,
              subtitle: i18n.settingsChangeOaPwdSub,
              leading: const Icon(Icons.lock),
              showConfirmation: true,
              onConfirm: () {
                KvStorageInitializer.auth.ssoPassword = _passwordController.text;
                return true;
              },
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(controller: _passwordController, obscureText: true),
                ),
              ],
            ),
          if (!isFreshman)
            SimpleSettingsTile(
                title: i18n.settingsTestLoginKite,
                subtitle: i18n.settingsTestLoginKiteSub,
                leading: const Icon(Icons.login_rounded),
                onTap: () => _testPassword(context)),
          SimpleSettingsTile(
              title: i18n.settingsLogoutKite,
              subtitle: i18n.settingsLogoutKiteSub,
              leading: const Icon(Icons.logout_rounded),
              onTap: () => _onLogout(context)),
        ],
      ),
      // Data Management
      SettingsGroup(title: i18n.dataManagement, children: <Widget>[
        SimpleSettingsTile(
            title: i18n.settingsWipeKiteData,
            leading: const Icon(Icons.remove_circle),
            subtitle: i18n.settingsWipeKiteDataSub,
            onTap: () => _onClearStorage(context)),
      ]),
      // TODO: Remove this
      if (kDebugMode)
        SettingsGroup(
          title: '管理员选项',
          children: <Widget>[
            TextInputSettingsTile(
              title: '"问答" 密钥',
              settingKey: AdminKeys.bbsSecret,
              initialValue: KvStorageInitializer.admin.bbsSecret ?? '',
            ),
          ],
        ),
      SettingsGroup(
        title: i18n.devOptions,
        children: <Widget>[
          SwitchSettingsTile(
              settingKey: DevelopOptionsKeys.showErrorInfoDialog,
              defaultValue: KvStorageInitializer.developOptions.showErrorInfoDialog ?? false,
              title: i18n.settingsDetailedXcpDialog,
              subtitle: i18n.settingsDetailedXcpDialogSub,
              leading: const Icon(Icons.info),
              onChange: (value) {
                KvStorageInitializer.developOptions.showErrorInfoDialog = value;
              }),
          SimpleSettingsTile(
            title: i18n.settingsLocalStorage,
            subtitle: i18n.settingsLocalStorageSub,
            leading: const Icon(Icons.storage),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DebugStoragePage())),
          )
        ],
      ),
    ]);
  }
}
