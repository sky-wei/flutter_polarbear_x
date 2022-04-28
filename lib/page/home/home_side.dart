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
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/side_item.dart';
import '../../util/size_box_util.dart';
import '../../widget/head_logo_widget.dart';
import 'home_user_info.dart';


typedef ChooseItem<T> = bool Function(T value);


class HomeSide extends StatefulWidget {

  const HomeSide({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeSideState();
}

class _HomeSideState extends State<HomeSide> {

  final Map<String, SideItem> _sideMap = {
    'Favorites': SideItem(name: 'Favorites', icon: 'assets/svg/ic_favorites.svg'),
    'AllItems': SideItem(name: 'All Items', icon: 'assets/svg/ic_all_items.svg'),
    'Trash': SideItem(name: 'Trash', icon: 'assets/svg/ic_trash.svg'),
  };
  
  SideItem? _curSideItem;


  @override
  void initState() {
    super.initState();
    _curSideItem = _sideMap['AllItems'];
  }

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
              item: _sideMap['Favorites']!,
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
            XBox.vertical5,
            SideItemWidget(
              item: _sideMap['AllItems']!,
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
            XBox.vertical5,
            SideItemWidget(
              item: _sideMap['Trash']!,
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
            XBox.vertical10,
            SideFolderWidget(
              name: "Folders",
            ),
            XBox.vertical5,
            SideItemWidget(
              item: SideItem(
                icon: 'assets/svg/ic_folder.svg',
                name: 'Demo1'
              ),
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
            XBox.vertical5,
            SideItemWidget(
              item: SideItem(
                  icon: 'assets/svg/ic_folder.svg',
                  name: 'Demo2'
              ),
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
            XBox.vertical5,
            SideItemWidget(
              item: SideItem(
                  icon: 'assets/svg/ic_folder.svg',
                  name: 'Demo3'
              ),
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
          ],
        ),
      ),
    );
  }
  
  bool _isChooseItem(SideItem item) => _curSideItem == item;
  
  void _chooseHandler(SideItem item) {
    setState(() {
      _curSideItem = item;
    });
  }
}

class SideItemWidget extends StatelessWidget {
  
  final SideItem item;
  final ChooseItem<SideItem> onChoose;
  final ValueChanged<SideItem>? onPressed;

  const SideItemWidget({
    Key? key,
    required this.item,
    required this.onChoose,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final choose = onChoose(item);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: XColor.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: choose ? XColor.sideChooseColor : XColor.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: InkWell(
            splashColor: XColor.sideChooseColor,
            highlightColor: XColor.sideChooseColor,
            borderRadius: BorderRadius.circular(6),
            onTap: () { if (onPressed != null) onPressed!(item); },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  if (item.icon != null)
                    SvgPicture.asset(
                      item.icon!,
                      color: choose ? XColor.themeColor : XColor.sideTextColor,
                      width: 18,
                    ),
                  if (item.icon != null)
                    XBox.horizontal15,
                  Text(
                    item.name,
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

class SideFolderWidget extends StatelessWidget {

  final String name;

  const SideFolderWidget({
    Key? key,
    required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: XColor.gray2Color,
                fontWeight: FontWeight.normal
              ),
            )
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/svg/ic_add.svg',
              color: XColor.sideTextColor,
              width: 16,
            )
          ),
        ],
      ),
    );
  }
}

