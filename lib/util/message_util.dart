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
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

import '../generated/l10n.dart';

class MessageUtil {

  MessageUtil._();

  static showMessage(BuildContext context, String msg) {
    final margin = PlatformUtil.isMobile() ? null : const EdgeInsets.fromLTRB(300, 10, 300, 10);
    final padding = PlatformUtil.isMobile() ? const EdgeInsets.only(left: 15, top: 5, bottom: 5) : const EdgeInsets.all(20);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        margin: margin,
        padding: padding,
        action: SnackBarAction(
          label: S.of(context).close,
          onPressed: () { },
        ),
      )
    );
    // FlutterToastr.show(msg, context);
  }
}

