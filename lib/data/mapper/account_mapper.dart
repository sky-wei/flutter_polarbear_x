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


import '../entity/account_entity.dart';
import '../item/account_item.dart';

class AccountMapper {

  AccountMapper._();

  static List<AccountItem> transformEntities(List<AccountEntity> entities) {
    return entities.map((e) => transformEntity(e)).toList();
  }

  static AccountItem transformEntity(AccountEntity entity) {
    return AccountItem(
      id: entity.id,
      adminId: entity.adminId,
      alias: entity.alias,
      name: entity.name,
      password: entity.password,
      url: entity.url,
      node: entity.node,
      folderId: entity.folderId,
      favorite: entity.favorite,
      trash: entity.trash,
      createTime: entity.createTime,
      updateTime: entity.updateTime,
      version: entity.version
    );
  }

  static List<AccountEntity> transformItems(List<AccountItem> entities) {
    return entities.map((e) => transformItem(e)).toList();
  }

  static AccountEntity transformItem(AccountItem item) {
    return AccountEntity(
      id: item.id,
      adminId: item.adminId,
      alias: item.alias,
      name: item.name,
      password: item.password,
      url: item.url,
      node: item.node,
      folderId: item.folderId,
      favorite: item.favorite,
      trash: item.trash,
      createTime: item.createTime,
      updateTime: item.updateTime,
      version: item.version
    );
  }
}

