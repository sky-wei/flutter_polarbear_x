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

  /// 加密管理员的密码
  AdminItem encryptAdmin(AdminItem item) {
    return item.copy(password: encryptStore.md5sum(item.password));
  }

  /// 加密账号信息
  AccountItem encryptAccount(AdminItem admin, AccountItem account) {
    return account.copy(password: encryptStore.encrypt(admin.password, account.password));
  }

  /// 解密账号信息
  AccountItem decryptAccount(AdminItem admin, AccountItem account) {
    return account.copy(password: encryptStore.decrypt(admin.password, account.password));
  }
}
