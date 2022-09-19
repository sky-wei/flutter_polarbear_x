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

import 'package:flutter/services.dart';

import '../data/item/time_item.dart';
import '../data/repository/app_setting.dart';

class ClipboardManager {

  int _curTime = 0;
  int _lastCopyTime = 0;
  String _lastCopyValue = "";

  final AppSetting _appSetting;

  ClipboardManager({
    required AppSetting appSetting,
  }): _appSetting = appSetting;

  /// 复制内容到剪贴板
  Future<void> copy(String value) async {
    _lastCopyTime = _curTime;
    _lastCopyValue = value;
    return await Clipboard.setData(
        ClipboardData(text:value)
    );
  }

  /// 清除上一次剪贴板的内容
  Future<void> clear() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text == _lastCopyValue) {
      _resetInfo();
      await Clipboard.setData(
          const ClipboardData(text: '')
      );
    }
  }

  /// 检测剪贴板是否超时
  void checkTimeout(int time) {

    if (_lastCopyTime <= 0) {
      // 没有使用不需要处理
      return;
    }

    _curTime = time;

    final timeout = _appSetting.getClipboardTimeBySecond(
        TimeItem.defaultLock
    );

    if (timeout > 0 && _curTime - _lastCopyTime >= timeout) {
      clear();
    }
  }

  /// 释放
  void dispose() {
    _resetInfo();
  }

  /// 重置信息
  void _resetInfo() {
    _lastCopyTime = 0;
    _lastCopyValue = '';
  }
}
