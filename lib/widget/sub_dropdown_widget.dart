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
import 'package:flutter_polarbear_x/data/item/folder_item.dart';

class SubDropdownWidget extends StatelessWidget {

  final String title;
  final FolderItem value;
  final List<FolderItem> items;
  final FocusNode? focusNode;
  final ValueChanged<FolderItem>? onChanged;
  final EdgeInsetsGeometry? padding;

  const SubDropdownWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.items,
    this.focusNode,
    this.onChanged,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Text(
                title,
                style: const TextStyle(fontSize: 16)
            ),
          ),
          DropdownButton<FolderItem>(
            focusNode: focusNode,
            value: value,
            underline: const SizedBox(),
            items: _buildMenuItem(items),
            onChanged: (value) {
              if (onChanged != null) onChanged!(value!);
            },
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<FolderItem>> _buildMenuItem(List<FolderItem> items) {
    return items.map<DropdownMenuItem<FolderItem>>((FolderItem value) {
      return DropdownMenuItem<FolderItem> (
        value: value,
        child: Text(value.name),
      );
    }).toList();
  }
}

