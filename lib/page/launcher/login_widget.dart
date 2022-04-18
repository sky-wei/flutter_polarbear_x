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
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/fade_animate_widget.dart';

import '../../widget/big_button_widget.dart';
import '../../widget/big_input_widget.dart';

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
  }

  @override
  void dispose() {
    _passwordController.removeListener(_refreshViewState);
    _nameController.removeListener(_refreshViewState);
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
            labelText: 'Name',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          BigInputWidget(
            controller: _passwordController,
            iconName: 'ic_password.svg',
            labelText: 'Password',
            obscureText: true,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              if (_enableView) _login();
            },
          ),
          XBox.vertical40,
          BigButtonWidget(
            onPressed: _enableView ? _login : null,
            text: 'Login',
          ),
          XBox.vertical20,
          _buildTextButton('Forget Password?'),
        ],
      ),
    );
  }

  void _refreshViewState() {
    final name = _nameController.text;
    final password = _passwordController.text;
    _setViewState(name.isNotEmpty && password.isNotEmpty);
  }

  void _setViewState(bool enable) {
    if (_enableView != enable) {
      setState(() { _enableView = enable; });
    }
  }

  void _login() {
    Navigator.pushReplacementNamed(context, XRoute.home);
  }

  Widget _buildTextButton(String text) {
    return TextButton(
      onPressed: () {  },
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
}
