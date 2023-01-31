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
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/desktop/model/app_desktop_model.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/image_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../setting/setting_dialog.dart';

class HomeUserInfoWidget extends StatefulWidget {

  const HomeUserInfoWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeUserInfoState();
}

class _HomeUserInfoState extends State<HomeUserInfoWidget> {

  late AppDesktopModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppDesktopModel>();
    _appModel.addListener(_infoChange);
  }

  @override
  void dispose() {
    super.dispose();
    _appModel.removeListener(_infoChange);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: XColor.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            splashColor: Theme.of(context).sideChooseColor,
            highlightColor: Theme.of(context).sideChooseColor,
            onTap: _settings,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  ClipOval(
                    child: ImageUtil.create(
                        _appModel.admin.getUserImage(),
                        width: 36
                    ),
                  ),
                  XBox.horizontal15,
                  Expanded(
                    child: Text(
                      _appModel.admin.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).sideTextColor
                      ),
                    ),
                  ),
                  XBox.horizontal15,
                  SvgPicture.asset(
                    'assets/svg/ic_settings.svg',
                    color: Theme.of(context).settingsColor,
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 信息修改
  void _infoChange() {
    setState(() {
      // 信息修改需要刷新
    });
  }

  /// 打开设置
  void _settings() {
    showDialog(
      context: context,
      builder: (context) => const SettingDialog()
    );
  }
}
