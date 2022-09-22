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
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_title_widget.dart';
import 'package:flutter_polarbear_x/widget/text_label_widget.dart';
import 'package:flutter_polarbear_x/widget/text_menu_widget.dart';


class AboutPage extends StatefulWidget {

  const AboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutPagePageState();
}

class _AboutPagePageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(S.of(context).settings),
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
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitleWidget(title: '参数设置'),
          TextMenuWidget(
              "属性设置",
              '',
              onTap: () {
              }
          ),
        ],
      ),
    );
  }
}
