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
import 'package:flutter_polarbear_x/main.dart';
import 'package:flutter_polarbear_x/page/setting/sub_text_widget.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../model/app_model.dart';
import '../../util/size_box_util.dart';

class AccountWidget extends StatefulWidget {

  const AccountWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {

  late AppModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XBox.vertical10,
            Text(
              S.of(context).accountInformation,
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).name,
              content: _appModel.admin.name,
              action: S.of(context).changeName,
              onPressed: () {

              },
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).password,
              content: '******',
              action: S.of(context).changePassword,
              onPressed: () {

              },
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).notes,
              content: _appModel.admin.desc,
              action: S.of(context).changeNotes,
              onPressed: () {

              },
            ),
            XBox.vertical40,
            ElevatedButton(
              onPressed: () {
                RestartWidget.restartApp(context);
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(XColor.deleteColor)
              ),
              child: Text(S.of(context).logout),
            )
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 10),
            child: _buildHeadWidget(
              onPressed: () {

              }
            ),
          ),
        )
      ],
    );
  }

  /// 生成头像
  Widget _buildHeadWidget({required VoidCallback onPressed}) {
    return ClipOval(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Image.asset(
            'assets/image/ic_user_head.jpg',
            width: 70
          ),
          Positioned(
            top: 50,
            width: 70,
            height: 20,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0x60000000)
              ),
              child: Center(
                child: InkWell(
                  onTap: onPressed,
                  child: Text(
                    S.of(context).edit,
                    style: const TextStyle(
                      color: Color(0xEEFFFFFF),
                      fontSize: 12
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

