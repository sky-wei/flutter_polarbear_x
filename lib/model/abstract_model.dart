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

import 'package:flutter_polarbear_x/core/repository.dart';

import '../core/clipboard.dart';
import '../core/context.dart';
import '../core/database.dart';
import '../core/settings.dart';
import '../util/easy_notifier.dart';

class AbstractModel extends EasyNotifier {

  final XContext context;

  AbstractModel(this.context);

  XSettings get appSetting => context.appSetting;

  XDataManager get dataManager => context.dataManager;

  XRepository get appRepository => context.appRepository;

  XClipboard get clipboardManager => context.clipboardManager;
}
