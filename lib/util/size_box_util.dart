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

import 'package:flutter/cupertino.dart';

class XBox {

  XBox._();

  static final SizedBox vertical5 = vertical(5);
  static final SizedBox vertical10 = vertical(10);
  static final SizedBox vertical15 = vertical(15);
  static final SizedBox vertical20 = vertical(20);
  static final SizedBox vertical30 = vertical(30);
  static final SizedBox vertical36 = vertical(36);
  static final SizedBox vertical40 = vertical(40);
  static final SizedBox vertical50 = vertical(50);
  static final SizedBox vertical60 = vertical(60);
  static final SizedBox vertical80 = vertical(80);

  static final SizedBox horizontal5 = horizontal(5);
  static final SizedBox horizontal10 = horizontal(10);
  static final SizedBox horizontal15 = horizontal(15);
  static final SizedBox horizontal20 = horizontal(20);
  static final SizedBox horizontal30 = horizontal(30);
  static final SizedBox horizontal40 = horizontal(40);
  static final SizedBox horizontal60 = horizontal(60);

  static SizedBox vertical(double value) {
    return SizedBox(width: 0, height: value);
  }

  static SizedBox horizontal(double value) {
    return SizedBox(width: value, height: 0);
  }
}
