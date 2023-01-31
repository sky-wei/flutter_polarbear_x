
/*
 * Copyright (c) 2023 The sky Authors.
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

import '../data/entity/account_entity.dart';
import '../data/entity/admin_entity.dart';
import '../data/entity/folder_entity.dart';
import '../data/objectbox.dart';
import '../data/objectbox.g.dart';
import 'component.dart';
import 'context.dart';

abstract class XDataManager implements XComponent {

  static const String componentName = 'dataManager';

  static XDataManager getDataManager(XContext context) {
    return context.getComponent(componentName);
  }

  Box<AdminEntity> get adminBox;

  Box<FolderEntity> get folderBox;

  Box<AccountEntity> get accountBox;
}


class DataManager extends AbstractComponent implements XDataManager {

  final ObjectBox objectBox;

  @override
  Box<AdminEntity> get adminBox => objectBox.adminBox;

  @override
  Box<FolderEntity> get folderBox => objectBox.folderBox;

  @override
  Box<AccountEntity> get accountBox => objectBox.accountBox;

  DataManager(this.objectBox);

  @override
  void dispose() {
    super.dispose();
    objectBox.dispose();
  }
}