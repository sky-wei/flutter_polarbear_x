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

import '../item/time_item.dart';

class AppSetting {

  final SharedPreferences _preferences;

  AppSetting(this._preferences);

  /// 获取主题模式
  int getDarkMode(int defaultValue) {
    return _preferences.getInt('dark_mode') ?? defaultValue;
  }

  /// 设置主题模式
  Future<bool> setDarkMode(int mode) async {
    return await _preferences.setInt('dark_mode', mode);
  }

  /// 获取锁定时间信息
  TimeItem getLockTime(TimeItem defaultValue) {
    final value = _preferences.getInt('lock_time') ?? defaultValue.value;
    final type = _preferences.getInt('lock_time_type') ?? defaultValue.type;
    return TimeItem(value: value, type: type);
  }

  /// 获取锁定时间信息
  int getLockTimeBySecond(TimeItem defaultValue) {
    return _preferences.getInt('lock_time_second') ?? defaultValue.secondValue;
  }

  /// 设置锁定时间信息
  Future<bool> setLockTime(TimeItem time) async {
    await _preferences.setInt('lock_time', time.value);
    await _preferences.setInt('lock_time_second', time.secondValue);
    await _preferences.setInt('lock_time_type', time.type);
    return true;
  }

  /// 获取剪贴板时间信息
  TimeItem getClipboardTime(TimeItem defaultValue) {
    final value = _preferences.getInt('clipboard_time') ?? defaultValue.value;
    final type = _preferences.getInt('clipboard_time_type') ?? defaultValue.type;
    return TimeItem(value: value, type: type);
  }

  /// 获取剪贴板时间信息
  int getClipboardTimeBySecond(TimeItem defaultValue) {
    return _preferences.getInt('clipboard_time_second') ?? defaultValue.secondValue;
  }

  /// 设置剪贴板时间信息
  Future<bool> setClipboardTime(TimeItem time) async {
    await _preferences.setInt('clipboard_time', time.value);
    await _preferences.setInt('clipboard_time_second', time.secondValue);
    await _preferences.setInt('clipboard_time_type', time.type);
    return true;
  }

  /// 获取Locale
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

  /// 设置Locale
  Future<bool> setLocale(Locale? locale) async {
    if (locale == null) {
      return _preferences.setString('language', '');
    }
    return _preferences.setString(
        'language', '${locale.languageCode}_${locale.countryCode ?? ''}'
    );
  }
}

