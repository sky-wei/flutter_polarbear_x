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

import 'package:flutter/cupertino.dart';

import '../../widget/big_button_widget.dart';
import '../../widget/big_input_widget.dart';

class RegisterWidget extends StatefulWidget {

  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BigInputWidget(
          iconName: 'ic_user.svg',
          labelText: 'Name',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        BigInputWidget(
          iconName: 'ic_password.svg',
          labelText: 'Password',
          obscureText: true,
          textInputAction: TextInputAction.next,
          // onFieldSubmitted: (value) => _login(),
        ),
        const SizedBox(height: 15),
        BigInputWidget(
          iconName: 'ic_password.svg',
          labelText: 'Confirm Password',
          obscureText: true,
          textInputAction: TextInputAction.next,
          // onFieldSubmitted: (value) => _login(),
        ),
        const SizedBox(height: 40),
        BigButtonWidget(
          onPressed: () {

          },
          text: 'Sign Up',
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
