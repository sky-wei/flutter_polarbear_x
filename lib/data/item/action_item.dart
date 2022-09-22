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

import 'package:flutter/material.dart';

class ActionItem {

  final String icon;
  final Color? iconColor;
  final String name;
  final Color? textColor;

  ActionItem({
    required this.icon,
    required this.name,
    this.iconColor,
    this.textColor
  });

  factory ActionItem.name({
    required String name,
    Color? textColor
  }) {
    return ActionItem(icon: '', name: name, textColor: textColor);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ActionItem &&
              runtimeType == other.runtimeType &&
              icon == other.icon &&
              name == other.name;

  @override
  int get hashCode => icon.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'ActionItem{icon: $icon, name: $name}';
  }
}
