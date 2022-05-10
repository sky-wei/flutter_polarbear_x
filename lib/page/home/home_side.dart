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

  final List<SideItem> _fixed = [
    SideItem(name: 'Favorites', icon: 'assets/svg/ic_favorites.svg'),
    SideItem(name: 'All Items', icon: 'assets/svg/ic_all_items.svg'),
    SideItem(name: 'Trash', icon: 'assets/svg/ic_trash.svg'),
  ];

  final List<SideItem> _folders = [
    SideItem(icon: 'assets/svg/ic_folder.svg', name: 'Demo1'),
    SideItem(icon: 'assets/svg/ic_folder.svg', name: 'Demo2'),
    SideItem(icon: 'assets/svg/ic_folder.svg', name: 'Demo3'),
    SideItem(icon: 'assets/svg/ic_folder.svg', name: 'Demo4'),
    SideItem(icon: 'assets/svg/ic_folder.svg', name: 'Demo5'),
  ];
  
  SideItem? _curSideItem;


  @override
  void initState() {
    super.initState();
    _curSideItem = _fixed[1];
  }

  @override
  Widget build(BuildContext context) {

    // Theme.of(context).copyWith()

    return Container(
      color: const Color(0xFF222530),
      // color: Theme.of(context).backgroundColor,
      constraints: const BoxConstraints.expand(width: 260),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: XColor.white
        ),
        child: Column(
          children: [
            const HeadLogoWidget(),
            const HomeUserInfoWidget(),
            XBox.vertical5,
            for (var item in _fixed)
              SideItemWidget(
                item: item,
                onChoose: _isChooseItem,
                onPressed: _chooseHandler,
              ),
            XBox.vertical10,
            SideFolderWidget(
              name: "Folders",
              onPressed: () {

              },
            ),
            Expanded(
              child: _buildFolderList()
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildFolderList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return SideItemWidget(
          item: _folders[index],
          onChoose: _isChooseItem,
          onPressed: _chooseHandler,
        );
      },
      itemCount: _folders.length,
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
  final EdgeInsetsGeometry? padding;

  const SideItemWidget({
    Key? key,
    required this.item,
    required this.onChoose,
    this.onPressed,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final choose = onChoose(item);

    return Padding(
      padding: padding?? const EdgeInsets.only(left: 10, top: 5, right: 10),
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
            enableFeedback: false,
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
  final VoidCallback? onPressed;

  const SideFolderWidget({
    Key? key,
    required this.name,
    this.onPressed
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
                color: Color(0xFF97B9E8),
                fontWeight: FontWeight.normal
              ),
            )
          ),
          IconButton(
            onPressed: onPressed,
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

