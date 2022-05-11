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

import 'package:flutter_polarbear_x/data/repository/encrypt_store.dart';
import 'package:flutter_polarbear_x/util/easy_notifier.dart';
import 'package:path_provider/path_provider.dart';

import '../data/item/admin_item.dart';
import '../data/objectbox.dart';
import '../data/repository/app_repository.dart';

abstract class AbstractModel extends EasyNotifier {}

class AppModel extends AbstractModel {

  bool _init = false;
  late AppRepository _appRepository;

  AdminItem _admin = AdminItem.empty;

  // 获取管理员信息
  AdminItem get admin => _admin;

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
            password: password,
            createTime: DateTime.now().millisecondsSinceEpoch
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

  /// 更新管理员信息
  AdminItem _updateAdmin(AdminItem item) {
    notify(() => _admin = item);
    return item;
  }
}
