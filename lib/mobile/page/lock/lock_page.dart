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
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/big_button_widget.dart';
import 'package:flutter_polarbear_x/widget/big_input_widget.dart';
import 'package:provider/provider.dart';


class LockPage extends StatefulWidget {

  const LockPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {

  late AppMobileModel _appModel;

  bool _enableView = false;
  bool _enablePasswordAction = false;
  bool _obscurePassword = true;

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppMobileModel>();
    _passwordController.addListener(_refreshViewState);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appName),
          titleTextStyle: TextStyle(
              color: Theme.of(context).mainTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 60, 40, 50),
          child: Column(
              children: [
                XBox.vertical50,
                ClipOval(
                  child: Image.asset(
                    'assets/image/ic_user_head.jpg',
                    width: 70,
                  ),
                ),
                XBox.vertical15,
                Text(
                  _appModel.admin.name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                  ),
                ),
                XBox.vertical40,
                BigInputWidget(
                  controller: _passwordController,
                  iconName: 'ic_password.svg',
                  labelText: S.of(context).password,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    if (_enableView) _unlock();
                  },
                  autofocus: true,
                  focusNode: _passwordFocusNode,
                  actionIconName: _enablePasswordAction ? (_obscurePassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
                  actionPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
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
              ]
          ),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
      ),
    );
  }

  /// 刷新控件状态
  void _refreshViewState() {
    final password = _passwordController.text;
    _setPasswordViewState(password.isNotEmpty);
    _setViewState(password.isNotEmpty);
  }

  /// 设置状态
  void _setPasswordViewState(bool enable) {
    if (_enablePasswordAction != enable) {
      setState(() { _enablePasswordAction = enable; });
    }
  }

  /// 设置状态
  void _setViewState(bool enable) {
    if (_enableView != enable) {
      setState(() { _enableView = enable; });
    }
  }

  /// 登录
  void _unlock() {

    var appModel = context.read<AppMobileModel>();

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
}
