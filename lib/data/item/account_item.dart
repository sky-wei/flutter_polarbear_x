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

class AccountItem {

  static final AccountItem empty = AccountItem(adminId: 0, alias: '', name: '', password: '');

  final int id;
  final int adminId;
  final String alias;
  final String name;
  final String password;
  final List<String> urls;
  final String node;
  final int folderId;
  final bool favorite;
  final bool trash;
  final int createTime;
  final int updateTime;

  AccountItem({
    this.id = 0,
    required this.adminId,
    required this.alias,
    required this.name,
    required this.password,
    this.urls = const [],
    this.node = '',
    this.folderId = -1,
    this.favorite = false,
    this.trash = false,
    this.createTime = 0,
    this.updateTime = 0
  });

  AccountItem copy({
    int? id,
    int? adminId,
    String? alias,
    String? name,
    String? password,
    List<String>? urls,
    String? node,
    int? folderId,
    bool? favorite,
    bool? trash,
    int? createTime,
    int? updateTime,
  }) {
    return AccountItem(
        id: id ?? this.id,
        adminId: adminId ?? this.adminId,
        alias: alias ?? this.alias,
        name: name ?? this.name,
        password: password ?? this.password,
        urls: urls ?? this.urls,
        node: node ?? this.node,
        folderId: folderId ?? this.folderId,
        favorite: favorite ?? this.favorite,
        trash: trash ?? this.trash,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime
    );
  }

  factory AccountItem.fromJson(Map<String, dynamic> json) => AccountItem(
    id: json['id'],
    adminId: json['adminId'],
    alias: json['alias'],
    name: json['name'],
    password: json['password'],
    urls: json['urls'],
    node: json['node'],
    folderId: json['folderId'],
    favorite: json['favorite'],
    trash: json['trash'],
    createTime: json['createTime'],
    updateTime: json['updateTime'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'adminId': adminId,
    'alias': alias,
    'name': name,
    'password': password,
    'urls': urls,
    'node': node,
    'folderId': folderId,
    'favorite': favorite,
    'trash': trash,
    'createTime': createTime,
    'updateTime': updateTime,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          adminId == other.adminId;

  @override
  int get hashCode => id.hashCode ^ adminId.hashCode;

  @override
  String toString() {
    return 'AccountItem{id: $id, adminId: $adminId, alias: $alias, name: $name, password: $password, urls: $urls, node: $node, folderId: $folderId, favorite: $favorite, trash: $trash, createTime: $createTime, updateTime: $updateTime}';
  }
}
