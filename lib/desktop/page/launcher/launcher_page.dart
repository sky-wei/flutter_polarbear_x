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

import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/desktop/widget/window_buttons.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/big_title_widget.dart';
import 'package:flutter_polarbear_x/widget/head_logo_widget.dart';

import 'login_widget.dart';
import 'register_widget.dart';

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
              'assets/image/launcher_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _buildWindowTitleBar(),
          ),
          if (Platform.isLinux || Platform.isWindows)
            Align(
              alignment: Alignment.topLeft,
              child: HeadLogoWidget(
                logo: XConstant.headLogo,
                title: S.of(context).appName,
                logoColor: XColor.white.withOpacity(0.8),
                titleColor: XColor.white.withOpacity(0.8),
              ),
            ),
          _buildLauncherWidget(),
        ],
      )
    );
  }

  /// 创建登录与注册控件
  Widget _buildLauncherWidget() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: SizedBox(
        width: 370,
        height: 470,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 55, top: 40, right: 55, bottom: 0
          ),
          child: Column(
            children: [
              BigTitleWidget(S.of(context).appName),
              XBox.vertical40,
              _buildTabBarWidget(
                index: _currentIndex,
                onValueChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              ),
              XBox.vertical30,
              _buildTabView()
            ],
          ),
        ),
      ),
    );
  }

  /// 创建Tab
  Widget _buildTabView() {
    if (_currentIndex == 0) {
      return const LoginWidget();
    }
    return const RegisterWidget();
  }

  /// 创建TabBar
  Widget _buildTabBarWidget({
    required int index,
    required ValueChanged onValueChanged
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildTabTextButton(
            text: S.of(context).login,
            select: index == 0,
            onPressed: () => onValueChanged(0)
        ),
        XBox.horizontal10,
        _buildTabTextButton(
            text: S.of(context).signUp,
            select: index == 1,
            onPressed: () => onValueChanged(1)
        )
      ],
    );
  }

  /// 创建按钮
  Widget _buildTabTextButton({
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

  /// 创建Bar
  Widget _buildWindowTitleBar() {
    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(child: MoveWindow()),
          const WindowButtons()
        ],
      ),
    );
  }
}
