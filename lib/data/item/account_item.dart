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

import 'package:flutter_polarbear_x/data/item/folder_item.dart';

class AccountItem {

  static final AccountItem empty = AccountItem(adminId: 0, alias: '', name: '', password: '');

  final int id;
  final int adminId;

  String _alias;
  String _lowerAlias;
  String get alias => _alias;
  set alias(String value) {
    _alias = value;
    _lowerAlias = value.toLowerCase();
  }

  String _name;
  String _lowerName;
  String get name => _name;
  set name(String value) {
    _name = value;
    _lowerName = value.toLowerCase();
  }

  String password;

  String _url;
  String _lowerUrl;
  String get url => _url;
  set url(String value) {
    _url = value;
    _lowerUrl = value.toLowerCase();
  }

  String _node;
  String _lowerNode;
  String get node => _node;
  set node(String value) {
    _node = value;
    _lowerNode = value.toLowerCase();
  }

  int folderId;
  bool favorite;
  bool trash;
  final int createTime;
  int updateTime;
  int version;

  DateTime get createDateTime => DateTime.fromMillisecondsSinceEpoch(createTime);

  DateTime get updateDateTime => DateTime.fromMillisecondsSinceEpoch(updateTime);

  AccountItem({
    this.id = 0,
    required this.adminId,
    required String alias,
    required String name,
    required this.password,
    String url = '',
    String node = '',
    this.folderId = FolderItem.noFolder,
    this.favorite = false,
    this.trash = false,
    int? createTime,
    int? updateTime,
    this.version = 1
  }): _alias = alias,
    _lowerAlias = alias.toLowerCase(),
    _name = name,
    _lowerName = name.toLowerCase(),
    _url = url,
    _lowerUrl = url.toLowerCase(),
    _node = node,
    _lowerNode = node.toLowerCase(),
    createTime = createTime ?? DateTime.now().millisecondsSinceEpoch,
    updateTime = updateTime ?? DateTime.now().millisecondsSinceEpoch;

  AccountItem copy({
    int? id,
    int? adminId,
    String? alias,
    String? name,
    String? password,
    String? url,
    String? node,
    int? folderId,
    bool? favorite,
    bool? trash,
    int? createTime,
    int? updateTime,
    int? version,
  }) {
    return AccountItem(
        id: id ?? this.id,
        adminId: adminId ?? this.adminId,
        alias: alias ?? this.alias,
        name: name ?? this.name,
        password: password ?? this.password,
        url: url ?? this.url,
        node: node ?? this.node,
        folderId: folderId ?? this.folderId,
        favorite: favorite ?? this.favorite,
        trash: trash ?? this.trash,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
        version: version ?? this.version
    );
  }

  factory AccountItem.formAdmin(int id) {
    return AccountItem(adminId: id, alias: '', name: '', password: '', version: 1);
  }

  factory AccountItem.fromJson(Map<String, dynamic> json) => AccountItem(
    id: json['id'] ?? 0,
    adminId: json['adminId'] ?? 0,
    alias: json['alias'] ?? '',
    name: json['name'] ?? '',
    password: json['password'] ?? '',
    url: json['url'] ?? '',
    node: json['node'] ?? '',
    folderId: json['folderId'] ?? FolderItem.noFolder,
    favorite: json['favorite'] ?? false,
    trash: json['trash'] ?? false,
    createTime: json['createTime'] ?? DateTime.now().millisecondsSinceEpoch,
    updateTime: json['updateTime'] ?? DateTime.now().millisecondsSinceEpoch,
    version: json['version'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    // 'adminId': adminId,
    'alias': alias,
    'name': name,
    'password': password,
    'url': url,
    'node': node,
    // 'folderId': folderId,
    // 'favorite': favorite,
    // 'trash': trash,
    'createTime': createTime,
    // 'updateTime': updateTime,
    // 'version': version,
  };

  bool contains(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return _lowerAlias.contains(lowerKeyword)
        || _lowerName.contains(lowerKeyword)
        || _lowerUrl.contains(lowerKeyword)
        || _lowerNode.contains(lowerKeyword);
  }

  bool _contains(List<String> values, String keyword) {
    for(var value in values) {
      if (value.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// 判断账号信息是否一致
  bool unanimous(AccountItem original) {
    return id == original.id &&
        adminId == original.adminId &&
        alias == original.alias &&
        name == original.name &&
        password == original.password &&
        url == original.url &&
        node == original.node &&
        folderId == original.folderId &&
        favorite == original.favorite;
  }

  void setUpdateTime() {
    updateTime = DateTime.now().millisecondsSinceEpoch;
  }

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
    return 'AccountItem{id: $id, adminId: $adminId, alias: $alias, name: $name, password: $password, url: $url, node: $node, folderId: $folderId, favorite: $favorite, trash: $trash, createTime: $createTime, updateTime: $updateTime, version: $version}';
  }
}
