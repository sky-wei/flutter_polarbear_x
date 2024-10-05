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
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';


class AboutPage extends StatefulWidget {

  const AboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

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
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    );
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(S.of(context).about),
      titleTextStyle: TextStyle(
        color: Theme.of(context).mainTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    );
  }

  /// 创建界面内容
  Widget _buildBodyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Column(
        children: [
          Image.asset(
            XConstant.headLogo,
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
          SelectableText(S.of(context).mailX(XConstant.mail)),
          XBox.vertical10,
          Text.rich(
              TextSpan(
                  children: [
                    TextSpan(text: S.of(context).sourceX('')),
                    TextSpan(
                        text: XConstant.source,
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
            color: Theme.of(context).scaffoldBackgroundColor,
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
    LaunchUtil.launchUrl(XConstant.source);
  }
}
