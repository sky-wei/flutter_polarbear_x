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
import 'package:flutter_polarbear_x/data/item/time_item.dart';
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_dropdown_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_label_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:provider/provider.dart';


class SecurityPage extends StatefulWidget {

  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {

  final List<TimeItem> _lockTimes = [
    TimeItem(value: 5),
    TimeItem(value: 10),
    TimeItem(value: 15),
    TimeItem.defaultLock,
    TimeItem(value: 1, type: TimeItem.hour),
    TimeItem(value: 0),
  ];

  final List<TimeItem> _clipboardTimes = [
    TimeItem(value: 10, type: TimeItem.second),
    TimeItem(value: 20, type: TimeItem.second),
    TimeItem.defaultClipboard,
    TimeItem(value: 1),
    TimeItem(value: 2),
    TimeItem(value: 5),
    TimeItem(value: 0),
  ];

  TimeItem get defaultLock => TimeItem.defaultLock;
  TimeItem get defaultClipboard => TimeItem.defaultClipboard;

  late AppSetting _appSetting;

  @override
  void initState() {
    _appSetting = context.read<AppMobileModel>().appSetting;
    super.initState();
  }

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
      title: Text(S.of(context).security),
      titleTextStyle: TextStyle(
        color: Theme.of(context).mainTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 创建界面内容
  Widget _buildBodyContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      children: [
        SubListWidget(
          children: [
            SubDropdownWidget<TimeItem>(
              padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 15),
              title: S.of(context).lockApp,
              value: _getLockTime(),
              items: _lockTimes,
              onChanged: (value) => _setLockTime(value),
            )
          ],
        ),
        SubLabelWidget(
          S.of(context).lockAppTips,
          padding: const EdgeInsets.only(left: 20, top: 10),
        ),
        XBox.vertical20,
        SubListWidget(
          children: [
            SubDropdownWidget<TimeItem>(
              padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 15),
              title: S.of(context).clearClipboard,
              value: _getClipboardTime(),
              items: _clipboardTimes,
              onChanged: (value) => _setClipboardTime(value),
            )
          ],
        ),
        SubLabelWidget(
          S.of(context).clearClipboardTips,
          padding: const EdgeInsets.only(left: 20, top: 10),
        ),
      ],
    );
  }

  TimeItem _getLockTime() {
    final timeItem = _appSetting.getLockTime(defaultLock);
    return _lockTimes.firstWhere((time) {
      return time == timeItem;
    }, orElse: () => defaultLock);
  }

  void _setLockTime(TimeItem time) {
    if (time != _getLockTime()) {
      _appSetting.setLockTime(time).then((value) {
        setState(() { });
      });
    }
  }

  TimeItem _getClipboardTime() {
    final timeItem = _appSetting.getClipboardTime(defaultClipboard);
    return _clipboardTimes.firstWhere((time) {
      return time == timeItem;
    }, orElse: () => defaultClipboard);
  }

  void _setClipboardTime(TimeItem time) {
    if (time != _getClipboardTime()) {
      _appSetting.setClipboardTime(time).then((value) {
        setState(() { });
      });
    }
  }
}
