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
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/dialog/input_dialog.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/mobile/page/home/account/account_list_page.dart';
import 'package:flutter_polarbear_x/mobile/page/home/account/edit_account_page.dart';
import 'package:flutter_polarbear_x/mobile/page/home/folder_page.dart';
import 'package:flutter_polarbear_x/mobile/page/setting/setting_page.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/route/mobile_page_route.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final PageController _pageController = PageController();
  final GlobalKey<MainAppBarState> _appbarKey = GlobalKey();
  final GlobalKey<AccountListState> _searchKey = GlobalKey();
  final GlobalKey<MainBottomNavigationBarState> _navigationBarKey = GlobalKey();

  DateTime? _lastPressTime;
  late AppMobileModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppMobileModel>();
    _appModel.lockManager.addListener(_lockChange);
    _appModel.loadFolders();
    _appModel.loadAllAccount();
  }

  @override
  void dispose() {
    _appModel.lockManager.removeListener(_lockChange);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: MainAppBar(
          key: _appbarKey,
          onBackHome: () => _setCurrentIndex(0),
          onSearch: (keyword) => _searchKey.currentState?.search(keyword),
        ),
        drawer: const MainSideWidget(),
        body: _buildPageView(),
        bottomNavigationBar: MainBottomNavigationBar(
          key: _navigationBarKey,
          onTap: _setCurrentIndex
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      onWillPop: _onWillPop,
    );
  }

  /// 创建 PageView
  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const AccountListPage(
            pageState: false,
            sortType: SortType.allItems
        ),
        const FolderPage(),
        const AccountListPage(
            pageState: false,
            sortType: SortType.favorite
        ),
        AccountListPage(
            key: _searchKey,
            openSearch: true,
            pageState: false,
            sortType: SortType.allItems
        ),
      ],
    );
  }

  /// 返回事件处理
  Future<bool> _onWillPop() {

    if (_lastPressTime == null ||
        DateTime.now().difference(_lastPressTime!) > const Duration(seconds: 3)
    ) {
      _lastPressTime = DateTime.now();
      MessageUtil.showMessage(context, S.of(context).exitTips);
      return Future.value(false);
    }
    return Future.value(true);
  }

  /// 切换界面
  void _setCurrentIndex(int index) {
    _pageController.jumpToPage(index);
    _appbarKey.currentState?.setCurrentIndex(index);
    _navigationBarKey.currentState?.setCurrentIndex(index);
  }

  /// 锁屏修改
  Future<void> _lockChange() async {
    if (_appModel.lockManager.value) {
      Navigator.pushNamed(context, XRoute.lock);
    }
  }
}


class MainAppBar extends StatefulWidget implements PreferredSizeWidget {

  final int initIndex;
  final VoidCallback onBackHome;
  final ValueChanged<String> onSearch;

  @override
  final Size preferredSize;

  MainAppBar({
    Key? key,
    this.initIndex = 0,
    required this.onSearch,
    required this.onBackHome,
  }) : preferredSize = _PreferredAppBarSize(null, null),
       super(key: key);

  @override
  State<StatefulWidget> createState() => MainAppBarState();
}

class MainAppBarState extends State<MainAppBar> {

  final TextEditingController _searchController = TextEditingController();

  int _currentIndex = 0;
  late AppMobileModel _appModel;

  @override
  void initState() {
    _currentIndex = widget.initIndex;
    _appModel = context.read<AppMobileModel>();
    _searchController.addListener(_searchAccount);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchAccount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentIndex != 3 ? _buildMainAppBar() : _buildSearchAppBar();
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// 创建主AppBar
  AppBar _buildMainAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_menu.svg',
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        ActionMenuWidget(
          iconName: 'ic_add.svg',
          onPressed: _handlerAdd,
        )
      ],
      title: Text(S.of(context).appName),
      titleTextStyle: TextStyle(
          color: Theme.of(context).mainTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 创建搜索AppBar
  AppBar _buildSearchAppBar() {
    return AppBar(
      leading: const ActionMenuWidget(
          iconName: 'ic_search.svg'
      ),
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            hintText: S.of(context).search,
            border: InputBorder.none
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: _cancelSearch,
            child: Text(S.of(context).cancel)
        )
      ],
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 处理添加事件
  void _handlerAdd() {
    switch(_currentIndex) {
      case 0:
        _newAccount(
            AccountItem.formAdmin(
              _appModel.admin.id
            )
        );
        break;
      case 1:
        _newFolder();
        break;
      case 2:
        _newAccount(
            AccountItem.formAdmin(
                _appModel.admin.id
            )..favorite = true
        );
        break;
    }
  }

  /// 取消搜索
  void _cancelSearch() {
    _searchController.clear();
    widget.onBackHome();
  }

  /// 搜索账号
  void _searchAccount() {
    widget.onSearch(_searchController.text);
  }

  /// 创建账号
  Future<void> _newAccount(AccountItem account) async {
    Navigator.push<AccountItem>(
        context,
        MobilePageRoute(child: EditAccountPage(account: account))
    );
  }

  /// 创建文件夹
  Future<void> _newFolder() async {

    final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return InputDialog(
            title: S.of(context).editFolder,
            labelText: S.of(context).name,
            value: '',
          );
        }
    );

    if (result == null) {
      return;
    }

    if (result.isEmpty) {
      MessageUtil.showMessage(context, S.of(context).canNotEmpty);
      return;
    }

    // 创建文件夹
    _appModel.createFolder(result).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }
}


class MainSideWidget extends StatefulWidget {

  const MainSideWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainSideWidgetState();
}

class MainSideWidgetState extends State<MainSideWidget> {

  late AppMobileModel _appModel;

  @override
  void initState() {
    _appModel = context.read<AppMobileModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDrawerHeader(),
                  )
                ],
              ),
              _buildListTile(
                  iconName: 'ic_home.svg',
                  title: S.of(context).home,
                  onTap: () => Scaffold.of(context).closeDrawer(),
                  selected: true
              ),
              _buildListTile(
                  iconName: 'ic_settings.svg',
                  title: S.of(context).settings,
                  onTap: _openSetting
              ),
              _buildListTile(
                  iconName: 'ic_trash.svg',
                  title: S.of(context).trash,
                  onTap: _openTrash
              ),
              const Divider(),
              _buildListTile(
                  iconName: 'ic_lock.svg',
                  title: S.of(context).lock,
                  onTap: _lockApp
              ),
              _buildListTile(
                  iconName: 'ic_exit.svg',
                  title: S.of(context).logout,
                  onTap: _logoutApp
              ),
            ]
        ),
      ),
    );
  }

  /// 创建 DrawerHeader
  DrawerHeader _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/ic_head_background.jpeg'),
              fit: BoxFit.cover
          )
      ),
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
                color: Theme.of(context).settingsColor
            ),
          )
        ],
      ),
    );
  }

  /// 创建 ListTile
  ListTile _buildListTile({
    required String iconName,
    Color? iconColor,
    required String title,
    Color? titleColor,
    GestureTapCallback? onTap,
    bool selected = false
  }) {
    return ListTile(
      leading: SvgPicture.asset(
        'assets/svg/$iconName',
        width: 22,
        color: iconColor ?? (selected ? Theme.of(context).themeColor : Theme.of(context).iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: titleColor ?? (selected ? Theme.of(context).themeColor : Theme.of(context).mainTextColor)
        ),
      ),
      onTap: onTap,
      selected: selected,
    );
  }

  /// 打开设置
  void _openSetting() {
    Scaffold.of(context).closeDrawer();
    Navigator.push(context, MobilePageRoute(child: const SettingPage()));
  }

  /// 打开回收箱
  void _openTrash() {
    Scaffold.of(context).closeDrawer();
    Navigator.push(
        context,
        MobilePageRoute(
            child: const AccountListPage(sortType: SortType.trash)
        )
    );
  }

  /// 锁定应用
  void _lockApp() {
    Scaffold.of(context).closeDrawer();
    _appModel.lockNotice();
  }

  /// 退出应用(回到登录界面)
  void _logoutApp() {
    Scaffold.of(context).closeDrawer();
    _appModel.restartApp(context);
  }
}


class MainBottomNavigationBar extends StatefulWidget {

  final int initIndex;
  final ValueChanged<int> onTap;

  const MainBottomNavigationBar({
    Key? key,
    this.initIndex = 0,
    required this.onTap
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainBottomNavigationBarState();
}

class MainBottomNavigationBarState extends State<MainBottomNavigationBar> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initIndex;
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      onTap: widget.onTap,
      currentIndex: _currentIndex,
    );
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
          width: 21,
          color: select ? Theme.of(context).themeColor : Theme.of(context).iconColor,
        ),
        label: label
    );
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

