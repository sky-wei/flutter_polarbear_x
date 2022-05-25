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

// enum FolderType {
//   favorite,
//   allItems,
//   trash,
//   folder
// }

class FolderItem {

  static const int noFolder = 0;

  final int id;
  int adminId;
  final String name;
  final int createTime;

  FolderItem({
    this.id = noFolder,
    required this.adminId,
    required this.name,
    this.createTime = 0
  });

  FolderItem copy({
    int? id,
    int? adminId,
    String? name,
    int? createTime,
  }) {
    return FolderItem(
        id: id ?? this.id,
        adminId: id ?? this.adminId,
        name: name ?? this.name,
        createTime: createTime ?? this.createTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FolderItem{id: $id, adminId: $adminId, name: $name, createTime: $createTime}';
  }
}

