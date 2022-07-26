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

import '../../theme/color.dart';

class XTheme {

  XTheme._();

  static ThemeData lightTheme() => ThemeData(
    primarySwatch: XColor.blue,
    backgroundColor: const Color(0xFFF7F7F7),
    iconTheme: const IconThemeData(color: XColor.black),
    primaryIconTheme: const IconThemeData(color: XColor.black),
    cardColor: XColor.white
  );

  static ThemeData darkTheme() => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: XColor.blue,
    backgroundColor: const Color(0xFF333333),
    cardColor: const Color(0xFF404040),
  );
}

extension XThemeData on ThemeData {

  Color get themeColor => XColor.themeColor;

  Color get sideColor => isLight ? XColor.sideColor : const Color(0xFF121212);

  Color get sideTextColor => isLight ? XColor.sideTextColor : XColor.white;

  Color get sideChooseColor => isLight ? XColor.sideChooseColor : const Color(0xFF2D2D2D);

  Color get favoriteColor => XColor.favoriteColor;

  Color get deleteColor => XColor.deleteColor;

  Color get listChooseColor => isLight ? XColor.listChooseColor : const Color(0xFF363636);

  Color get listColor => isLight ? XColor.listColor : const Color(0xFF28292A);

  Color get mainTextColor => isLight ? const Color(0xFF212121) : XColor.white;

  Color get iconColor => isLight ? const Color(0xFF212121) : XColor.white;

  Color get settingsColor => XColor.white;

  Color get closeColor => isLight ? XColor.black : XColor.white;

  bool get isLight => brightness == Brightness.light;

  bool get isDark => brightness == Brightness.dark;
}
