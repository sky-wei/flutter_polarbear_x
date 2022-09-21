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
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';

class ListEmptyWidget extends StatelessWidget {

  final String tips;
  final VoidCallback? onPressed;

  const ListEmptyWidget({
    Key? key,
    required this.tips,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double bottom = PlatformUtil.isMobile() ? 0 : 130;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Material(
          color: XColor.transparent,
          child: Ink(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 28, top: 24, right: 28, bottom: 24
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                        'assets/svg/ic_empty.svg',
                        color: XColor.themeColor,
                        width: 46,
                        height: 46
                    ),
                    const SizedBox(height: 20),
                    Text(tips),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
