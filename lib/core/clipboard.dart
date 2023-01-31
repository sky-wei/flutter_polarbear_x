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
import 'package:flutter_polarbear_x/core/settings.dart';

import '../data/item/time_item.dart';
import 'component.dart';
import 'context.dart';

abstract class XClipboard implements XComponent {

  static const String componentName = 'clipboardManager';

  static XClipboard getClipboardManager(XContext context) {
    return context.getComponent(componentName);
  }

  Future<void> copy(String value);

  bool checkTimeout(int time);

  Future<void> clear();
}

class ClipboardManager extends AbstractComponent implements XClipboard {

  final XSettings _setting;

  int _curTime = 0;
  int _lastCopyTime = 0;
  String _lastCopyValue = "";

  ClipboardManager({
    required XSettings setting,
  }): _setting = setting;

  @override
  /// 复制内容到剪贴板
  Future<void> copy(String value) async {
    _lastCopyTime = _curTime;
    _lastCopyValue = value;
    return await Clipboard.setData(
        ClipboardData(text:value)
    );
  }

  @override
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

  @override
  /// 检测剪贴板是否超时
  bool checkTimeout(int time) {

    if (_lastCopyTime <= 0) {
      // 没有使用不需要处理
      return false;
    }

    _curTime = time;

    final timeout = _setting.getClipboardTimeBySecond(
        TimeItem.defaultLock
    );

    if (timeout > 0 && _curTime - _lastCopyTime >= timeout) {
      clear();
      return true;
    }
    return false;
  }

  /// 释放
  @override
  void dispose() {
    super.dispose();
    _resetInfo();
  }

  /// 重置信息
  void _resetInfo() {
    _lastCopyTime = 0;
    _lastCopyValue = '';
  }
}
