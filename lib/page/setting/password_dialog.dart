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

import '../../generated/l10n.dart';
import '../../util/size_box_util.dart';


class PasswordDialog extends StatelessWidget {


  const PasswordDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SizedBox(
        width: 400,
        child: PasswordWidget(),
      ),
    );
  }
}

class PasswordWidget extends StatefulWidget {

  const PasswordWidget({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {

  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController(text: '');
    _newPasswordController = TextEditingController(text: '');
    _confirmPasswordController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();
    _confirmPasswordController.dispose();
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        XBox.vertical30,
        Text(
          S.of(context).changePassword,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),
        ),
        XBox.vertical10,
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  autofocus: true,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: S.of(context).oldPassword,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      )
                  ),
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    return v!.trim().isEmpty ? S.of(context).xCanNotEmpty(S.of(context).password) : null;
                  }
                ),
                XBox.vertical20,
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: S.of(context).newPassword,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      )
                  ),
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    return v!.trim().isEmpty ? S.of(context).xCanNotEmpty(S.of(context).password) : null;
                  }
                ),
                XBox.vertical20,
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: S.of(context).confirmPassword,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      )
                  ),
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    return v!.trim().isEmpty ? S.of(context).xCanNotEmpty(S.of(context).password) : _newPasswordController.text != v ? S.of(context).passwordNotMatch : null;
                  }
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1),
        Row(
          children: [
            Expanded(
                child: _buildTextButton(
                    text: S.of(context).cancel,
                    onPressed: _cancel
                )
            ),
            XBox.horizontal5,
            const SizedBox(
              width: 1,
              height: 40,
              child: VerticalDivider(thickness: 1),
            ),
            XBox.horizontal5,
            Expanded(
              child: _buildTextButton(
                  text: S.of(context).ok,
                  onPressed: _ok
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildTextButton({
    required String text,
    required VoidCallback? onPressed
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 26, 20, 26))
      ),
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _ok() {

    if (!(_formKey.currentState as FormState).validate()) {
      return;
    }

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

