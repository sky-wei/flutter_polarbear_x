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
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../model/app_model.dart';
import '../../util/size_box_util.dart';

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

  late AppModel _appModel;
  late AppSetting _appSetting;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
    _appSetting = _appModel.getAppSetting();
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
      final String text;
      if (time.value <= 0) {
        text = S.of(context).never;
      } else {
        final type = time.type == TimeItem.second
            ? S.of(context).second : time.type == TimeItem.minute
            ? S.of(context).minute : S.of(context).hour;
        text = '${time.value} $type';
      }
      return DropdownMenuItem<TimeItem> (
        value: time,
        child: Text(text),
      );
    }).toList();
  }
}

class TimeItem {

  static TimeItem defaultLock = TimeItem(value: 30);
  static TimeItem defaultClipboard = TimeItem(value: 30, type: second);

  static const int second = 0;
  static const int minute = 1;
  static const int hour = 2;

  final int value;
  final int type;
  final int secondValue;

  TimeItem({
    required this.value,
    this.type = minute
  }): secondValue = type == hour ? value * 60 * 60 : type == minute ? value * 60 : value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeItem &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          type == other.type &&
          secondValue == other.secondValue;

  @override
  int get hashCode => value.hashCode ^ type.hashCode ^ secondValue.hashCode;

  @override
  String toString() {
    return 'TimeItem{value: $value, type: $type, secondValue: $secondValue}';
  }
}