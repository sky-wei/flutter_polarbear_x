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
import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../constant.dart';
import '../core/context.dart';
import '../data/data_exception.dart';
import '../data/item/account_item.dart';
import '../data/item/admin_item.dart';
import '../data/item/folder_item.dart';
import '../data/item/side_item.dart';
import '../data/item/sort_item.dart';
import '../generated/l10n.dart';
import '../theme/color.dart';
import '../util/easy_notifier.dart';
import '../widget/restart_widget.dart';
import 'abstract_model.dart';
import 'lock_manager.dart';

abstract class AppAbstractModel extends AbstractModel {

  final List<FolderItem> folders = [];    /// 文件夹
  final List<AccountItem> allAccountItems = [];      /// 当前用户下所有账号列表(包括回收箱的)

  final List<SideItem> fixedSide = [
    SideItem(name: S.current.favorites, icon: 'assets/svg/ic_favorites.svg', type: SortType.favorite, color: XColor.favoriteColor),
    SideItem(name: S.current.allItems, icon: 'assets/svg/ic_all_items.svg', type: SortType.allItems),
    SideItem(name: S.current.trash, icon: 'assets/svg/ic_trash.svg', type: SortType.trash, color: XColor.deleteColor),
  ];

  SideItem get favorites => fixedSide[0];
  SideItem get allItems => fixedSide[1];
  SideItem get trash => fixedSide[2];

  final EasyNotifier folderNotifier = EasyNotifier();
  final EasyNotifier allAccountNotifier = EasyNotifier();

  AdminItem _admin = kDebugMode ? AdminItem(id: 1, name: 'sky', password: '123456') : AdminItem(name: '', password: '');

  AdminItem get admin => _admin;        // 当前管理员信息
  bool get isLogin => _admin.id > 0;    // 判断账号是不登录

  Timer? _timer;
  LockManager? _lockManager;

  Timer get timer => _timer ?? (_timer = _createTimer());
  LockManager get lockManager => _lockManager ?? (_lockManager = _createLockManager());

  AppAbstractModel(XContext context) : super(context);

  void initialize() {
  }

  @override
  void dispose() {
    _disposeTimer();
    folderNotifier.dispose();
    allAccountNotifier.dispose();
    lockManager.dispose();
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

  /// 登录账号
  Future<AdminItem> loginByAdmin({
    required String name,
    required String password
  }) async {
    return _updateAdmin(
        await appRepository.loginByAdmin(
            AdminItem(name: name, password: password)
        )
    );
  }

  /// 更新账号信息
  Future<AdminItem> updateAdmin(AdminItem admin) async {
    admin.setUpdateTime();
    return _updateAdmin(
        await appRepository.updateAdmin(admin)
    );
  }

  /// 更新账号密码
  Future<AdminItem> updateAdminPassword(String newPassword) async {

    final admin = this.admin.copy(password: newPassword)
      ..setUpdateTime();

    await appRepository.updateAdmin(admin);
    await appRepository.updateAccounts(admin, allAccountItems);

    return _updateAdmin(admin);
  }

  /// 加载所有文件夹
  Future<List<FolderItem>> loadFolders() async {

    final result = await appRepository.loadFoldersBy(admin)
      ..add(FolderItem(adminId: admin.id, name: S.current.noFolder));

    folderNotifier.notify(() {
      folders.clear();
      folders.addAll(result);
    });

    return result;
  }

  /// 创建文件夹
  Future<FolderItem> createFolder(String name) async {

    final folder = await appRepository.createFolder(
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

    folderNotifier.notify(() => folders.remove(result));

    return result;
  }

  /// 加载所有账号
  Future<List<AccountItem>> loadAllAccount() async {

    final accounts = await appRepository.loadAllAccountBy(admin);

    allAccountNotifier.notify(() {
      allAccountItems.clear();
      allAccountItems.addAll(accounts);
    });

    return accounts;
  }

  /// 创建账号
  Future<AccountItem> createAccount(AccountItem account) async {
    final result = await appRepository.createAccount(admin, account);
    allAccountNotifier.notify(() => allAccountItems.add(result));
    return result;
  }

  /// 删除账号
  Future<AccountItem> deleteAccount(AccountItem account) async {
    final result = await appRepository.deleteAccount(admin, account);
    allAccountNotifier.notify(() => allAccountItems.remove(account));
    return result;
  }

  /// 删除账号
  Future<List<AccountItem>> deleteAccounts(List<AccountItem> accounts) async {
    for (var account in accounts) {
      await appRepository.deleteAccount(admin, account);
    }
    allAccountNotifier.notify(() {
      for (var value in accounts) {
        allAccountItems.remove(value);
      }
    });
    return accounts;
  }

  /// 更新账号信息
  Future<AccountItem> updateAccount(AccountItem account) async {
    account.setUpdateTime();
    return _updateAccountByAll(
        await appRepository.updateAccount(admin, account)
    );
  }

  /// 收藏账号与取消
  Future<AccountItem> favoriteAccount(AccountItem account) async {
    account.favorite = !account.favorite;
    account.setUpdateTime();
    return _updateAccountByAll(
        await appRepository.updateAccount(admin, account)
    );
  }

  /// 移到垃圾箱
  Future<AccountItem> moveToTrash(AccountItem account) async {
    account.trash = true;
    return _updateAccountByAll(
        await appRepository.updateAccount(admin, account)
    );
  }

  /// 恢复账号(移出垃圾箱)
  Future<AccountItem> restoreAccount(AccountItem account) async {
    account.trash = false;
    return _updateAccountByAll(
        await appRepository.updateAccount(admin, account)
    );
  }

  /// 导入账号
  Future<bool> importAccount(PasswordCallback callback) async {

    final file = await openFile(
        acceptedTypeGroups: [const XTypeGroup(label: 'json', extensions: ['json'])],
        confirmButtonText: S.current.import
    );

    if (file == null) return false;

    final text = await file.readAsString();
    final values = json.decode(text) as List;

    var accounts = values.map((e) => AccountItem.fromJson(e)).toList();
    accounts.sort((a, b) => a.id.compareTo(b.id));

    /// 回调请求用户密码
    final password = await callback();

    if (password == null) return false;

    var count = 0;

    accounts = accounts.map((account) {
      final time = DateTime.now().millisecondsSinceEpoch + (count++);
      final tAccount = appRepository.decryptAccount(password, account);
      return tAccount.copy(
          id: 0,
          adminId: admin.id,
          createTime: time,
          updateTime: time
      );
    }).toList();

    // 批量导入
    final result = await appRepository.createAccountList(admin, accounts);

    if (result.isNotEmpty) {
      allAccountNotifier.notify(() => allAccountItems.addAll(result));
    }
    return true;
  }

  /// 导出账号
  Future<bool> exportAccount(PasswordCallback callback) async {

    var fileLocation = await getSaveLocation(
        acceptedTypeGroups: [const XTypeGroup(label: 'json', extensions: ['json'])],
        suggestedName: "account_list.json",
        confirmButtonText: S.current.export
    );

    if (fileLocation == null) return false;

    /// 回调请求用户密码
    final password = await callback();

    if (password == null) return false;

    final accountItems = allAccountItems.map((account) {
      return appRepository.encryptAccount(password, account);
    }).toList();

    final value = json.encode(accountItems);
    await File(fileLocation.path).writeAsString(value, flush: true);

    return true;
  }

  /// 清除数据
  Future<bool> clearData() async {
    final result = await appRepository.clearData(admin);
    if (result) {
      allAccountNotifier.notify(() => allAccountItems.clear());
    }
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

  /// 更新列表中的账号
  AccountItem _updateAccountByAll(AccountItem account) {
    final index = allAccountItems.indexOf(account);
    if (index != -1) {
      allAccountNotifier.notify(() {
        allAccountItems.removeAt(index);
        allAccountItems.insert(index, account);
      });
    }
    return account;
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

  /// 更新监听时间
  void updateMonitorTime() {
    lockManager.updateLastTime(timer.tick);
  }

  /// 锁屏通知
  void lockNotice() {
    lockManager.lock();
  }

  /// 解锁
  Future<void> unlock(String password) async {

    if (admin.password != password) {
      throw DataException.type(type: ErrorType.passwordError);
    }

    lockManager.unlock();
  }

  /// 重启应用
  void restartApp(BuildContext context) {
    RestartWidget.restartApp(context);
  }

  /// 复制内容到剪贴板
  Future<void> copyToClipboard(String value) async {
    return await clipboardManager.copy(value);
  }

  /// 获取保存头像图片路径
  Future<AdminItem> updateHeadImage(AdminItem admin, XFile image) async {

    final newName = const Uuid().v1();
    final imageFile = File(image.path);
    final extName = image.name.substring(image.name.lastIndexOf('.'));
    final newImagePath = '${context.appDirectory.path}/$newName$extName';

    // 复制文件
    imageFile.copySync(newImagePath);

    if (admin.headImage.isNotEmpty) {
      File(admin.headImage).delete();
    }

    return await updateAdmin(admin.copy(headImage: newImagePath));
  }

  /// 创建定时器
  Timer _createTimer() {
    return Timer.periodic(
        const Duration(seconds: 1), (timer) => _timeHandler(timer)
    );
  }

  /// 创建锁屏管理
  LockManager _createLockManager() {
    return LockManager(
        appSetting: appSetting,
        callback: () { return isLogin; }
    );
  }

  /// 更新管理员信息
  AdminItem _updateAdmin(AdminItem item) {
    notify(() => _admin = item);
    return item;
  }

  /// 时间处理
  void _timeHandler(Timer timer) {
    final curTick = timer.tick;
    clipboardManager.checkTimeout(curTick);
    lockManager.checkTimeout(curTick);
  }

  /// 释放定时器
  void _disposeTimer() {
    if (timer.isActive) timer.cancel();
  }
}