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

import 'package:flutter_polarbear_x/core/context.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/model/app_abstract_model.dart';

class AppMobileModel extends AppAbstractModel {

  AppMobileModel(XContext context) : super(context);

  /// 过滤账号列表
  Future<List<AccountItem>> loadAccountBy({
    required SortType type,
    FolderItem? folder
  }) async {

    final List<AccountItem> items;

    switch(type) {
      case SortType.favorite:
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => item.favorite && !item.trash
        );
        break;
      case SortType.allItems:
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => !item.trash
        );
        break;
      case SortType.trash:
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => item.trash
        );
        break;
      case SortType.folder:
        items = filterAccount(
            accounts: allAccountItems,
            filter: (item) => item.folderId == folder!.id && !item.trash
        );
        break;
      default:
        items = [];
    }

    return items;
  }
}
