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

import 'package:flutter_polarbear_x/data/item/choose.dart';

class ThemeItem with Choose {

  static const int system = 0;
  static const int light = 1;
  static const int dark = 2;

  @override
  final String name;
  final int value;

  ThemeItem(this.name, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ThemeItem &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}

