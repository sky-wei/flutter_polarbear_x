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

import 'package:flutter_polarbear_x/data/item/choose.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';

class TimeItem with Choose {

  static TimeItem defaultLock = TimeItem(value: 30);
  static TimeItem defaultClipboard = TimeItem(value: 30, type: second);

  static const int second = 0;
  static const int minute = 1;
  static const int hour = 2;

  final int value;
  final int type;
  final int secondValue;

  @override
  String get name => _timeToString();

  TimeItem({
    required this.value,
    this.type = minute
  }): secondValue = type == hour ? value * 60 * 60 : type == minute ? value * 60 : value;

  String _timeToString() {
    final String text;
    if (value <= 0) {
      text = S.current.never;
    } else {
      final temp = type == TimeItem.second
          ? S.current.second : type == TimeItem.minute
          ? S.current.minute : S.current.hour;
      text = '$value $temp';
    }
    return text;
  }

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
