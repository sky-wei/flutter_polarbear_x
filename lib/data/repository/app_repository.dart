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

  /// 创建管理员账号
  Future<AdminItem> createAdmin(AdminItem item) async {

    var entity = adminBox
        .query(AdminEntity_.name.equals(item.name))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.adminExist);
    }

    var id = adminBox.put(AdminMapper.transformItem(item));

    return item.copy(id: id);
  }

  /// 登录账号
  Future<AdminItem> loginByAdmin(AdminItem item) async {

    var entity = adminBox
        .query(AdminEntity_.name.equals(item.name))
        .build()
        .findFirst();

    if (entity == null) {
      throw DataException.type(type: ErrorType.nameOrPasswordError);
    }

    if (entity.password != item.password) {
      throw DataException.type(type: ErrorType.nameOrPasswordError);
    }

    return AdminMapper.transformEntity(entity);
  }


  /// 创建文件夹
  Future<FolderItem> createFolder(FolderItem item) async {

    var entity = folderBox
        .query(FolderEntity_.name.equals(item.name))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.folderExist);
    }

    var id = folderBox.put(FolderMapper.transformItem(item));

    return item.copy(id: id);
  }

  /// 删除文件夹
  Future<FolderItem> deleteFolder(FolderItem item) async {
    if (!folderBox.remove(item.id)) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return item;
  }

  /// 更新文件夹
  Future<FolderItem> updateFolder(FolderItem item) async {

    var entity = folderBox
        .query(FolderEntity_.name.equals(item.name))
        .build()
        .findFirst();

    if (entity != null) {
      throw DataException.type(type: ErrorType.updateError);
    }

    var updateEntity = FolderMapper.transformItem(item);
    var result = folderBox.put(updateEntity, mode: PutMode.update);

    if (result <= 0) {
      throw DataException.type(type: ErrorType.updateError);
    }

    return item;
  }

  /// 加载文件夹
  Future<List<FolderItem>> loadFoldersBy(AdminItem item) async {

    var entities = folderBox
        .query(FolderEntity_.adminId.equals(item.id))
        .build()
        .find();

    return FolderMapper.transformEntities(entities);
  }

  // /// 加载收藏账号
  // Future<List<AccountItem>> loadFavoriteAccountBy(AdminItem item) async {
  //
  //   var entities = accountBox
  //       .query(
  //         AccountEntity_.adminId.equals(item.id)
  //             .and(AccountEntity_.trash.equals(false))
  //             .and(AccountEntity_.favorite.equals(true))
  //       )
  //       .build()
  //       .find();
  //
  //   return AccountMapper.transformEntities(entities);
  // }

  /// 加载所有账号(包括删除的账号)
  Future<List<AccountItem>> loadAllAccountBy(AdminItem item) async {

    var entities = accountBox
        .query(AccountEntity_.adminId.equals(item.id))
        .build()
        .find();

    return AccountMapper.transformEntities(entities);
  }

  /// 创建账号
  Future<AccountItem> createAccount(AccountItem item) async {
    var id = accountBox.put(AccountMapper.transformItem(item));
    return item.copy(id: id);
  }

  /// 创建账号
  Future<List<int>> createAccountList(List<AccountItem> items) async {
    return accountBox.putMany(AccountMapper.transformItems(items));
  }

  /// 更新账号信息
  Future<AccountItem> updateAccount(AccountItem item) async {

    var result = accountBox.put(
        AccountMapper.transformItem(item), mode: PutMode.update
    );

    if (result <= 0) {
      throw DataException.type(type: ErrorType.updateError);
    }
    return item;
  }

  /// 删除账号
  Future<AccountItem> deleteAccount(AccountItem item) async {
    if (!accountBox.remove(item.id)) {
      throw DataException.type(type: ErrorType.deleteError);
    }
    return item;
  }

  /// 加密管理员的密码
  AdminItem encryptAdmin(AdminItem item) {
    return item.copy(password: encryptStore.md5sum(item.password));
  }

  /// 加密账号信息
  AccountItem encryptAccount(AdminItem admin, AccountItem account) {
    return account;
    // return account.copy(password: encryptStore.encrypt(admin.password, account.password));
  }

  /// 解密账号信息
  AccountItem decryptAccount(AdminItem admin, AccountItem account) {
    return account;
    // return account.copy(password: encryptStore.decrypt(admin.password, account.password));
  }
}
