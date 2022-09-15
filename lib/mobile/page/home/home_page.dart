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
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/mobile/page/home/account_page.dart';
import 'package:flutter_polarbear_x/mobile/page/home/favorite_page.dart';
import 'package:flutter_polarbear_x/mobile/page/home/folder_page.dart';
import 'package:flutter_polarbear_x/mobile/page/home/search_page.dart';
import 'package:flutter_polarbear_x/mobile/page/setting/setting_page.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../model/app_model.dart';
import '../../../route/mobile_page_route.dart';
import '../../../widget/action_menu_widget.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  late AppModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
    // _appModel.addListener(_infoChange);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    // _appModel.removeListener(_infoChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(_currentIndex),
      drawer: _buildDrawer(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          AccountPage(),
          FolderPage(),
          FavoritePage(),
          SearchPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  AppBar _buildAppBar(int index) {

    if (index != 3) {
      return AppBar(
        leading: Builder(builder: (context) {
          return ActionMenuWidget(
            iconName: 'ic_menu.svg',
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: _buildActionMenu(_currentIndex),
        title: Text(S.of(context).appName),
        titleTextStyle: TextStyle(
          color: Theme.of(context).mainTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w500
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
      );
    }

    return AppBar(
      leading: const ActionMenuWidget(
        iconName: 'ic_search.svg'
      ),
      title: TextField(
        decoration: InputDecoration(
          hintText: S.of(context).search,
          border: InputBorder.none
        ),
        autofocus: true,
      ),
      actions: _buildActionMenu(_currentIndex),
      elevation: 0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    );
  }

  /// 创建 ActionMenu
  List<Widget>? _buildActionMenu(int index) {
    if (index == 0 || index == 1) {
      return [
        ActionMenuWidget(
          iconName: 'ic_add.svg',
          onPressed: () { },
        )
      ];
    } else if (index == 3) {
      return [
        TextButton(
          onPressed: () => _setCurrentIndex(0),
          child: Text(
            S.of(context).cancel
          )
        )
      ];
    }
    return null;
  }

  /// 创建 Drawer
  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          _buildDrawerHeader(),
          Builder(builder: (context) {
            return _buildListTile(
              iconName: 'ic_home.svg',
              title: S.of(context).home,
              onTap: () => Scaffold.of(context).closeDrawer(),
              selected: true
            );
          }),
          Builder(builder: (context) {
            return _buildListTile(
              iconName: 'ic_settings.svg',
              title: S.of(context).settings,
              onTap: () => _openSetting(context)
            );
          }),
        ],
      ),
    );
  }

  /// 打开设置
  void _openSetting(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    Navigator.push(context, MobilePageRoute(child: const SettingPage()));
  }

  /// 创建 DrawerHeader
  DrawerHeader _buildDrawerHeader() {
    return DrawerHeader(
      child: Column(
        children: [
          XBox.vertical20,
          ClipOval(
            child: Image.asset(
              'assets/image/ic_user_head.jpg',
              width: 56
            ),
          ),
          XBox.vertical10,
          Text(
            _appModel.admin.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).mainTextColor
            ),
          )
        ],
      ),
    );
  }

  /// 创建 ListTile
  ListTile _buildListTile({
    required String iconName,
    required String title,
    GestureTapCallback? onTap,
    bool selected = false
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        'assets/svg/$iconName',
        width: 22,
        color: selected ? Theme.of(context).themeColor : Theme.of(context).iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Theme.of(context).themeColor : Theme.of(context).mainTextColor
        ),
      ),
      onTap: onTap,
      selected: selected,
    );
  }

  /// 创建 BottomNavigationBar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        _buildNavigationBarItem(
            iconName: 'ic_home.svg',
            label: S.of(context).home,
            select: _currentIndex == 0
        ),
        _buildNavigationBarItem(
            iconName: 'ic_folder.svg',
            label: S.of(context).folder,
            select: _currentIndex == 1
        ),
        _buildNavigationBarItem(
            iconName: 'ic_favorites.svg',
            label: S.of(context).favorite,
            select: _currentIndex == 2
        ),
        _buildNavigationBarItem(
            iconName: 'ic_search.svg',
            label: S.of(context).search,
            select: _currentIndex == 3
        )
      ],
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedItemColor: Theme.of(context).themeColor,
      unselectedItemColor: Theme.of(context).mainTextColor,
      onTap: (index) => _setCurrentIndex(index),
      currentIndex: _currentIndex,
    );
  }

  /// 切换界面
  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  /// 创建 BottomNavigationBarItem
  BottomNavigationBarItem _buildNavigationBarItem({
    required String iconName,
    required String label,
    required bool select
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        'assets/svg/$iconName',
        width: 22,
        height: 22,
        color: select ? Theme.of(context).themeColor : Theme.of(context).iconColor,
      ),
      label: label,
    );
  }
}

