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

import '../constant.dart';
import '../data/item/time_item.dart';
import '../data/repository/app_setting.dart';

class LockManager extends ValueNotifier<bool> {

  final AppSetting _appSetting;
  final IsLoginCallback _isLogin;
  int _lastTime = 0;

  LockManager({
    required AppSetting appSetting,
    required IsLoginCallback callback
  }): _appSetting = appSetting, _isLogin = callback, super(false) ;

  /// 更新监听时间
  void updateLastTime(int time) {
    _lastTime = time;
  }

  /// 锁屏通知
  void lock() {
    value = true;
  }

  /// 解锁通知
  void unlock() {
    value = false;
  }

  /// 检测是否超时
  void checkTimeout(int time) {

    if (value || !_isLogin()) {
      // 没有登录或锁屏不需要处理
      return;
    }

    final timeout = _appSetting.getLockTimeBySecond(
        TimeItem.defaultLock
    );

    if (timeout > 0 && time - _lastTime >= timeout) {
      lock();
    }
  }

  @override
  void dispose() {
    _lastTime = 0;
    super.dispose();
  }
}