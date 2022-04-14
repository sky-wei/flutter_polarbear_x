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
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';

import '../../widget/big_button_widget.dart';
import '../../widget/big_input_widget.dart';

class LoginWidget extends StatefulWidget {

  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
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
        const SizedBox(height: 40),
        BigButtonWidget(
          onPressed: () {

          },
          text: 'Login',
        ),
        XBox.vertical20,
        TextButton(
            onPressed: () {  },
            child: Text(
              'Forget Password?',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onSurface
              ),
            )
        )
      ],
    );
  }
}
