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
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/color.dart';
import '../../util/size_box_util.dart';

class HomeUserInfoWidget extends StatefulWidget {

  const HomeUserInfoWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeUserInfoState();
}

class _HomeUserInfoState extends State<HomeUserInfoWidget> {

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
            splashColor: XColor.sideChooseColor,
            highlightColor: XColor.sideChooseColor,
            onTap: () { },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                        'assets/image/ic_user_head.jpg',
                        width: 36
                    ),
                  ),
                  XBox.horizontal15,
                  const Expanded(
                    child: Text(
                      'jingcai.wei',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XColor.sideTextColor
                      ),
                    ),
                  ),
                  XBox.horizontal15,
                  SvgPicture.asset(
                    'assets/svg/ic_settings.svg',
                    color: XColor.gray2Color,
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
}
