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
import 'package:flutter_polarbear_x/desktop/model/app_desktop_model.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/big_button_widget.dart';
import 'package:flutter_polarbear_x/widget/big_input_widget.dart';
import 'package:flutter_polarbear_x/widget/fade_animate_widget.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {

  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  bool _enableView = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  FocusNode? _lastFocusNode;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this
    );
    _animationController.forward();
    _nameController.addListener(_refreshViewState);
    _passwordController.addListener(_refreshViewState);
    _nameFocusNode.addListener(_focusEvent);
    _passwordFocusNode.addListener(_focusEvent);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_refreshViewState);
    _nameController.removeListener(_refreshViewState);
    _nameFocusNode.removeListener(_focusEvent);
    _passwordFocusNode.removeListener(_focusEvent);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimateWidget(
      animation: _animationController,
      child: Column(
        children: [
          BigInputWidget(
            controller: _nameController,
            iconName: 'ic_user.svg',
            labelText: S.of(context).name,
            textInputAction: TextInputAction.next,
            focusNode: _nameFocusNode,
            autofocus: true,
          ),
          XBox.vertical15,
          BigInputWidget(
            controller: _passwordController,
            iconName: 'ic_password.svg',
            labelText: S.of(context).password,
            obscureText: true,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              if (_enableView) _login();
            },
            focusNode: _passwordFocusNode,
          ),
          XBox.vertical40,
          BigButtonWidget(
            onPressed: _enableView ? _login : null,
            text: S.of(context).login,
          ),
          XBox.vertical20,
          _buildTextButton(
            text: S.of(context).forgetPassword,
            onPressed: () {
              MessageUtil.showMessage(context, S.of(context).notSupport);
            }
          ),
        ],
      ),
    );
  }

  /// 刷新控件状态
  void _refreshViewState() {
    final name = _nameController.text;
    final password = _passwordController.text;
    _setViewState(name.isNotEmpty && password.isNotEmpty);
  }

  /// 焦点事件
  void _focusEvent() {
    if (_nameFocusNode.hasFocus) {
      _lastFocusNode = _nameFocusNode;
    } else if (_passwordFocusNode.hasFocus) {
      _lastFocusNode = _passwordFocusNode;
    }
  }

  /// 设置状态
  void _setViewState(bool enable) {
    if (_enableView != enable) {
      setState(() { _enableView = enable; });
    }
  }

  /// 创建按钮
  Widget _buildTextButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Theme.of(context).colorScheme.onSurface
        ),
      )
    );
  }

  /// 登录
  void _login() {

    var name = _nameController.text;
    var password = _passwordController.text;

    var appModel = context.read<AppDesktopModel>();

    appModel.loginByAdmin(
        name: name, password: password
    ).then((value) {
      Navigator.pushReplacementNamed(context, XRoute.home);
    }).onError((error, stackTrace) {
      _lastFocusNode?.requestFocus();
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }
}
