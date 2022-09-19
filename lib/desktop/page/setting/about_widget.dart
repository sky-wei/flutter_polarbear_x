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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/launch_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';

class AboutWidget extends StatefulWidget {

  const AboutWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {

  final String _mail = 'jingcai.wei@163.com';
  final String _source = 'https://github.com/sky-wei/flutter_polarbear_x';

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _handlePress;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          XBox.vertical30,
          Image.asset(
            'assets/image/ic_head_logo.png',
            width: 100,
            height: 100,
          ),
          Text(
            S.of(context).appName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          XBox.vertical5,
          Text(
            S.of(context).versionX(XConstant.versionName),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          XBox.vertical40,
          SelectableText(S.of(context).mailX(_mail)),
          XBox.vertical10,
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: S.of(context).sourceX('')),
                TextSpan(
                  text: _source,
                  style: TextStyle(
                    color: Theme.of(context).themeColor
                  ),
                  recognizer: _tapGestureRecognizer
                )
              ]
            )
          ),
          XBox.vertical60,
          Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SelectableText(S.of(context).license),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理点击事件
  void _handlePress() {
    LaunchUtil.launchUrl(_source);
  }
}

