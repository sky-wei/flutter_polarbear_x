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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/page/launcher/register_widget.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';

import '../../widget/big_title_widget.dart';
import 'login_widget.dart';

class LauncherPage extends StatefulWidget {

  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(
              'assets/image/wallhavenx.png',
              fit: BoxFit.cover,
            ),
          ),
          // const DecoratedBox(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //       colors: [Color(0xFFfed6e3), Color(0xFFa8edea)],
          //     )
          //   ),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: double.infinity,
          //   ),
          // ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: SizedBox(
              width: 380,
              // height: 470,
              child: _buildLauncherWidget(),
            ),
          )
        ],
      )
    );
  }

  Widget _buildLauncherWidget() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20, top: 40, right: 20, bottom: 30
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BigTitleWidget(
            title: 'PasswordX'
          ),
          XBox.vertical40,
          _tabSwitchWidget(
            index: _currentIndex,
            onValueChanged: (index) => setState(() {
              _currentIndex = index;
            })
          ),
          XBox.vertical30,
          Expanded(
            flex: 0,
            child: _buildTabContent()
          )
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    if (_currentIndex == 0) {
      return const LoginWidget();
    }
    return const RegisterWidget();
  }

  Widget _tabSwitchWidget({
    required int index,
    required ValueChanged onValueChanged
  }) {
    return SizedBox(
      width: 270,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tabTextButton(
            text: 'Login',
            select: index == 0,
            onPressed: () => onValueChanged(0)
          ),
          XBox.horizontal10,
          _tabTextButton(
            text: 'Sign Up',
            select: index == 1,
            onPressed: () => onValueChanged(1)
          )
        ],
      ),
    );
  }

  Widget _tabTextButton({
    required String text,
    required bool select,
    VoidCallback? onPressed
  }) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: select ? FontWeight.bold : FontWeight.normal,
              color: Theme.of(context).colorScheme.onSurface
          ),
        )
    );
  }
}
