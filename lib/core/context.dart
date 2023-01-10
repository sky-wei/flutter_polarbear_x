
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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_polarbear_x/core/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../data/item/version.dart';
import '../data/objectbox.dart';
import '../util/easy_notifier.dart';
import 'clipboard.dart';
import 'component.dart';
import 'database.dart';
import 'encrypt.dart';
import 'preferences.dart';
import 'settings.dart';

abstract class XContext {

  XVersion get appVersion;

  Directory get appDirectory;

  XSettings get appSetting;

  XComponentManager get componentManager;

  T getComponent<T extends XComponent>(String name);
}

class BaseContext extends XContext {

  @override
  final XVersion appVersion = AppVersion(XConstant.versionName, 1);

  @override
  late Directory appDirectory;

  @override
  late XSettings appSetting;

  late SharedPreferences sharedPreferences;

  Future<void> initialize() async {
    appDirectory = await _getAppDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
    appSetting = AppSettings(
      AppPreferences(
        name: 'settings',
        preferences: sharedPreferences
      )
    );
  }

  /// 获取App目录
  Future<Directory> _getAppDirectory() async {
    return kDebugMode ? await getTemporaryDirectory() : await getApplicationSupportDirectory();
  }

  @override
  XComponentManager get componentManager => throw UnimplementedError();

  @override
  T getComponent<T extends XComponent>(String name) {
    throw UnimplementedError();
  }
}


class AppContext extends EasyNotifier implements ComponentManager, XContext {

  final BaseContext _baseContext;

  bool _init = false;

  @override
  late ComponentManager componentManager;

  @override
  XVersion get appVersion => _baseContext.appVersion;

  @override
  Directory get appDirectory => _baseContext.appDirectory;

  @override
  XSettings get appSetting => _baseContext.appSetting;

  AppContext({
    required BaseContext baseContext,
    ComponentManager? componentManager
  }) : _baseContext = baseContext, componentManager = componentManager ?? ComponentManager();

  @override
  /// 初始化
  Future<void> initialize() async {
    if (!_init) {
      _init = true;
      componentManager.initialize();
      final objectBox = await ObjectBox.create(
          directory: appDirectory.path
      );
      componentManager.registerLazyComponent(
          name: XDataManager.componentName,
          builder: (componentManager) => DataManager(objectBox)
      );
      onInitialize();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  /// 初始化
  void onInitialize() {
    componentManager.registerLazyComponent(
        name: XClipboard.componentName,
        builder: (componentManager) => ClipboardManager(
            setting: appSetting
        )
    );
    componentManager.registerLazyComponent(
        name: XEncrypt.componentName,
        builder: (componentManager) => EncryptStore()
    );
    componentManager.registerLazyComponent(
        name: XRepository.componentName,
        builder: (componentManager) => AppRepository(
            dataManager: componentManager.getComponent(XDataManager.componentName),
            encryptStore: componentManager.getComponent(XEncrypt.componentName)
        )
    );
  }

  @override
  void dispose() {
    componentManager.dispose();
    super.dispose();
  }

  @override
  T getComponent<T extends XComponent>(String name) {
    return componentManager.getComponent(name);
  }

  @override
  bool hasComponent(String name) {
    return componentManager.hasComponent(name);
  }

  @override
  bool isDispose() {
    return componentManager.isDispose();
  }

  @override
  void registerComponent({required String name, required XComponent component}) {
    componentManager.registerComponent(name: name, component: component);
  }

  @override
  void registerLazyComponent({required String name, required BuildComponent builder}) {
    componentManager.registerLazyComponent(name: name, builder: builder);
  }

  @override
  void unregisterComponent(String name) {
    componentManager.unregisterComponent(name);
  }
}


extension XContextExtension on XContext {

  XDataManager get dataManager => XDataManager.getDataManager(this);

  XRepository get appRepository => XRepository.getAppRepository(this);

  XClipboard get clipboardManager => XClipboard.getClipboardManager(this);
}