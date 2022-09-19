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

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/model/abstract_model.dart';
import 'package:path_provider/path_provider.dart';

import '../constant.dart';
import '../data/data_exception.dart';
import '../data/item/account_item.dart';
import '../data/item/admin_item.dart';
import '../data/item/side_item.dart';
import '../data/item/sort_item.dart';
import '../data/item/time_item.dart';
import '../data/objectbox.dart';
import '../data/repository/app_repository.dart';
import '../data/repository/app_setting.dart';
import '../data/repository/encrypt_store.dart';
import '../generated/l10n.dart';
import '../theme/color.dart';
import '../util/easy_notifier.dart';
import '../widget/restart_widget.dart';

abstract class AppAbstractModel extends AbstractModel {

  bool _init = false;
  late AppRepository appRepository;
  final AppSetting appSetting;

  final List<FolderItem> folders = [];    /// 文件夹
  final List<AccountItem> accounts = [];  /// 账号

  List<AccountItem> allAccountItems = [];      /// 当前用户可用的账号列表

  final List<SideItem> fixedSide = [
    SideItem(name: S.current.favorites, icon: 'assets/svg/ic_favorites.svg', type: SortType.favorite, color: XColor.favoriteColor),
    SideItem(name: S.current.allItems, icon: 'assets/svg/ic_all_items.svg', type: SortType.allItems),
    SideItem(name: S.current.trash, icon: 'assets/svg/ic_trash.svg', type: SortType.trash, color: XColor.deleteColor),
  ];

  SideItem get favorites => fixedSide[0];
  SideItem get allItems => fixedSide[1];
  SideItem get trash => fixedSide[2];

  late Timer _timer;
  int _curTick = 0;
  int _lastMonitorTime = 0;
  int _lastCopyTime = 0;
  String _lastCopyValue = "";

  AdminItem _admin = kDebugMode ? AdminItem(id: 1, name: 'sky', password: '123456') : AdminItem(name: '', password: '');

  AdminItem get admin => _admin;        // 当前管理员信息
  bool get isLogin => _admin.id > 0;    // 判断账号是不登录

  final EasyNotifier folderNotifier = EasyNotifier();
  final ValueNotifier lockNotifier = ValueNotifier(false);

  AppAbstractModel({
    required this.appSetting
  });

  /// 初始化
  Future<void> initialize() async {
    if (!_init) {
      _init = true;
      onInitialize();
      final dir = await getAppDirectory();
      appRepository = AppRepository(
          objectBox: await ObjectBox.create(directory: dir.path),
          encryptStore: EncryptStore()
      );
      _timer = Timer.periodic(
          const Duration(seconds: 1), (timer) => _timeHandler(timer)
      );
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  /// 初始化
  void onInitialize();

  @override
  void dispose() {
    _disposeTimer();
    appRepository.dispose();
    folderNotifier.dispose();
    lockNotifier.dispose();
    super.dispose();
  }

  /// 创建账号
  Future<AdminItem> createAdmin({
    required String name,
    required String password
  }) async {

    final admin = await appRepository.createAdmin(
        AdminItem(name: name, password: password)
    );

    return _updateAdmin(admin);
  }

  /// 更新账号信息
  Future<AdminItem> updateAdmin(AdminItem admin) async {

    admin.setUpdateTime();

    await appRepository.updateAdmin(admin);

    return _updateAdmin(admin);
  }

  /// 更新账号密码
  Future<AdminItem> updateAdminPassword(String newPassword) async {

    final admin = this.admin.copy(password: newPassword);

    admin.setUpdateTime();

    await appRepository.updateAdmin(admin);
    await appRepository.updateAccounts(admin, allAccountItems);

    return _updateAdmin(admin);
  }

  /// 登录账号
  Future<AdminItem> loginByAdmin({
    required String name,
    required String password
  }) async {

    final admin = await appRepository.loginByAdmin(
        AdminItem(name: name, password: password)
    );

    return _updateAdmin(admin);
  }

  /// 创建文件夹
  Future<FolderItem> createFolder(String name) async {

    var folder = await appRepository.createFolder(
        FolderItem(adminId: admin.id, name: name)
    );

    folderNotifier.notify(() {
      folders.insert(folders.length - 1, folder);
    });

    return folder;
  }

  /// 修改文件夹
  Future<FolderItem> updateFolder(FolderItem folder) async {

    final result = await appRepository.updateFolder(folder);

    folderNotifier.notify(() {
      final index = folders.indexOf(result);
      folders.removeAt(index);
      folders.insert(index, result);
    });

    return result;
  }

  /// 删除文件夹
  Future<FolderItem> deleteFolder(FolderItem folder) async {

    final result = await appRepository.deleteFolder(folder);

    final accounts = filterAccount(
        accounts: allAccountItems,
        filter: (account) => folder.id == account.folderId
    );
    for (var item in accounts) {
      item.folderId = FolderItem.noFolder;
    }

    if (accounts.isNotEmpty) {
      // 更新账号信息
      await appRepository.updateAccounts(admin, accounts);
    }

    folderNotifier.notify(() {
      folders.remove(result);
    });

    return result;
  }

  /// 查找文件夹
  FolderItem findFolderBy(AccountItem account) {

    for (var folder in folders) {
      if (folder.id == account.folderId) {
        return folder;
      }
    }
    return folders[folders.length - 1];
  }

  /// 加载文件夹
  Future<List<FolderItem>> loadFolders() async {

    // 加载所有文件夹
    final result = await appRepository.loadFoldersBy(admin);

    result.add(
        FolderItem(adminId: admin.id, name: S.current.noFolder)
    );

    folderNotifier.notify(() {
      folders.clear();
      folders.addAll(result);
    });

    return result;
  }

  /// 解锁
  Future<void> unlock(String password) async {

    if (admin.password != password) {
      throw DataException.type(type: ErrorType.passwordError);
    }

    lockNotifier.value = false;
  }

  /// 获取App目录
  Future<Directory> getAppDirectory() async {
    return kDebugMode ? await getTemporaryDirectory() : await getApplicationSupportDirectory();
  }

  /// 过滤账号
  List<AccountItem> filterAccount({
    required List<AccountItem> accounts,
    required AccountFilter filter
  }) {

    final List<AccountItem> items = [];

    for (var item in accounts) {
      if (filter(item)) items.add(item);
    }

    return items;
  }

  /// 获取主题
  AppSetting getAppSetting() {
    return appSetting;
  }

  /// 更新监听时间
  void updateMonitorTime() {
    _lastMonitorTime = _curTick;
  }

  /// 锁屏通知
  void lockNotice() {
    lockNotifier.value = true;
  }

  /// 重启应用
  void restartApp(BuildContext context) {
    RestartWidget.restartApp(context);
  }

  /// 复制内容到剪贴板
  Future<void> copyToClipboard(String value) async {
    _lastCopyTime = _curTick;
    _lastCopyValue = value;
    return await Clipboard.setData(
        ClipboardData(text:value)
    );
  }

  /// 清除上一次剪贴板的内容
  Future<void> clearClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data != null && data.text == _lastCopyValue) {
      _lastCopyTime = 0;
      _lastCopyValue = '';
      await Clipboard.setData(
          const ClipboardData(text: '')
      );
    }
  }

  /// 更新管理员信息
  AdminItem _updateAdmin(AdminItem item) {
    notify(() => _admin = item);
    return item;
  }

  /// 时间处理
  void _timeHandler(Timer timer) {
    _curTick = timer.tick;
    _handlerLockApp();
    _handlerClipboard();
  }

  /// 处理锁定App
  void _handlerLockApp() {

    if (!isLogin || lockNotifier.value) {
      // 没有登录或锁屏不需要处理
      return;
    }

    final timeout = appSetting.getLockTimeBySecond(
        TimeItem.defaultLock
    );

    if (timeout > 0 && _curTick - _lastMonitorTime >= timeout) {
      lockNotice();
    }
  }

  /// 处理剪贴板
  void _handlerClipboard() {

    if (_lastCopyTime <= 0) {
      // 没有使用不需要处理
      return;
    }

    final timeout = appSetting.getClipboardTimeBySecond(
        TimeItem.defaultLock
    );

    if (timeout > 0 && _curTick - _lastCopyTime >= timeout) {
      clearClipboard();
    }
  }

  /// 释放定时器
  void _disposeTimer() {
    if (_timer.isActive) _timer.cancel();
    _curTick = 0;
    _lastMonitorTime = 0;
    _lastCopyTime = 0;
    _lastCopyValue = '';
  }
}

