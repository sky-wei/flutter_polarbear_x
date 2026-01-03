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

import 'package:flutter_polarbear_x/core/database.dart';
import 'package:flutter_polarbear_x/data/entity/folder_entity.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/mapper/account_mapper.dart';
import 'package:flutter_polarbear_x/data/mapper/folder_mapper.dart';

import '../data/data_exception.dart';
import '../data/entity/account_entity.dart';
import '../data/entity/admin_entity.dart';
import '../data/item/account_item.dart';
import '../data/item/admin_item.dart';
import '../data/mapper/admin_mapper.dart';
import '../data/objectbox.g.dart';
import 'component.dart';
import 'context.dart';
import 'encrypt.dart';


abstract class XRepository implements XComponent {

  static const String componentName = 'appRepository';

  static XRepository getAppRepository(XContext context) {
    return context.getComponent(componentName);
  }

  Future<AdminItem> createAdmin(AdminItem admin);

  Future<AdminItem> updateAdmin(AdminItem admin);

  Future<AdminItem> loginByAdmin(AdminItem admin);

  Future<FolderItem> createFolder(FolderItem folder);

  Future<FolderItem> deleteFolder(FolderItem folder);

  Future<FolderItem> updateFolder(FolderItem folder);

  Future<List<FolderItem>> loadFoldersBy(AdminItem admin);

  Future<List<AccountItem>> loadAllAccountBy(AdminItem admin);

  Future<AccountItem> createAccount(AdminItem admin, AccountItem account);

  Future<List<AccountItem>> createAccountList(AdminItem admin, List<AccountItem> accounts);

  Future<AccountItem> updateAccount(AdminItem admin, AccountItem account);

  Future<List<AccountItem>> updateAccounts(AdminItem admin, List<AccountItem> accounts);

  Future<AccountItem> deleteAccount(AdminItem admin, AccountItem account);

  Future<bool> clearData(AdminItem admin);

  AccountItem encryptAccount(String password, AccountItem account);

  AccountItem decryptAccount(String password, AccountItem account);
}

class AppRepository extends AbstractComponent implements XRepository {

  final XDataManager dataManager;
  final XEncrypt encryptStore;

  Box<AdminEntity> get adminBox => dataManager.adminBox;

  Box<FolderEntity> get folderBox => dataManager.folderBox;

  Box<AccountEntity> get accountBox => dataManager.accountBox;

  AppRepository({
    required this.dataManager,
    required this.encryptStore
  });

  /// 创建管理员账号
  @override
  Future<AdminItem> createAdmin(AdminItem admin) async {

    final enAdmin = _encryptAdmin(admin);

    final entity = adminBox
        .query(AdminEntity_.name.equals(enAdmin.name))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.adminExist);
    }

    final id = adminBox.put(AdminMapper.transformItem(enAdmin));

    return enAdmin.copy(id: id, password: admin.password);
  }

  /// 更新管理员账号
  @override
  Future<AdminItem> updateAdmin(AdminItem admin) async {

    final enAdmin = _encryptAdmin(admin);

    final entity = adminBox
        .query(AdminEntity_.id.equals(enAdmin.id))
        .build()
        .findFirst();

    if (entity == null) {
      throw DataException.type(type: ErrorType.updateError);
    }

    adminBox.put(AdminMapper.transformItem(enAdmin), mode: PutMode.update);

    return enAdmin.copy(password: admin.password);
  }

  /// 登录账号
  @override
  Future<AdminItem> loginByAdmin(AdminItem admin) async {

    final enAdmin = _encryptAdmin(admin);

    final entity = adminBox
        .query(AdminEntity_.name.equals(enAdmin.name))
        .build()
        .findFirst();

    if (entity == null) {
      if ("Demo" == admin.name && "a123456" == admin.password) {
        // 应用市场测试用户。创建Demo用户，插入账号数据。
        final demoAdmin = await createAdmin(admin);
        await createAccount(demoAdmin, AccountItem(adminId: demoAdmin.id, alias: "Demo1", name: "Test1", password: "123456", url: "https://www.test.com", node: "Test", favorite: true));
        await createAccount(demoAdmin, AccountItem(adminId: demoAdmin.id, alias: "Demo2", name: "Test2", password: "123456", url: "https://www.test.com", node: "Test"));
        await createAccount(demoAdmin, AccountItem(adminId: demoAdmin.id, alias: "Demo2", name: "Test3", password: "123456", url: "https://www.test.com", node: "Test"));
        return demoAdmin;
      }
      throw DataException.type(type: ErrorType.nameOrPasswordError);
    }

    if (entity.password != enAdmin.password) {
      throw DataException.type(type: ErrorType.nameOrPasswordError);
    }

    return AdminMapper.transformEntity(entity).copy(password: admin.password);
  }

  /// 创建文件夹
  @override
  Future<FolderItem> createFolder(FolderItem folder) async {

    final entity = folderBox
        .query(FolderEntity_.adminId.equals(folder.adminId).and(FolderEntity_.name.equals(folder.name)))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.folderExist);
    }

    final id = folderBox.put(FolderMapper.transformItem(folder));

    return folder.copy(id: id);
  }

  /// 删除文件夹
  @override
  Future<FolderItem> deleteFolder(FolderItem folder) async {
    if (!folderBox.remove(folder.id)) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return folder;
  }

  /// 更新文件夹
  @override
  Future<FolderItem> updateFolder(FolderItem folder) async {

    final entity = folderBox
        .query(FolderEntity_.adminId.equals(folder.adminId).and(FolderEntity_.name.equals(folder.name)))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.folderExist);
    }

    final result = folderBox.put(
        FolderMapper.transformItem(folder),
        mode: PutMode.update
    );

    if (result <= 0) {
      throw DataException.type(type: ErrorType.updateError);
    }
    return folder;
  }

  /// 加载文件夹
  @override
  Future<List<FolderItem>> loadFoldersBy(AdminItem admin) async {

    final entities = folderBox
        .query(FolderEntity_.adminId.equals(admin.id))
        .build()
        .find();

    return FolderMapper.transformEntities(entities);
  }

  /// 加载所有账号(包括删除的账号)
  @override
  Future<List<AccountItem>> loadAllAccountBy(AdminItem admin) async {

    final entities = accountBox
        .query(AccountEntity_.adminId.equals(admin.id))
        .build()
        .find();

    final accounts = AccountMapper.transformEntities(entities);

    return accounts.map((account) {
      return _decryptAccount(admin, account);
    }).toList();
  }

  /// 创建账号
  @override
  Future<AccountItem> createAccount(AdminItem admin, AccountItem account) async {

    final enAccount = _encryptAccount(admin, account);

    final id = accountBox.put(AccountMapper.transformItem(enAccount));

    return account.copy(id: id);
  }

  /// 创建账号
  @override
  Future<List<AccountItem>> createAccountList(AdminItem admin, List<AccountItem> accounts) async {

    if (accounts.isEmpty) return accounts;

    final List<AccountItem> result = [];

    for (var account in accounts) {
      result.add(await createAccount(admin, account));
    }

    return result;
  }

  /// 更新账号信息
  @override
  Future<AccountItem> updateAccount(AdminItem admin, AccountItem account) async {

    final enAccount = _encryptAccount(admin, account);

    final result = accountBox.put(
        AccountMapper.transformItem(enAccount), mode: PutMode.update
    );

    if (result <= 0) {
      throw DataException.type(type: ErrorType.updateError);
    }
    return account;
  }

  /// 更新账号信息
  @override
  Future<List<AccountItem>> updateAccounts(AdminItem admin, List<AccountItem> accounts) async {

    if (accounts.isEmpty) return accounts;

    final enAccounts = accounts.map((account) {
      return _encryptAccount(admin, account);
    }).toList();

    final result = accountBox.putMany(
        AccountMapper.transformItems(enAccounts), mode: PutMode.update
    );

    if (result.isEmpty) {
      throw DataException.type(type: ErrorType.updateError);
    }
    return accounts;
  }

  /// 删除账号
  @override
  Future<AccountItem> deleteAccount(AdminItem admin, AccountItem account) async {
    if (!accountBox.remove(account.id)) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return account;
  }

  /// 清除数据
  @override
  Future<bool> clearData(AdminItem admin) async {

    final result = accountBox
        .query(AccountEntity_.adminId.equals(admin.id))
        .build()
        .remove();

    if (result < 0) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return true;
  }

  /// 加密账号信息
  @override
  AccountItem encryptAccount(String password, AccountItem account) {
    return password.isEmpty ? account : account.copy(
      name: encryptStore.encrypt(password, account.name),
      password: encryptStore.encrypt(password, account.password),
      url: encryptStore.encrypt(password, account.url),
      node: encryptStore.encrypt(password, account.node),
    );
  }

  /// 解密账号信息
  @override
  AccountItem decryptAccount(String password, AccountItem account) {
    return password.isEmpty ? account : account.copy(
      name: encryptStore.decrypt(password, account.name),
      password: encryptStore.decrypt(password, account.password),
      url: encryptStore.decrypt(password, account.url),
      node: encryptStore.decrypt(password, account.node),
    );
  }

  /// 加密管理员的密码
  AdminItem _encryptAdmin(AdminItem item) {
    return item.copy(password: encryptStore.md5sum(item.password));
  }

  /// 加密账号信息
  AccountItem _encryptAccount(AdminItem admin, AccountItem account) {
    return encryptAccount(admin.password, account);
  }

  /// 解密账号信息
  AccountItem _decryptAccount(AdminItem admin, AccountItem account) {
    return decryptAccount(admin.password, account);
  }
}
