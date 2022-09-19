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
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/item/side_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/model/app_abstract_model.dart';
import 'package:flutter_polarbear_x/util/easy_notifier.dart';


enum FunState {
  view,
  edit,
  none
}

class AppDesktopModel extends AppAbstractModel {

  final EasyNotifier listNotifier = EasyNotifier();
  final EasyNotifier infoNotifier = EasyNotifier();
  final EasyNotifier funStateNotifier = EasyNotifier();

  late SideItem chooseSide;
  SortType get sortType => chooseSide.type;
  AccountItem chooseAccount = AccountItem.empty;
  String keyword = '';
  FunState funState = FunState.none;
  AccountItem editAccount = AccountItem.empty;

  List<AccountItem> _filterAccountItems = [];   // 当前账号列表

  AppDesktopModel({
    required AppSetting appSetting
  }) : super(appSetting: appSetting);


  @override
  void onInitialize() {
    chooseSide = allItems;
    folderNotifier.addListener(_folderChange);
  }

  @override
  void dispose() {
    folderNotifier.removeListener(_folderChange);
    listNotifier.dispose();
    infoNotifier.dispose();
    funStateNotifier.dispose();
    super.dispose();
  }

  /// 文件夹修改通知
  void _folderChange() {
    infoNotifier.notifyListeners();
  }

  /// 加载所有账号
  Future<List<AccountItem>> loadAllAccount() async {

    allAccountItems = await appRepository.loadAllAccountBy(admin);

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
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => item.favorite && !item.trash
        );
        break;
      case SortType.allItems:
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => !item.trash
        );
        break;
      case SortType.trash:
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => item.trash
        );
        break;
      case SortType.folder:
        FolderItem folder = side.data;
        items = filterAccount(
            accounts: allAccountItems,
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

    final items = filterAccount(
      accounts: _filterAccountItems,
      filter: (item) => item.contains(keyword)
    );

    _updateAccounts(items);
    
    return accounts;
  }

  /// 创建账号
  Future<AccountItem> createAccount(AccountItem account) async {

    final result = await appRepository.createAccount(admin, account);

    allAccountItems.add(result);

    refreshAccounts();
    viewAccountBy(result);

    return result;
  }

  /// 删除账号
  Future<AccountItem> deleteAccount(AccountItem account) async {

    if (SortType.trash == chooseSide.type) {
      // 需要清除数据
      allAccountItems.remove(account);
      await appRepository.deleteAccount(admin, account);
    } else {
      // 移动到垃圾箱
      account.trash = true;
      _updateListAccount(account);
      await appRepository.updateAccount(admin, account);
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
    final result = await appRepository.updateAccount(admin, account);

    _updateListAccount(result);

    refreshAccounts();
    viewAccountBy(result);

    return result;
  }

  /// 收藏账号与取消
  Future<AccountItem> favoriteAccount(AccountItem account) async {

    account.favorite = !account.favorite;
    account.setUpdateTime();
    final result = await appRepository.updateAccount(admin, account);

    _updateListAccount(result);
    refreshAccounts();

    return result;
  }

  /// 恢复账号
  Future<AccountItem> restoreAccount(AccountItem account) async {

    // 移出垃圾箱
    account.trash = false;
    final result = await appRepository.updateAccount(admin, account);

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
      allAccountItems.addAll(result);
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

    final accountItems = allAccountItems.map((account) {
      return appRepository.encryptAccount(password, account);
    }).toList();

    final value = json.encode(accountItems);
    await File(path).writeAsString(value, flush: true);

    return true;
  }

  /// 清除数据
  Future<bool> clearData() async {

    final result = await appRepository.clearData(admin);

    if (result) {
      allAccountItems.clear();
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
    final index = allAccountItems.indexOf(item);
    if (index != -1) {
      allAccountItems.removeAt(index);
      allAccountItems.insert(index, item);
    }
  }
}
