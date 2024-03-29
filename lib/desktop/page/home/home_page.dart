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
import 'package:flutter_polarbear_x/desktop/widget/window_buttons.dart';

import 'home_info.dart';
import 'home_list.dart';
import 'home_side.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildHomeFrame(context),
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
                const WindowButtons()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHomeFrame(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: HomeSide(),
        ),
        const Expanded(
          flex: 2,
          child: HomeList(),
        ),
        Expanded(
          flex: 6,
          child: HomeInfo(themeData: Theme.of(context))
        )
      ],
    );
  }
}
