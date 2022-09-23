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
import 'package:flutter_polarbear_x/desktop/model/app_desktop_model.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:provider/provider.dart';


class SecurityWidget extends StatefulWidget {

  const SecurityWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SecurityWidgetState();
}

class SecurityWidgetState extends State<SecurityWidget> {

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
    super.initState();
    _appSetting = context.read<AppDesktopModel>().appSetting;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XBox.vertical10,
        Text(
          S.of(context).security,
          style: const TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).lockApp,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical5,
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 180,
          ),
          child: DropdownButton<TimeItem>(
            value: _getLockTime(),
            isExpanded: true,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface
            ),
            items: _buildTimeMenuItem(_lockTimes),
            onChanged: (value) => _setLockTime(value!),
          ),
        ),
        XBox.vertical5,
        Text(
          S.of(context).lockAppTips,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 13
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).clearClipboard,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical5,
        ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 180,
            ),
            child: DropdownButton<TimeItem>(
              value: _getClipboardTime(),
              isExpanded: true,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface
              ),
              items: _buildTimeMenuItem(_clipboardTimes),
              onChanged: (value) => _setClipboardTime(value!),
            )
        ),
        XBox.vertical5,
        Text(
          S.of(context).clearClipboardTips,
          style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 13
          ),
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

  List<DropdownMenuItem<TimeItem>> _buildTimeMenuItem(List<TimeItem> items) {
    return items.map<DropdownMenuItem<TimeItem>>((TimeItem time) {
      return DropdownMenuItem<TimeItem> (
        value: time,
        child: Text(time.name),
      );
    }).toList();
  }
}