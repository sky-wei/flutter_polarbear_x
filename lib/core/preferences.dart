
/*
 * Copyright (c) 2023 The sky Authors.
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

import 'package:shared_preferences/shared_preferences.dart';

abstract class XPreferences {

  Set<String> getKeys();

  Object? get(String key);

  bool? getBool(String key);

  int? getInt(String key);

  double? getDouble(String key);

  String? getString(String key);

  bool containsKey(String key);

  List<String>? getStringList(String key);

  Future<bool> setBool(String key, bool value);

  Future<bool> setInt(String key, int value);

  Future<bool> setDouble(String key, double value);

  Future<bool> setString(String key, String value);

  Future<bool> setStringList(String key, List<String> value);

  Future<bool> remove(String key);

  Future<bool> clear();
}


class AppPreferences implements XPreferences {

  final String _prefix;
  final SharedPreferences _preferences;

  AppPreferences({
    String? name,
    required SharedPreferences preferences
  }) : _prefix = '${name ?? 'default'}.', _preferences = preferences;

  @override
  Set<String> getKeys() => _preferences.getKeys();

  @override
  Object? get(String key) => _preferences.get(_prefixKey(key));

  @override
  bool? getBool(String key) => _preferences.getBool(_prefixKey(key));

  @override
  int? getInt(String key) => _preferences.getInt(_prefixKey(key));

  @override
  double? getDouble(String key) => _preferences.getDouble(_prefixKey(key));

  @override
  String? getString(String key) => _preferences.getString(_prefixKey(key));

  @override
  bool containsKey(String key) => _preferences.containsKey(_prefixKey(key));

  @override
  List<String>? getStringList(String key) => _preferences.getStringList(_prefixKey(key));

  @override
  Future<bool> setBool(String key, bool value) => _preferences.setBool(_prefixKey(key), value);

  @override
  Future<bool> setInt(String key, int value) => _preferences.setInt(_prefixKey(key), value);

  @override
  Future<bool> setDouble(String key, double value) => _preferences.setDouble(_prefixKey(key), value);

  @override
  Future<bool> setString(String key, String value) => _preferences.setString(_prefixKey(key), value);

  @override
  Future<bool> setStringList(String key, List<String> value) => _preferences.setStringList(_prefixKey(key), value);

  @override
  Future<bool> remove(String key) => _preferences.remove(_prefixKey(key));

  @override
  Future<bool> clear() => _preferences.clear();

  String _prefixKey(String key) => '$_prefix$key';
}