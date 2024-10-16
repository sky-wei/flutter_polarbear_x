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

import 'data/item/account_item.dart';

typedef ChooseItem<T> = bool Function(T value);

typedef IsLoginCallback = bool Function();

typedef AccountFilter = bool Function(AccountItem account);

typedef PasswordCallback = Future<String?> Function();

typedef CompleteCallback = void Function();

class XConstant {

  static const String versionName = "1.3.0";

  static const String mail = 'jingcai.wei@163.com';

  static const String source = 'https://github.com/sky-wei/flutter_polarbear_x';

  static const String headLogo = 'assets/image/ic_head_logo.png';

  static const String userImage = 'assets/image/ic_user_head.png';
}

