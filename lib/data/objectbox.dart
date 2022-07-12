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

import 'entity/account_entity.dart';
import 'entity/admin_entity.dart';
import 'objectbox.g.dart';

class ObjectBox {

  late final Store store;

  late final Box<AdminEntity> adminBox;
  late final Box<AccountEntity> accountBox;
  late final Box<FolderEntity> folderBox;

  ObjectBox._create(this.store) {
    adminBox = Box<AdminEntity>(store);
    accountBox = Box<AccountEntity>(store);
    folderBox = Box<FolderEntity>(store);
  }

  /// 创建ObjectBox
  static Future<ObjectBox> create({
    String? directory
  }) async {
    final store = await openStore(
      directory: directory
    );
    return ObjectBox._create(store);
  }

  /// 释放资源
  void dispose() {
    if (!store.isClosed()) store.close();
  }
}

