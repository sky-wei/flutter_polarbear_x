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
import 'package:flutter_polarbear_x/desktop/model/app_desktop_model.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:provider/provider.dart';


class PreferenceWidget extends StatefulWidget {

  const PreferenceWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PreferenceWidgetState();
}

class PreferenceWidgetState extends State<PreferenceWidget> {

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

  late AppDesktopModel _appModel;
  late XSettings _appSetting;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppDesktopModel>();
    _appSetting = _appModel.appSetting;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XBox.vertical10,
        Text(
          S.of(context).preference,
          style: const TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).theme,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical5,
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 180,
          ),
          child: DropdownButton<ThemeItem>(
            value: _getCurTheme(),
            isExpanded: true,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface
            ),
            items: _buildThemeMenuItem(_modeItems),
            onChanged: (value) => _setTheme(value!),
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).language,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical5,
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 180,
          ),
          child: DropdownButton<LocaleItem>(
            value: _getCurLocale(),
            isExpanded: true,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface
            ),
            items: _buildLocalMenuItem(_localItems),
            onChanged: (value) => _setLocale(value!),
          )
        )
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

  List<DropdownMenuItem<ThemeItem>> _buildThemeMenuItem(List<ThemeItem> items) {
    return items.map<DropdownMenuItem<ThemeItem>>((ThemeItem value) {
      return DropdownMenuItem<ThemeItem> (
        value: value,
        child: Text(value.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<LocaleItem>> _buildLocalMenuItem(List<LocaleItem> items) {
    return items.map<DropdownMenuItem<LocaleItem>>((LocaleItem value) {
      return DropdownMenuItem<LocaleItem> (
        value: value,
        child: Text(value.name),
      );
    }).toList();
  }
}

