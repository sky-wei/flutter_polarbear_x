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
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../model/app_model.dart';
import '../../../route.dart';
import '../../../route/mobile_page_route.dart';
import '../../../util/error_util.dart';
import '../../../util/message_util.dart';
import '../../../widget/big_button_widget.dart';
import '../../../widget/big_input_widget.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _enableView = false;
  bool _enableNameAction = false;
  bool _enablePasswordAction = false;
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  FocusNode? _lastFocusNode;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ActionMenuWidget(
          iconName: 'ic_m_close.svg',
          onPressed: () => SystemNavigator.pop(),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 50),
        children: [
          Text(
            S.of(context).appName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).mainTextColor
            ),
          ),
          XBox.vertical60,
          BigInputWidget(
            controller: _nameController,
            iconName: 'ic_user.svg',
            labelText: S.of(context).name,
            textInputAction: TextInputAction.next,
            focusNode: _nameFocusNode,
            autofocus: true,
            actionIconName: _enableNameAction ? 'ic_close.svg' : null,
            actionPressed: () => _nameController.clear()
          ),
          XBox.vertical20,
          BigInputWidget(
            controller: _passwordController,
            iconName: 'ic_password.svg',
            labelText: S.of(context).password,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              if (_enableView) _login();
            },
            focusNode: _passwordFocusNode,
            actionIconName: _enablePasswordAction ? (_obscurePassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
            actionPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          XBox.vertical5,
          _buildForgetPassword(
            onPressed: () {
              MessageUtil.showMessage(context, S.of(context).notSupport);
            }
          ),
          XBox.vertical30,
          BigButtonWidget(
            onPressed: _enableView ? _login : null,
            text: S.of(context).login,
            size: const Size(double.infinity, 50),
          ),
          XBox.vertical20,
          _buildTextButton(
            text: S.of(context).signUp,
            textColor: Theme.of(context).themeColor,
            onPressed: _signUp
          ),
        ],
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    );
  }

  /// 刷新控件状态
  void _refreshViewState() {
    final name = _nameController.text;
    final password = _passwordController.text;
    _setNameViewState(name.isNotEmpty);
    _setPasswordViewState(password.isNotEmpty);
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

  /// 设置状态
  void _setNameViewState(bool enable) {
    if (_enableNameAction != enable) {
      setState(() { _enableNameAction = enable; });
    }
  }

  /// 设置状态
  void _setPasswordViewState(bool enable) {
    if (_enablePasswordAction != enable) {
      setState(() { _enablePasswordAction = enable; });
    }
  }

  /// 创建忘记密码控件
  Widget _buildForgetPassword({
    required VoidCallback? onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildTextButton(
          text: S.of(context).forgetPassword,
          onPressed: onPressed
        )
      ],
    );
  }

  /// 创建按钮
  Widget _buildTextButton({
    required String text,
    Color? textColor,
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textColor ?? Theme.of(context).colorScheme.onSurface
        ),
      )
    );
  }

  /// 登录
  void _login() {

    var name = _nameController.text;
    var password = _passwordController.text;

    var appModel = context.read<AppModel>();

    appModel.loginByAdmin(
      name: name, password: password
    ).then((value) {
      Navigator.pushReplacementNamed(context, XRoute.home);
    }).onError((error, stackTrace) {
      _lastFocusNode?.requestFocus();
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 注册
  Future<void> _signUp() async {
    final value = await Navigator.push<String>(
      context,
      MobilePageRoute<String>(
        child: RegisterPage(name: _nameController.text)
      )
    );

    if (value != null && value.isNotEmpty) {
      Navigator.pushReplacementNamed(context, value);
    }
  }
}

