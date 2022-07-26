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

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';

class WindowButtons extends StatelessWidget {

  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isLight = Theme.of(context).isLight;

    final buttonColors = WindowButtonColors(
        normal: Colors.transparent,
        iconNormal: isLight ? XColor.black : XColor.white,
        mouseOver: const Color(0xFF404040),
        mouseDown: const Color(0xFF202020),
        iconMouseOver: XColor.white,
        iconMouseDown: const Color(0xFFF0F0F0)
    );

    final closeButtonColors = WindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
        iconNormal: isLight ? XColor.black : XColor.white,
        iconMouseOver: XColor.white
    );

    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
