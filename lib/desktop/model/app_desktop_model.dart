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

import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/core/context.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/item/side_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
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

  final List<AccountItem> accounts = [];  /// 账号

  late SideItem chooseSide = allItems;
  SortType get sortType => chooseSide.type;
  AccountItem chooseAccount = AccountItem.empty;
  String keyword = '';
  FunState funState = FunState.none;
  AccountItem editAccount = AccountItem.empty;

  List<AccountItem> _filterAccountItems = [];   // 当前账号列表

  AppDesktopModel(XContext context) : super(context);


  @override
  void initialize() {
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

  /// 切换到默认
  Future<List<AccountItem>> switchDefaultSide() async {
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
  @override
  Future<AccountItem> createAccount(AccountItem account) async {

    final result = await super.createAccount(account);

    await refreshAccounts();
    viewAccountBy(result);

    return result;
  }

  /// 删除账号
  @override
  Future<AccountItem> deleteAccount(AccountItem account) async {

    if (SortType.trash == chooseSide.type) {
      // 需要清除数据
      await super.deleteAccount(account);
    } else {
      // 移动到垃圾箱
      await super.moveToTrash(account);
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
  @override
  Future<AccountItem> updateAccount(AccountItem account) async {

    final result = await super.updateAccount(account);

    await refreshAccounts();
    viewAccountBy(result);

    return result;
  }

  /// 收藏账号与取消
  @override
  Future<AccountItem> favoriteAccount(AccountItem account) async {

    final result = await super.favoriteAccount(account);

    await refreshAccounts();

    return result;
  }

  /// 恢复账号
  @override
  Future<AccountItem> restoreAccount(AccountItem account) async {

    final result = await super.restoreAccount(account);

    // 刷新账号
    await refreshAccounts();

    if (chooseAccount == result) {
      clearChooseAccount();
      clearAccount();
    }

    return result;
  }

  /// 导入账号
  @override
  Future<bool> importAccount(PasswordCallback callback) async {
    final result = await super.importAccount(callback);
    if (result) await refreshAccounts();
    return result;
  }

  /// 清除数据
  @override
  Future<bool> clearData() async {
    final result = await super.clearData();
    if (result) {
      clearChooseAccount();
      clearAccount();
      await refreshAccounts();
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

  /// 文件夹修改通知
  void _folderChange() {
    infoNotifier.notifyListeners();
  }
}
