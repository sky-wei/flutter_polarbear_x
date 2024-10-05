/*
 * Copyright (c) 2022 The sky Authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/core/settings.dart';
import 'package:flutter_polarbear_x/data/item/locale_item.dart';
import 'package:flutter_polarbear_x/data/item/theme_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_dropdown_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:provider/provider.dart';


class PreferencePage extends StatefulWidget {

  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {

  final List<ThemeItem> _modeItems = [
    ThemeItem(S.current.followSystem, ThemeItem.system),
    ThemeItem(S.current.brightColorMode, ThemeItem.light),
    ThemeItem(S.current.darkMode, ThemeItem.dark),
  ];

  final List<LocaleItem> _localItems = [
    LocaleItem(S.current.followSystem, null),
    LocaleItem(S.current.english, const Locale.fromSubtags(languageCode: 'en')),
    LocaleItem(S.current.simplifiedChinese, const Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN')),
  ];

  late AppMobileModel _appModel;
  late XSettings _appSetting;

  @override
  void initState() {
    _appModel = context.read<AppMobileModel>();
    _appSetting = _appModel.appSetting;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(S.of(context).preference),
      titleTextStyle: TextStyle(
        color: Theme.of(context).mainTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  /// 创建界面内容
  Widget _buildBodyContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      children: [
        SubListWidget(
          children: [
            SubDropdownWidget<ThemeItem>(
              padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 15),
              title: S.of(context).theme,
              value: _getCurTheme(),
              items: _modeItems,
              onChanged: (value) => _setTheme(value),
            )
          ],
        ),
        XBox.vertical20,
        SubListWidget(
          children: [
            SubDropdownWidget<LocaleItem>(
              padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 15),
              title: S.of(context).language,
              value: _getCurLocale(),
              items: _localItems,
              onChanged: (value) => _setLocale(value),
            )
          ],
        ),
      ],
    );
  }

  ThemeItem _getCurTheme() {
    final mode = _appSetting.getDarkMode(ThemeItem.system);
    return _modeItems.firstWhere((theme) {
      return theme.value == mode;
    }, orElse: () => _modeItems[0]);
  }

  void _setTheme(ThemeItem theme) {
    if (theme != _getCurTheme()) {
      _appSetting.setDarkMode(theme.value).then((value) {
        _appModel.restartApp(context);
      });
    }
  }

  LocaleItem _getCurLocale() {
    final curLocale = _appSetting.getLocale();
    return _localItems.firstWhere((locale) {
      return locale.value == curLocale;
    }, orElse: () => _localItems[0]);
  }

  void _setLocale(LocaleItem locale) {

    if (locale == _getCurLocale()) {
      return;
    }

    _appSetting.setLocale(locale.value).then((value) {
      _appModel.restartApp(context);
    });
  }
}
