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
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:flutter_polarbear_x/data/repository/encrypt_store.dart';
import 'package:flutter_polarbear_x/model/side_item.dart';
import 'package:flutter_polarbear_x/util/easy_notifier.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:path_provider/path_provider.dart';

import '../data/data_exception.dart';
import '../data/item/admin_item.dart';
import '../data/item/folder_item.dart';
import '../data/item/sort_item.dart';
import '../data/objectbox.dart';
import '../data/repository/app_repository.dart';
import '../generated/l10n.dart';
import '../main.dart';
import '../theme/color.dart';


typedef AccountFilter = bool Function(AccountItem account);

typedef PasswordCallback = Future<String?> Function();

class AbstractModel extends EasyNotifier {

}

enum FunState {
  view,
  edit,
  none
}

class AppModel extends AbstractModel {

  bool _init = false;
  late AppRepository _appRepository;
  final AppSetting _appSetting;

  late Timer _timer;
  int _curTick = 0;
  int _lastMonitorTime = 0;

  AdminItem _admin = kDebugMode ? AdminItem(id: 1, name: 'sky', password: '123456') : AdminItem(name: '', password: '');

  final List<SideItem> fixedSide = [
    SideItem(name: S.current.favorites, icon: 'assets/svg/ic_favorites.svg', type: SortType.favorite, color: XColor.favoriteColor),
    SideItem(name: S.current.allItems, icon: 'assets/svg/ic_all_items.svg', type: SortType.allItems),
    SideItem(name: S.current.trash, icon: 'assets/svg/ic_trash.svg', type: SortType.trash, color: XColor.deleteColor),
  ];

  SideItem get allItems => fixedSide[1];

  final EasyNotifier folderNotifier = EasyNotifier();
  final EasyNotifier listNotifier = EasyNotifier();
  final EasyNotifier infoNotifier = EasyNotifier();
  final EasyNotifier funStateNotifier = EasyNotifier();
  final ValueNotifier lockNotifier = ValueNotifier(false);

  final List<FolderItem> folders = [];    /// 文件夹
  final List<AccountItem> accounts = [];  /// 账号

  late SideItem chooseSide;
  SortType get sortType => chooseSide.type;
  AccountItem chooseAccount = AccountItem.empty;
  String keyword = '';
  FunState funState = FunState.none;
  AccountItem editAccount = AccountItem.empty;
  
  List<AccountItem> _allAccountItems = [];      // 当前用户可用的账号列表
  List<AccountItem> _filterAccountItems = [];   // 当前账号列表
  
  AdminItem get admin => _admin;        // 当前管理员信息
  bool get isLogin => _admin.id > 0;    // 判断账号是不登录

  AppModel({
    required AppSetting appSetting
  }): _appSetting = appSetting;

  @override
  void dispose() {
    _disposeTimer();
    folderNotifier.dispose();
    listNotifier.dispose();
    infoNotifier.dispose();
    funStateNotifier.dispose();
    lockNotifier.dispose();
    _appRepository.dispose();
    super.dispose();
  }

  /// 初始化
  Future<AppModel> initialize() async {
    if (!_init) {
      _init = true;
      chooseSide = allItems;
      final dir = await getAppDirectory();
      _appRepository = AppRepository(
        objectBox: await ObjectBox.create(directory: dir.path),
        encryptStore: EncryptStore()
      );
      _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => _timeHandler(timer)
      );
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return this;
  }

  /// 获取App目录
  Future<Directory> getAppDirectory() async {
    return kDebugMode ? await getTemporaryDirectory() : await getApplicationSupportDirectory();
  }

  /// 创建账号
  Future<AdminItem> createAdmin({
    required String name,
    required String password
  }) async {

    final admin = await _appRepository.createAdmin(
        AdminItem(name: name, password: password)
    );

    return _updateAdmin(admin);
  }

  /// 更新账号信息
  Future<AdminItem> updateAdmin(AdminItem admin) async {

    admin.setUpdateTime();

    await _appRepository.updateAdmin(admin);

    return _updateAdmin(admin);
  }

  /// 更新账号密码
  Future<AdminItem> updateAdminPassword(String newPassword) async {

    final admin = this.admin.copy(password: newPassword);

    admin.setUpdateTime();

    await _appRepository.updateAdmin(admin);
    await _appRepository.updateAccounts(admin, _allAccountItems);

    return _updateAdmin(admin);
  }

  /// 登录账号
  Future<AdminItem> loginByAdmin({
    required String name,
    required String password
  }) async {

    final admin = await _appRepository.loginByAdmin(
        AdminItem(name: name, password: password)
    );

    return _updateAdmin(admin);
  }

  /// 解锁
  Future<void> unlock(String password) async {

    if (admin.password != password) {
      throw DataException.type(type: ErrorType.passwordError);
    }

    lockNotifier.value = false;
  }

  /// 创建文件夹
  Future<FolderItem> createFolder(String name) async {

    var folder = await _appRepository.createFolder(
      FolderItem(adminId: admin.id, name: name)
    );

    folderNotifier.notify(() {
      folders.insert(folders.length - 1, folder);
    });
    infoNotifier.notifyListeners();

    return folder;
  }

  /// 修改文件夹
  Future<FolderItem> updateFolder(FolderItem folder) async {

    final result = await _appRepository.updateFolder(folder);

    folderNotifier.notify(() {
      final index = folders.indexOf(result);
      folders.removeAt(index);
      folders.insert(index, result);
    });
    infoNotifier.notifyListeners();

    return result;
  }

  /// 删除文件夹
  Future<FolderItem> deleteFolder(FolderItem folder) async {

    final result = await _appRepository.deleteFolder(folder);

    final accounts = _filterAccount(
      accounts: _allAccountItems,
      filter: (account) => folder.id == account.folderId
    );
    for (var item in accounts) {
      item.folderId = FolderItem.noFolder;
    }

    if (accounts.isNotEmpty) {
      // 更新账号信息
      await _appRepository.updateAccounts(admin, accounts);
    }

    folderNotifier.notify(() {
      folders.remove(result);
    });
    infoNotifier.notifyListeners();

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
    final result = await _appRepository.loadFoldersBy(admin);

    result.add(
      FolderItem(adminId: admin.id, name: S.current.noFolder)
    );
    
    folderNotifier.notify(() {
      folders.clear();
      folders.addAll(result);
    });

    return result;
  }

  /// 加载所有账号
  Future<List<AccountItem>> loadAllAccount() async {

    _allAccountItems = await _appRepository.loadAllAccountBy(admin);

    return await switchSide(side: allItems);
  }

  /// 刷新账号
  Future<List<AccountItem>> refreshAccounts() async {
    return await switchSide(side: chooseSide);
  }

  /// 过滤账号列表
  Future<List<AccountItem>> switchSide({
    required SideItem side
  }) async {

    chooseSide = side;

    final List<AccountItem> items;

    switch(side.type) {
      case SortType.favorite:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.favorite && !item.trash
        );
        break;
      case SortType.allItems:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => !item.trash
        );
        break;
      case SortType.trash:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.trash
        );
        break;
      case SortType.folder:
        FolderItem folder = side.data;
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.folderId == folder.id && !item.trash
        );
        break;
      default:
        items = [];
    }

    _filterAccountItems = items;

    return await searchAccount(keyword: keyword);
  }

  /// 搜索账号
  Future<List<AccountItem>> searchAccount({
    required String keyword
  }) async {

    this.keyword = keyword;

    if (keyword.isEmpty) {
      _updateAccounts(_filterAccountItems);
      return accounts;
    }

    final items = _filterAccount(
      accounts: _filterAccountItems,
      filter: (item) => item.contains(keyword)
    );

    _updateAccounts(items);
    
    return accounts;
  }

  /// 创建账号
  Future<AccountItem> createAccount(AccountItem account) async {

    final result = await _appRepository.createAccount(admin, account);

    _allAccountItems.add(result);

    refreshAccounts();
    viewAccountBy(result);

    return result;
  }

  /// 删除账号
  Future<AccountItem> deleteAccount(AccountItem account) async {

    if (SortType.trash == chooseSide.type) {
      // 需要清除数据
      _allAccountItems.remove(account);
      await _appRepository.deleteAccount(admin, account);
    } else {
      // 移动到垃圾箱
      account.trash = true;
      _updateListAccount(account);
      await _appRepository.updateAccount(admin, account);
    }

    // 刷新账号
    await refreshAccounts();

    if (chooseAccount == account) {
      clearChooseAccount();
      clearAccount();
    }

    return account;
  }

  /// 更新账号信息
  Future<AccountItem> updateAccount(AccountItem account) async {

    account.setUpdateTime();
    final result = await _appRepository.updateAccount(admin, account);

    _updateListAccount(result);

    refreshAccounts();
    viewAccountBy(result);

    return result;
  }

  /// 收藏账号与取消
  Future<AccountItem> favoriteAccount(AccountItem account) async {

    account.favorite = !account.favorite;
    account.setUpdateTime();
    final result = await _appRepository.updateAccount(admin, account);

    _updateListAccount(result);
    refreshAccounts();

    return result;
  }

  /// 恢复账号
  Future<AccountItem> restoreAccount(AccountItem account) async {

    // 移出垃圾箱
    account.trash = false;
    final result = await _appRepository.updateAccount(admin, account);

    // 刷新账号
    await refreshAccounts();

    if (chooseAccount == result) {
      clearChooseAccount();
      clearAccount();
    }

    return result;
  }
  
  /// 导入账号
  Future<bool> importAccount(PasswordCallback callback) async {

    final file = await openFile(
        acceptedTypeGroups: [XTypeGroup(label: 'json', extensions: ['json'])],
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
      final tAccount = _appRepository.decryptAccount(password, account);
      return tAccount.copy(
        id: 0,
        adminId: _admin.id,
        createTime: time,
        updateTime: time
      );
    }).toList();

    // 批量导入
    final result = await _appRepository.createAccountList(admin, accounts);

    if (result.isNotEmpty) {
      _allAccountItems.addAll(result);
      refreshAccounts();
    }

    return true;
  }

  /// 导出账号
  Future<bool> exportAccount(PasswordCallback callback) async {

    var path = await getSavePath(
        acceptedTypeGroups: [XTypeGroup(label: 'json', extensions: ['json'])],
        suggestedName: "account_list.json",
        confirmButtonText: S.current.export
    );

    if (path == null) return false;

    /// 回调请求用户密码
    final password = await callback();

    if (password == null) return false;

    final accountItems = _allAccountItems.map((account) {
      return _appRepository.encryptAccount(password, account);
    }).toList();

    final value = json.encode(accountItems);
    await File(path).writeAsString(value, flush: true);

    return true;
  }

  /// 清除数据
  Future<bool> clearData() async {

    final result = await _appRepository.clearData(admin);

    if (result) {
      _allAccountItems.clear();
      clearChooseAccount();
      clearAccount();
      refreshAccounts();
    }

    return result;
  }

  /// 显示账号
  void viewAccountBy(AccountItem item) {
    listNotifier.notify();
    funStateNotifier.notify(() {
      chooseAccount = item;
      editAccount = item.copy();
      funState = FunState.view;
    });
  }

  /// 编辑账号
  void editAccountBy(AccountItem item) {
    listNotifier.notify();
    funStateNotifier.notify(() {
      chooseAccount = item;
      editAccount = item.copy();
      funState = FunState.edit;
    });
  }

  /// 创建账号
  void newAccount() {
    listNotifier.notify();
    funStateNotifier.notify(() {
      chooseAccount = AccountItem.formAdmin(admin.id);
      editAccount = chooseAccount.copy();
      funState = FunState.edit;
    });
  }

  /// 清除列表选择
  void clearChooseAccount() {
    listNotifier.notify(() {
      chooseAccount = AccountItem.empty;
    });
  }

  /// 清除账号
  void clearAccount() {
    funStateNotifier.notify(() {
      chooseAccount = AccountItem.empty;
      editAccount = AccountItem.empty;
      funState = FunState.none;
    });
  }

  /// 是否修改了账号
  bool isModifyAccount() {
    return FunState.edit == funState && !chooseAccount.unanimous(editAccount);
  }

  /// 获取主题
  AppSetting getAppSetting() {
    return _appSetting;
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

  /// 过滤账号
  List<AccountItem> _filterAccount({
    required List<AccountItem> accounts,
    required AccountFilter filter
  }) {

    final List<AccountItem> items = [];

    for (var item in accounts) {
      if (filter(item)) items.add(item);
    }

    return items;
  }

  /// 更新管理员信息
  AdminItem _updateAdmin(AdminItem item) {
    notify(() => _admin = item);
    return item;
  }
  
  /// 更新账号
  List<AccountItem> _updateAccounts(List<AccountItem> items) {

    // final result = List.of(items);
    // result.sort((a, b) => -a.updateTime.compareTo(b.updateTime));

    listNotifier.notify(() {
      accounts.clear();
      accounts.addAll(items);
    });
    return items;
  }

  /// 更新列表中的账号
  void _updateListAccount(AccountItem item) {
    final index = _allAccountItems.indexOf(item);
    if (index != -1) {
      _allAccountItems.removeAt(index);
      _allAccountItems.insert(index, item);
    }
  }

  /// 时间处理
  void _timeHandler(Timer timer) {
    _curTick = timer.tick;

    if (!isLogin || lockNotifier.value) {
      // 没有登录或锁屏不需要处理
      XLog.d('>>>>>>>>>>>>>>> $isLogin   ${lockNotifier.value}');
      return;
    }

    // XLog.d('>>>>>>>>>>>>>>>>> $_curTick  $_lastMonitorTime');
    //
    // if (_curTick - _lastMonitorTime >= 60) {
    //   XLog.d('>>>>>>>>>>>>>>>>> 超时了!~');
    // }
  }

  /// 释放定时器
  void _disposeTimer() {
    if (_timer.isActive) _timer.cancel();
    _curTick = 0;
    _lastMonitorTime = 0;
  }
}
