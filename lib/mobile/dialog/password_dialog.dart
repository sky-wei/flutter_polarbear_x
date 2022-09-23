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
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/big_input_widget.dart';


class PasswordDialog extends StatelessWidget {

  const PasswordDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 150),
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
            ),
            child: const PasswordWidget()
        )
    );
  }
}

class PasswordWidget extends StatefulWidget {

  const PasswordWidget({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _enableOldPasswordAction = false;
  bool _enableNewPasswordAction = false;
  bool _enableConfirmPasswordAction = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    _oldPasswordController.addListener(_refreshViewState);
    _newPasswordController.addListener(_refreshViewState);
    _confirmPasswordController.addListener(_refreshViewState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.removeListener(_refreshViewState);
    _newPasswordController.removeListener(_refreshViewState);
    _confirmPasswordController.removeListener(_refreshViewState);
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildTextButton(
                  text: S.of(context).cancel,
                  onPressed: _cancel
              ),
              XBox.horizontal5,
              Expanded(
                  child: Center(
                    child: Text(
                      S.of(context).changePassword,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
              ),
              XBox.horizontal5,
              _buildTextButton(
                  text: S.of(context).ok,
                  onPressed: _ok
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                BigInputWidget(
                  controller: _oldPasswordController,
                  iconName: 'ic_password.svg',
                  labelText: S.of(context).oldPassword,
                  obscureText: _obscureOldPassword,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  actionIconName: _enableOldPasswordAction ? (_obscureOldPassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
                  actionPressed: () {
                    setState(() => _obscureOldPassword = !_obscureOldPassword);
                  },
                ),
                XBox.vertical20,
                BigInputWidget(
                  controller: _newPasswordController,
                  iconName: 'ic_password.svg',
                  labelText: S.of(context).newPassword,
                  obscureText: _obscureNewPassword,
                  textInputAction: TextInputAction.next,
                  actionIconName: _enableNewPasswordAction ? (_obscureNewPassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
                  actionPressed: () {
                    setState(() => _obscureNewPassword = !_obscureNewPassword);
                  },
                ),
                XBox.vertical20,
                BigInputWidget(
                  controller: _confirmPasswordController,
                  iconName: 'ic_password.svg',
                  labelText: S.of(context).confirmPassword,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) => _ok(),
                  actionIconName: _enableConfirmPasswordAction ? (_obscureConfirmPassword ? 'ic_visibility.svg' : 'ic_invisible.svg') : null,
                  actionPressed: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback? onPressed
  }) {
    final double height = PlatformUtil.isMobile() ? 18 : 26;
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, height, 20, height))
      ),
    );
  }

  /// 刷新控件状态
  void _refreshViewState() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    _setOldPasswordViewState(oldPassword.isNotEmpty);
    _setNewPasswordViewState(newPassword.isNotEmpty);
    _setConfirmPasswordViewState(confirmPassword.isNotEmpty);
  }

  /// 设置状态
  void _setOldPasswordViewState(bool enable) {
    if (_enableOldPasswordAction != enable) {
      setState(() { _enableOldPasswordAction = enable; });
    }
  }

  /// 设置状态
  void _setNewPasswordViewState(bool enable) {
    if (_enableNewPasswordAction != enable) {
      setState(() { _enableNewPasswordAction = enable; });
    }
  }

  /// 设置状态
  void _setConfirmPasswordViewState(bool enable) {
    if (_enableConfirmPasswordAction != enable) {
      setState(() { _enableConfirmPasswordAction = enable; });
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _ok() {

    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final result = PasswordResult(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    Navigator.pop(context, result);
  }
}

class PasswordResult {

  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  PasswordResult({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

