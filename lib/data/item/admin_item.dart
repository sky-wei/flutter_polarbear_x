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

class AdminItem {

  static final AdminItem empty = AdminItem(name: '', password: '');

  final int id;
  final String name;
  final String password;
  final String desc;
  final int createTime;
  int updateTime;

  AdminItem({
   this.id = 0,
   required this.name,
   required this.password,
   this.desc = 'Admin',
    int? createTime,
    int? updateTime,
  }): createTime = createTime ?? DateTime.now().millisecondsSinceEpoch,
    updateTime = updateTime ?? DateTime.now().millisecondsSinceEpoch;

  DateTime get updateDateTime => DateTime.fromMillisecondsSinceEpoch(updateTime);

  AdminItem.valueOf(AdminItem item) :
    id = item.id,
    name = item.name,
    password = item.password,
    desc = item.desc,
    createTime = item.createTime,
    updateTime = item.updateTime;

  AdminItem copy({
    int? id,
    String? name,
    String? password,
    String? desc,
    int? createTime,
    int? updateTime
  }) {
    return AdminItem(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      desc: desc ?? this.desc,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime
    );
  }

  void setUpdateTime() {
    updateTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AdminItem{id: $id, name: $name, password: $password, desc: $desc, createTime: $createTime, updateTime: $updateTime}';
  }
}

