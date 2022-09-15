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
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../model/app_model.dart';
import '../../../route.dart';
import '../../../util/error_util.dart';
import '../../../util/message_util.dart';
import '../../../util/size_box_util.dart';
import '../../../widget/action_menu_widget.dart';
import '../../../widget/big_button_widget.dart';
import '../../../widget/big_input_widget.dart';

class RegisterPage extends StatefulWidget {

  final String name;

  const RegisterPage({
    Key? key,
    required this.name
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  bool _enableView = false;
  bool _enableNameAction = false;
  bool _enablePasswordAction = false;
  bool _enableConfirmPasswordAction = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late TextEditingController _nameController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  FocusNode? _lastFocusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _nameController.addListener(_refreshViewState);
    _passwordController.addListener(_refreshViewState);
    _confirmPasswordController.addListener(_refreshViewState);
    _nameFocusNode.addListener(_focusEvent);
    _passwordFocusNode.addListener(_focusEvent);
    _confirmPasswordFocusNode.addListener(_focusEvent);
  }

  @override
  void dispose() {
    _confirmPasswordController.removeListener(_refreshViewState);
    _passwordController.removeListener(_refreshViewState);
    _nameController.removeListener(_refreshViewState);
    _nameFocusNode.removeListener(_focusEvent);
    _passwordFocusNode.removeListener(_focusEvent);
    _confirmPasswordFocusNode.removeListener(_focusEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ActionMenuWidget(
          iconName: 'ic_m_close.svg',
          onPressed: () => Navigator.pop(context),
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
            focusNode: _passwordFocusNode,
            actionIconName: _enablePasswordAction ? (_obscurePassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
            actionPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          XBox.vertical20,
          BigInputWidget(
            controller: _confirmPasswordController,
            iconName: 'ic_password.svg',
            labelText: S.of(context).confirmPassword,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              if (_enableView) _register();
            },
            focusNode: _confirmPasswordFocusNode,
            actionIconName: _enableConfirmPasswordAction ? (_obscureConfirmPassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
            actionPressed: () {
              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
          ),
          XBox.vertical40,
          BigButtonWidget(
            onPressed: _enableView ? _register : null,
            text: S.of(context).signUp,
            size: const Size(double.infinity, 50),
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
    final confirmPassword = _confirmPasswordController.text;
    _setNameViewState(name.isNotEmpty);
    _setPasswordViewState(password.isNotEmpty);
    _setConfirmPasswordViewState(confirmPassword.isNotEmpty);
    _setViewState(name.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty);
  }

  /// 焦点事件
  void _focusEvent() {
    if (_nameFocusNode.hasFocus) {
      _lastFocusNode = _nameFocusNode;
    } else if (_passwordFocusNode.hasFocus) {
      _lastFocusNode = _passwordFocusNode;
    } else if (_confirmPasswordFocusNode.hasFocus) {
      _lastFocusNode = _confirmPasswordFocusNode;
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

  /// 设置状态
  void _setConfirmPasswordViewState(bool enable) {
    if (_enableConfirmPasswordAction != enable) {
      setState(() { _enableConfirmPasswordAction = enable; });
    }
  }

  /// 注册
  void _register() {

    var name = _nameController.text;
    var password = _passwordController.text;
    var confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _lastFocusNode?.requestFocus();
      MessageUtil.showMessage(context, S.of(context).passwordNotMatch);
      return;
    }

    var appModel = context.read<AppModel>();

    appModel.createAdmin(
        name: name, password: password
    ).then((value) {
      Navigator.pop(context, XRoute.home);
    }).onError((error, stackTrace) {
      _lastFocusNode?.requestFocus();
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }
}
