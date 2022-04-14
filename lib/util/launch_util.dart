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

import 'package:url_launcher/url_launcher.dart';

import 'log_util.dart';

class LaunchUtil {

  LaunchUtil._();

  static void launchUrl(String url) {
    _launchUrl(
        url
    ).then((value) {
      XLog.d('>>>>>>>>>>>>>>> $value');
    }).onError((error, stackTrace) {
      XLog.d('>>>>>>>>>>>>>>> $error');
    });
  }

  static Future<bool> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      return await launch(url, forceSafariVC: false, forceWebView: false,);
    }
    throw 'Could not launch $url';
  }
}

