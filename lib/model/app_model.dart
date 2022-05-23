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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/repository/encrypt_store.dart';
import 'package:flutter_polarbear_x/model/side_item.dart';
import 'package:flutter_polarbear_x/util/easy_notifier.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:path_provider/path_provider.dart';

import '../data/item/admin_item.dart';
import '../data/item/folder_item.dart';
import '../data/objectbox.dart';
import '../data/repository/app_repository.dart';
import '../generated/l10n.dart';


typedef AccountFilter = bool Function(AccountItem account);

class AbstractModel extends EasyNotifier {

}

class AppModel extends AbstractModel {

  bool _init = false;
  late AppRepository _appRepository;

  final ValueNotifier<List<FolderItem>> folderNotifier = ValueNotifier([]);
  final ValueNotifier<List<AccountItem>> accountNotifier = ValueNotifier([]);

  AdminItem _admin = AdminItem(id: 1, name: 'Sky', password: '123456');

  SideType _lastType = SideType.allItems;
  String _lastKeyword = '';
  List<AccountItem> _allAccountItems = [];
  List<AccountItem> _trashAccountItems = [];
  List<AccountItem> _filterAccountItems = [];

  // 获取管理员信息
  AdminItem get admin => _admin;

  SideType get sideType => _lastType;

  /// 文件夹
  List<FolderItem> get folders => folderNotifier.value;

  /// 账号
  List<AccountItem> get accounts => accountNotifier.value;

  @override
  void dispose() {
    folderNotifier.dispose();
    accountNotifier.dispose();
    super.dispose();
  }

  /// 初始化
  Future<AppModel> initialize() async {
    if (!_init) {
      _init = true;
      final dir = await getApplicationSupportDirectory();
      _appRepository = AppRepository(
        objectBox: await ObjectBox.create(directory: dir.path),
        encryptStore: EncryptStore()
      );
    }
    return this;
  }

  /// 创建账号
  Future<AdminItem> createAdmin({
    required String name,
    required String password
  }) async {

    var item = _appRepository.encryptAdmin(
      AdminItem(
        name: name,
        password: password
      )
    );

    var admin = await _appRepository.createAdmin(item);

    return _updateAdmin(admin.copy(password: password));
  }

  /// 登录账号
  Future<AdminItem> loginByAdmin({
    required String name,
    required String password
  }) async {

    var item = _appRepository.encryptAdmin(
      AdminItem(name: name, password: password)
    );

    var admin = await _appRepository.loginByAdmin(item);

    return _updateAdmin(admin.copy(password: password));
  }

  /// 创建文件夹
  Future<FolderItem> createFolder(String name) async {

    var item = await _appRepository.createFolder(
      FolderItem(adminId: admin.id, name: name)
    );

    final folders = List<FolderItem>.of(this.folders)
      ..add(item);
    folderNotifier.value = folders;

    return item;
  }

  /// 修改文件夹
  Future<FolderItem> updateFolder(FolderItem item) async {

    final result = await _appRepository.updateFolder(item);

    final folders = List<FolderItem>.of(this.folders);
    final index = folders.indexOf(result);
    folders.removeAt(index);
    folders.insert(index, result);

    folderNotifier.value = folders;

    return result;
  }

  /// 删除文件夹
  Future<FolderItem> deleteFolder(FolderItem item) async {

    final result = await _appRepository.deleteFolder(item);

    final folders = List<FolderItem>.of(this.folders)
      ..remove(result);
    folderNotifier.value = folders;

    return result;
  }

  /// 查找文件夹
  FolderItem findFolderBy(AccountItem account) {

    for (var item in folders) {
      if (item.id == account.folderId) {
        return item;
      }
    }
    return folders[folders.length - 1];
  }

  /// 加载文件夹
  Future<List<FolderItem>> loadFolders() async {

    // 加载所有文件夹
    final items = await _appRepository.loadFoldersBy(admin);

    items.add(
      FolderItem(adminId: admin.id, name: S.current.noFolder)
    );

    folderNotifier.value = items;

    return folders;
  }

  /// 加载所有账号
  Future<List<AccountItem>> loadAllAccount() async {

    final items = await _appRepository.loadAllAccountBy(admin);

    // items.addAll(
    //   [
    //     AccountItem(id: 1, adminId: 1, alias: 'Sky1', name: 'jingcai.wei@163.com', password: 'AAAAA', urls: [ "http://www.baidu.com" ], node: 'AAABB', favorite: true),
    //     AccountItem(id: 2, adminId: 1, alias: 'Sky2', name: 'jingcai.wei@163.com', password: 'AAAAA', folderId: 18),
    //     AccountItem(id: 3, adminId: 1, alias: 'Sky3', name: 'jingcai.wei@163.com', password: 'AAAAA'),
    //     AccountItem(id: 4, adminId: 1, alias: 'Sky4', name: 'jingcai.wei@163.com', password: 'AAAAA', folderId: 17),
    //     AccountItem(id: 5, adminId: 1, alias: 'Sky5', name: 'jingcai.wei@163.com', password: 'AAAAA', favorite: true),
    //     AccountItem(id: 6, adminId: 1, alias: 'Sky6', name: 'jingcai.wei@163.com', password: 'AAAAA', trash: true),
    //     AccountItem(id: 7, adminId: 1, alias: 'Sky7', name: 'jingcai.wei@163.com', password: 'AAAAA', trash: true),
    //   ]
    // );

    _allAccountItems = _filterAccount(
        accounts: items,
        filter: (item) => !item.trash
    );

    _trashAccountItems = _filterAccount(
        accounts: items,
        filter: (item) => item.trash
    );

    return await loadAccounts(type: SideType.allItems);
  }

  /// 加载账号列表
  Future<List<AccountItem>> loadAccounts({
    int folderId = 0,
    required SideType type
  }) async {

    final List<AccountItem> items;

    switch(type) {
      case SideType.favorite:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.favorite
        );
        break;
      case SideType.allItems:
        items = List.of(_allAccountItems);
        break;
      case SideType.trash:
        items = List.of(_trashAccountItems);
        break;
      case SideType.folder:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.folderId == folderId
        );
        break;
      default:
        items = [];
    }

    _lastType = type;
    _filterAccountItems = items;

    return await searchAccount(keyword: _lastKeyword);
  }

  /// 搜索账号
  Future<List<AccountItem>> searchAccount({
    required String keyword
  }) async {

    _lastKeyword = keyword;

    if (keyword.isEmpty) {
      accountNotifier.value = _filterAccountItems;
      return accounts;
    }

    final items = _filterAccount(
      accounts: _filterAccountItems,
      filter: (item) => item.contains(keyword)
    );

    accountNotifier.value = items;
    
    return accounts;
  }

  /// 创建账号
  Future<AccountItem> createAccount(AccountItem item) async {

    final result = await _appRepository.createAccount(item);



    return result;
  }

  /// 删除账号
  Future<AccountItem> deleteAccount(AccountItem item) async {
    return item;
  }

  Future<AccountItem> updateAccount(AccountItem item) async {

    final result = await _appRepository.updateAccount(item);

    return result;
  }

  /// 收藏账号与取消
  Future<AccountItem> favoriteAccount(AccountItem item) async {

    final updateItem = item.copy(favorite: !item.favorite);




    // final accounts = List<AccountItem>.of(_filterAccountItems);
    // final index = folders.indexOf(result);
    // folders.removeAt(index);
    // folders.insert(index, result);

    return item;
  }

  /// 创建空的账号
  AccountItem newEmptyAccount() {
    return AccountItem(adminId: admin.id, alias: '', name: '', password: '');
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
}
