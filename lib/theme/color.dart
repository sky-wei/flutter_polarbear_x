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

class XColor {

  XColor._();

  static const Color white = Color(0xFFFFFFFF);

  static const Color transparent = Color(0x00000000);

  static const Color black = Color(0xFF000000);

  static const Color backgroundColor = Color(0xFFF7F7F7);

  static const Color iconColor = Color(0xFF8A8A8A);

  static const Color grayColor = Color(0xFF888888);

  static const Color gray2Color = Color(0xFFBFBFBF);

  static const Color themeColor = Color(_redPrimaryValue);


  static const MaterialColor red = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFFebf5fb),
      100: Color(0xFFd6eaf8),
      200: Color(0xFFaed6f1),
      300: Color(0xFF85c1e9),
      400: Color(0xFF5cade2),
      500: Color(_redPrimaryValue),
      600: Color(0xFF2f86c1),
      700: Color(0xFF2874a6),
      800: Color(0xFF21618c),
      900: Color(0xFF1c4f72),
    },
  );
  
  static const int _redPrimaryValue = 0xFF3398da;
}
