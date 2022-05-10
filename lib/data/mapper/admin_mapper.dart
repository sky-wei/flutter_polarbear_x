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


import '../entity/admin_entity.dart';
import '../item/admin_item.dart';

class AdminMapper {

  AdminMapper._();

  static List<AdminItem> transformEntities(List<AdminEntity> entities) {
    return entities.map((e) => transformEntity(e)).toList();
  }

  static AdminItem transformEntity(AdminEntity entity) {
    return AdminItem(
      id: entity.id,
      name: entity.name,
      password: entity.password,
      desc: entity.desc,
      createTime: entity.createTime,
      updateTime: entity.updateTime
    );
  }

  static Iterable<AdminEntity> transformItems(List<AdminItem> entities) {
    return entities.map((e) => transformItem(e)).toList();
  }

  static AdminEntity transformItem(AdminItem item) {
    return AdminEntity(
      id: item.id,
      name: item.name,
      password: item.password,
      desc: item.desc,
      createTime: item.createTime,
      updateTime: item.updateTime
    );
  }
}

