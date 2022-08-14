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

import 'package:flutter_polarbear_x/data/entity/folder_entity.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/mapper/account_mapper.dart';
import 'package:flutter_polarbear_x/data/mapper/folder_mapper.dart';

import '../data_exception.dart';
import '../entity/account_entity.dart';
import '../entity/admin_entity.dart';
import '../item/account_item.dart';
import '../item/admin_item.dart';
import '../mapper/admin_mapper.dart';
import '../objectbox.dart';
import '../objectbox.g.dart';
import 'encrypt_store.dart';

class AppRepository {

  final ObjectBox objectBox;
  final EncryptStore encryptStore;

  Box<AdminEntity> get adminBox => objectBox.adminBox;
  Box<FolderEntity> get folderBox => objectBox.folderBox;
  Box<AccountEntity> get accountBox => objectBox.accountBox;

  AppRepository({
    required this.objectBox,
    required this.encryptStore
  });

  /// 释放资源
  void dispose() {
    objectBox.dispose();
  }

  /// 创建管理员账号
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
  Future<AdminItem> loginByAdmin(AdminItem admin) async {

    final enAdmin = _encryptAdmin(admin);

    final entity = adminBox
        .query(AdminEntity_.name.equals(enAdmin.name))
        .build()
        .findFirst();

    if (entity == null) {
      throw DataException.type(type: ErrorType.nameOrPasswordError);
    }

    if (entity.password != enAdmin.password) {
      throw DataException.type(type: ErrorType.nameOrPasswordError);
    }

    return AdminMapper.transformEntity(entity).copy(password: admin.password);
  }


  /// 创建文件夹
  Future<FolderItem> createFolder(FolderItem folder) async {

    final entity = folderBox
        .query(FolderEntity_.name.equals(folder.name))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.folderExist);
    }

    final id = folderBox.put(FolderMapper.transformItem(folder));

    return folder.copy(id: id);
  }

  /// 删除文件夹
  Future<FolderItem> deleteFolder(FolderItem folder) async {
    if (!folderBox.remove(folder.id)) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return folder;
  }

  /// 更新文件夹
  Future<FolderItem> updateFolder(FolderItem folder) async {

    final entity = folderBox
        .query(FolderEntity_.name.equals(folder.name))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.updateError);
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
  Future<List<FolderItem>> loadFoldersBy(AdminItem admin) async {

    final entities = folderBox
        .query(FolderEntity_.adminId.equals(admin.id))
        .build()
        .find();

    return FolderMapper.transformEntities(entities);
  }

  /// 加载所有账号(包括删除的账号)
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
  Future<AccountItem> createAccount(AdminItem admin, AccountItem account) async {

    final enAccount = _encryptAccount(admin, account);

    final id = accountBox.put(AccountMapper.transformItem(enAccount));

    return account.copy(id: id);
  }

  /// 创建账号
  Future<List<AccountItem>> createAccountList(AdminItem admin, List<AccountItem> accounts) async {

    if (accounts.isEmpty) return accounts;

    final List<AccountItem> result = [];

    for (var account in accounts) {
      result.add(await createAccount(admin, account));
    }

    return result;
  }

  /// 更新账号信息
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
  Future<AccountItem> deleteAccount(AdminItem admin, AccountItem account) async {
    if (!accountBox.remove(account.id)) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return account;
  }

  /// 清除数据
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

  /// 加密账号信息
  AccountItem encryptAccount(String password, AccountItem account) {
    return password.isEmpty ? account : account.copy(
      name: encryptStore.encrypt(password, account.name),
      password: encryptStore.encrypt(password, account.password),
      url: encryptStore.encrypt(password, account.url),
      node: encryptStore.encrypt(password, account.node),
    );
  }

  /// 解密账号信息
  AccountItem decryptAccount(String password, AccountItem account) {
    return password.isEmpty ? account : account.copy(
      name: encryptStore.decrypt(password, account.name),
      password: encryptStore.decrypt(password, account.password),
      url: encryptStore.decrypt(password, account.url),
      node: encryptStore.decrypt(password, account.node),
    );
  }
}
