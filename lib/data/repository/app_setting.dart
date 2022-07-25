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
import 'package:shared_preferences/shared_preferences.dart';

import '../../page/setting/preference_widget.dart';

class AppSetting {

  final SharedPreferences _preferences;

  AppSetting(this._preferences);

  Future<void> load() async {

  }

  int getTheme() {
    return _preferences.getInt('theme_mode') ?? ThemeItem.system;
  }

  Future<bool> setTheme(int mode) async {
    return await _preferences.setInt('theme_mode', mode);
  }

  Locale? getLocale() {
    final language = _preferences.getString('language');
    if (language != null && language.isNotEmpty) {
      final values = language.split('_');
      if (values.length == 2 && values[0].isNotEmpty) {
        final languageCode = values[0];
        final countryCode = values[1].isNotEmpty ? values[1] : null;
        return Locale.fromSubtags(
            languageCode: languageCode, countryCode: countryCode
        );
      }
    }
    return null;
  }

  Future<bool> setLocale(Locale? locale) async {
    if (locale == null) {
      return _preferences.setString('language', '');
    }
    return _preferences.setString(
        'language', '${locale.languageCode}_${locale.countryCode ?? ''}'
    );
  }
}

