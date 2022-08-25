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
import 'package:flutter_polarbear_x/model/app_model.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../util/error_util.dart';
import '../../util/message_util.dart';
import '../../util/size_box_util.dart';
import '../../widget/big_button_widget.dart';
import '../../widget/big_input_widget.dart';
import '../../widget/head_logo_widget.dart';
import '../../widget/window_buttons.dart';

class LockPage extends StatefulWidget {

  const LockPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {

  late AppModel _appModel;

  bool _enableView = false;
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
    _passwordController.addListener(_refreshViewState);
  }

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
                  logo: 'assets/image/ic_head_logo.png',
                  title: S.of(context).appName,
                  logoColor: Theme.of(context).themeColor,
                  titleColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            _buildLockWidget(),
          ],
        )
    );
  }

  /// 创建解锁控件
  Widget _buildLockWidget() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
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
              XBox.vertical10,
              ClipOval(
                child: Image.asset(
                  'assets/image/ic_user_head.jpg',
                  width: 80
                ),
              ),
              XBox.vertical20,
              Text(
                _appModel.admin.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              XBox.vertical30,
              BigInputWidget(
                controller: _passwordController,
                iconName: 'ic_password.svg',
                labelText: S.of(context).password,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  if (_enableView) _unlock();
                },
                autofocus: true,
                focusNode: _passwordFocusNode,
              ),
              XBox.vertical40,
              BigButtonWidget(
                onPressed: _enableView ? _unlock : null,
                text: S.of(context).unlock,
              ),
              XBox.vertical15,
              BigButtonWidget(
                onPressed: _logout,
                text: S.of(context).logout,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 刷新控件状态
  void _refreshViewState() {
    final password = _passwordController.text;
    _setViewState(password.isNotEmpty);
  }

  /// 设置状态
  void _setViewState(bool enable) {
    if (_enableView != enable) {
      setState(() { _enableView = enable; });
    }
  }

  /// 登录
  void _unlock() {

    var appModel = context.read<AppModel>();

    appModel.unlock(
      _passwordController.text
    ).then((value) {
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      _passwordFocusNode.requestFocus();
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 退出
  void _logout() {
    _appModel.restartApp(context);
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
