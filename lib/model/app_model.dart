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

class AbstractModel extends EasyNotifier {

}

class AppModel extends AbstractModel {

  bool _init = false;
  late AppRepository _appRepository;

  final ValueNotifier<List<FolderItem>> folderNotifier = ValueNotifier([]);
  final ValueNotifier<List<AccountItem>> accountNotifier = ValueNotifier([]);

  AdminItem _admin = AdminItem(id: 1, name: 'Sky', password: '123456');

  // 获取管理员信息
  AdminItem get admin => _admin;

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

  /// 加载文件夹
  Future<List<FolderItem>> loadFolders() async {

    folderNotifier.value = await _appRepository.loadFoldersBy(admin);

    return folders;
  }

  /// 加载账号列表
  Future<List<AccountItem>> loadAccounts({
    int id = 0,
    required SideType type
  }) async {

    XLog.d('>>>>>>>>>>>>>>>>>>>> $id  $type');

    final items = [
      AccountItem(id: 0, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 1, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 2, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 3, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 4, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 5, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 6, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
      AccountItem(id: 7, adminId: 1, alias: 'Sky', name: 'jingcai.wei@163.com', password: 'AAA'),
    ];

    accountNotifier.value = items;

    return accounts;
  }

  /// 更新管理员信息
  AdminItem _updateAdmin(AdminItem item) {
    notify(() => _admin = item);
    return item;
  }
}
