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
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../main.dart';
import '../../model/app_model.dart';
import '../../util/size_box_util.dart';

class SecurityWidget extends StatefulWidget {

  const SecurityWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SecurityWidgetState();
}

class SecurityWidgetState extends State<SecurityWidget> {


  late AppSetting _appSetting;

  @override
  void initState() {
    super.initState();
    _appSetting = context.read<AppModel>().getAppSetting();
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
        // Text(
        //   S.of(context).storage,
        //   style: TextStyle(
        //       color: Theme.of(context).hintColor
        //   ),
        // ),
        // XBox.vertical20,
        // ElevatedButton(
        //   onPressed: () {
        //     // RestartWidget.restartApp(context);
        //   },
        //   style: ButtonStyle(
        //     elevation: MaterialStateProperty.all(0),
        //     backgroundColor: MaterialStateProperty.all(
        //       Theme.of(context).deleteColor
        //     )
        //   ),
        //   child: Text(S.of(context).clearData),
        // )
      ],
    );
  }
}