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

enum SideType {
  favorite,
  allItems,
  trash,
  folder,
  noFolder,
  none
}

class SideItem {

  final int id;
  final String? icon;
  final String name;
  final SideType type;
  final dynamic data;

  SideItem({
    this.id = 0,
    required this.name,
    this.icon,
    this.type = SideType.none,
    dynamic value
  }): data = value;

  SideItem.text(this.id, this.name): icon = null, type = SideType.none, data = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SideItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          icon == other.icon &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^ icon.hashCode ^ name.hashCode ^ type.hashCode;
}

