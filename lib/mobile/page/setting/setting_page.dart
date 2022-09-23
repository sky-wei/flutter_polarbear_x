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
import 'package:flutter_polarbear_x/mobile/page/setting/about_page.dart';
import 'package:flutter_polarbear_x/mobile/page/setting/account_page.dart';
import 'package:flutter_polarbear_x/mobile/page/setting/preference_page.dart';
import 'package:flutter_polarbear_x/mobile/page/setting/security_page.dart';
import 'package:flutter_polarbear_x/mobile/page/setting/storage_page.dart';
import 'package:flutter_polarbear_x/route/mobile_page_route.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_item_line.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_menu_widget.dart';


class SettingPage extends StatefulWidget {

  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

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
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      children: [
        SubListWidget(
          children: [
            SubMenuWidget(
              iconName: 'ic_user.svg',
              title: S.of(context).account,
              moreIconName: 'ic_arrow_right.svg',
              padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
              onTap: () => Navigator.push(context, MobilePageRoute(child: const AccountPage())),
            )
          ],
        ),
        XBox.vertical20,
        SubListWidget(
          children: [
            SubMenuWidget(
              iconName: 'ic_all_items.svg',
              title: S.of(context).preference,
              moreIconName: 'ic_arrow_right.svg',
              padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
              onTap: () => Navigator.push(context, MobilePageRoute(child: const PreferencePage())),
            ),
            const SubItemLine(padding: EdgeInsets.only(left: 55)),
            SubMenuWidget(
              iconName: 'ic_security.svg',
              title: S.of(context).security,
              moreIconName: 'ic_arrow_right.svg',
              padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
              onTap: () => Navigator.push(context, MobilePageRoute(child: const SecurityPage())),
            ),
            const SubItemLine(padding: EdgeInsets.only(left: 55)),
            SubMenuWidget(
              iconName: 'ic_storage.svg',
              title: S.of(context).storage,
              moreIconName: 'ic_arrow_right.svg',
              padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
              onTap: () => Navigator.push(context, MobilePageRoute(child: const StoragePage())),
            ),
          ],
        ),
        XBox.vertical20,
        SubListWidget(
          children: [
            SubMenuWidget(
              iconName: 'ic_about.svg',
              title: S.of(context).about,
              moreIconName: 'ic_arrow_right.svg',
              padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
              onTap: () => Navigator.push(context, MobilePageRoute(child: const AboutPage())),
            ),
          ],
        )
      ],
    );
  }
}
