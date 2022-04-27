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
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/size_box_util.dart';
import '../../widget/head_logo_widget.dart';
import 'home_user_info.dart';

class HomeSide extends StatefulWidget {

  const HomeSide({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSideState();
}

class _HomeSideState extends State<HomeSide> {
  
  @override
  Widget build(BuildContext context) {

    // Theme.of(context).copyWith()

    return Container(
      color: const Color(0xFF1C1F28),
      // color: Theme.of(context).backgroundColor,
      constraints: const BoxConstraints.expand(width: 260),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: XColor.white
        ),
        child: Column(
          children: [
            HeadLogoWidget(),
            HomeUserInfoWidget(),
            XBox.vertical10,
            SideItemWidget(
              icon: 'ic_favorites.svg',
              name: 'Favorites',
            ),
            XBox.vertical5,
            SideItemWidget(
              icon: 'ic_all_items.svg',
              name: 'All Items',
            ),
          ],
        ),
      ),
    );
  }
}

class SideItemWidget extends StatelessWidget {
  
  final String icon;
  final String name;

  const SideItemWidget({
    Key? key,
    required this.icon,
    required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: XColor.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () { },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/$icon',
                    color: XColor.sideTextColor,
                    width: 18,
                  ),
                  XBox.horizontal15,
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: XColor.sideTextColor,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

