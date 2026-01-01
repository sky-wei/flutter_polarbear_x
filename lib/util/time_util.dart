
/*
 * Copyright (c) 2023 The sky Authors.
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

import 'package:intl/intl.dart';

class TimeUtil {

  static final DateFormat dateFormat = DateFormat.yMMMMd()..add_Hm();
  static final DateFormat ymdFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat ymdHmsFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  TimeUtil._();

  static DateTime getCurDateTime() => DateTime.now();

  static int getCurTime() => DateTime.now().millisecondsSinceEpoch;

  static DateTime timeFrom(int milliseconds) => DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static String formatDate(DateTime date) {
    return formatDateBy(dateFormat, date);
  }

  static String formatDateBy(DateFormat format, DateTime date) {
    return format.format(date);
  }

  static String formatMilliseconds(int milliseconds) {
    return formatMillisecondsBy(dateFormat, milliseconds);
  }

  static String formatMillisecondsBy(DateFormat format, int milliseconds) {
    return format.format(timeFrom(milliseconds));
  }
}