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

import 'package:flutter/cupertino.dart';
import 'package:flutter_polarbear_x/theme/color.dart';

import '../util/size_box_util.dart';

class HeadLogoWidget extends StatelessWidget {

  final String logo;
  final Color? logoColor;
  final String title;
  final Color? titleColor;

  const HeadLogoWidget({
    Key? key,
    required this.logo,
    required this.title,
    this.logoColor = XColor.themeColor,
    this.titleColor = XColor.logoTextColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            logo,
            width: 22,
            color: logoColor,
          ),
          XBox.horizontal5,
          Text(
            title,
            style: TextStyle(
              color: titleColor
            ),
          )
        ],
      ),
    );
  }
}

