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

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/model/side_item.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/util/log_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/sub_title_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dialog/hint_dialog.dart';
import '../../generated/l10n.dart';
import '../../model/app_model.dart';
import '../../util/error_util.dart';
import '../../util/launch_util.dart';
import '../../util/message_util.dart';

enum AccountState {
  view,
  edit,
  none
}

class HomeContent extends StatefulWidget {

  static final GlobalKey _globalKey = GlobalKey();

  static HomeContentState of(BuildContext context) {
    return _globalKey.currentState! as HomeContentState;
  }

  HomeContent({Key? key}) : super(key: _globalKey);

  @override
  State<StatefulWidget> createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {

  final DateFormat _dateFormat = DateFormat.yMMMMd()..add_Hm();
  
  final Map<MenuType, MenuItem> _menus = {
    MenuType.edit: MenuItem(icon: 'assets/svg/ic_edit.svg', name: S.current.edit, type: MenuType.edit),
    MenuType.copy: MenuItem(icon: 'assets/svg/ic_copy.svg', name: S.current.copy, type: MenuType.copy),
    MenuType.delete: MenuItem(icon: 'assets/svg/ic_delete.svg', name: S.current.delete, type: MenuType.delete, color: XColor.deleteColor),
    MenuType.recall: MenuItem(icon: 'assets/svg/ic_recall.svg', name: S.current.recall, type: MenuType.recall),
    MenuType.save: MenuItem(icon: 'assets/svg/ic_save.svg', name: S.current.save, type: MenuType.save, color: XColor.themeColor),
    MenuType.restore: MenuItem(icon: 'assets/svg/ic_restore.svg', name: S.current.restore, type: MenuType.restore),
  };

  final ActionItem _copyAction = ActionItem(icon: 'assets/svg/ic_copy.svg', name: S.current.copyValue);
  final ActionItem _visibilityAction = ActionItem(icon: 'assets/svg/ic_visibility.svg', name: S.current.toggleVisibility);
  final ActionItem _invisibleAction = ActionItem(icon: 'assets/svg/ic_invisible.svg', name: S.current.toggleInvisible);
  final ActionItem _launcherAction = ActionItem(icon: 'assets/svg/ic_launcher.svg', name: S.current.launcher);

  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;

  bool _visibilityPassword = false;

  late AppModel _appModel;

  AccountState _accountState = AccountState.none;
  AccountItem _rawAccountItem = AccountItem.empty;
  AccountItem _editAccountItem = AccountItem.empty;

  AccountState get accountState => _accountState;

  SideType get sideType => _appModel.sideType;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _websiteController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
  }

  /// 显示账号
  void viewAccount(AccountItem item) {
    _setContent(AccountState.view, item);
  }

  /// 显示账号
  void editAccount(AccountItem item) {
    _setContent(AccountState.edit, item);
  }

  /// 清除账号
  void clearAccount(AccountItem item) {
    _setContent(AccountState.none, AccountItem.empty);
  }

  /// 设置信息
  void _setContent(AccountState state, AccountItem item) {
    setState(() {
      _accountState = state;
      _rawAccountItem = item;
      _editAccountItem = item.copy();

      _visibilityPassword = false;
      _nameController.text = item.alias;
      _userNameController.text = item.name;
      _passwordController.text = item.password;
      _websiteController.text = 'https://www.baidu.com';
      _notesController.text = 'https://www.baidu.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(accountState) {
      case AccountState.view:
        return _buildViewContent();
      case AccountState.edit:
        return _buildEditContent();
      case AccountState.none:
        return const Center();
    }
  }

  Widget _buildViewContent() {
    return SubFrameWidget(
      children: [
        SubListWidget(
          title: 'ITEM INFORMATION',
          children: [
            SubItemWidget(
              controller: _nameController,
              title: S.of(context).name,
            ),
            const SubItemLine(),
            SubItemWidget(
              controller: _userNameController,
              title: S.of(context).userName,
              actions: [_copyAction],
              onAction: (action) => _handlerActionEvent(
                action: action,
                value: _userNameController.text
              ),
            ),
            const SubItemLine(),
            SubItemWidget(
              controller: _passwordController,
              title: S.of(context).password,
              obscureText: !_visibilityPassword,
              actions: [_visibilityPassword ? _invisibleAction : _visibilityAction, _copyAction],
              onAction: (action) => _handlerActionEvent(
                  action: action,
                  value: _passwordController.text
              ),
            ),
          ],
        ),
        XBox.vertical30,
        SubListWidget(
          title: 'URL',
          children: [
            SubItemWidget(
              controller: _websiteController,
              // title: 'Website',
              actions: [_launcherAction, _copyAction],
              onAction: (action) => _handlerActionEvent(
                  action: action,
                  value: _websiteController.text
              ),
            ),
          ],
        ),
        XBox.vertical30,
        SubListWidget(
          title: 'NOTES',
          children: [
            SubItemWidget(
              controller: _notesController,
            ),
          ],
        ),
        // XBox.vertical40,
        // SubTitleWidget(
        //   title: 'Update: ${_dateFormat.format(_editAccountItem.updateDateTime)}',
        // )
      ],
      menu: _buildMenuList(_buildMenuItems()),
    );
  }

  Widget _buildEditContent() {
    return SubFrameWidget(
      children: [
        SubListWidget(
          title: 'EDIT ITEM',
          children: [
            SubItemWidget(
              controller: _nameController,
              title: 'Name',
              readOnly: false,
              autofocus: true,
            ),
            const SubItemLine(),
            SubItemWidget(
              controller: _userNameController,
              title: 'UserName',
              readOnly: false,
            ),
            const SubItemLine(),
            SubItemWidget(
              controller: _passwordController,
              title: 'Password',
              readOnly: false,
              obscureText: true,
            ),
          ],
        ),
        XBox.vertical30,
        SubListWidget(
          title: 'ITEM INFORMATION',
          children: [
            SubItemWidget(
              controller: _nameController,
              title: 'Name',
              readOnly: false,
            ),
          ],
        )
      ],
      menu: _buildMenuList(_buildMenuItems()),
    );
  }

  /// 生成菜单列表
  Widget _buildMenuList(List<MenuItem> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Material(
        color: XColor.white,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var item in items)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: IconButton(
                    onPressed: () { _handlerMenuEvent(item); },
                    tooltip: item.name,
                    icon: SvgPicture.asset(
                      item.icon,
                      color: item.color,
                      width: 20
                    )
                  ),
                ),
              XBox.vertical10
            ],
          ),
        ),
      ),
    );
  }

  /// 处理动作事件
  void _handlerActionEvent({
    required ActionItem action, required String value
  }) {

    if (action == _copyAction) {
      // 复制内容
      _copyToClipboard(value);
    } else if (action == _visibilityAction) {
      setState(() {
        _visibilityPassword = true;
      });
    } else if (action == _invisibleAction) {
      setState(() {
        _visibilityPassword = false;
      });
    } else if (action == _launcherAction) {
      // 打开浏览器
      LaunchUtil.launchUrl(value);
    }
  }

  /// 处理菜单事件
  void _handlerMenuEvent(MenuItem item) {
    switch(item.type) {
      case MenuType.edit:
        _setContent(AccountState.edit, _rawAccountItem);
        break;
      case MenuType.copy:
        break;
      case MenuType.delete:
        _deleteAccount(_rawAccountItem);
        break;
      case MenuType.recall:
        _setContent(AccountState.view, _rawAccountItem);
        break;
      case MenuType.save:
        break;
      case MenuType.restore:
        break;
    }
  }

  /// 删除账号
  Future<void> _deleteAccount(AccountItem item) async {

    final result = await showDialog<int>(
        context: context,
        builder: (context) {
          return HintDialog(
            title: S.of(context).deleteAccount,
            message: S.of(context).deleteAccountMessage,
          );
        }
    );

    if (result == 1) {
      _appModel.deleteAccount(item).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
    }
  }

  /// 创建MenuItem
  List<MenuItem> _buildMenuItems() {

    if (SideType.trash == sideType) {
      return _buildMenuItem([MenuType.restore, MenuType.delete]);
    }

    switch(accountState) {
      case AccountState.view:
        return _buildMenuItem([MenuType.edit, MenuType.copy, MenuType.delete]);
      case AccountState.edit:
        return _buildMenuItem([MenuType.save, MenuType.recall, MenuType.delete]);
      case AccountState.none:
        return [];
    }
  }

  /// 创建MenuItem
  List<MenuItem> _buildMenuItem(List<MenuType> types) {

    List<MenuItem> items = [];

    for (var type in types) {
      items.add(_menus[type]!);
    }

    return items;
  }

  /// 复制到粘贴板
  void _copyToClipboard(String value) {
    Clipboard.setData(
        ClipboardData(text:value)
    ).then((value) {
      MessageUtil.showMessage(context, S.of(context).copyToClipboard);
    });
  }
}

class SubFrameWidget extends StatelessWidget {

  final List<Widget> children;
  final Widget menu;

  const SubFrameWidget({
    Key? key,
    required this.children,
    required this.menu
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 40, top: appWindow.titleBarHeight + 40, right: 40, bottom: 20
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
            ),
          ),
          XBox.horizontal20,
          menu
        ],
      ),
    );
  }
}

class SubListWidget extends StatelessWidget {
  
  final String? title;
  final List<Widget> children;

  const SubListWidget({
    Key? key,
    this.title,
    this.children = const <Widget>[]
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) SubTitleWidget(title: title!),
        if (title != null) XBox.vertical10,
        Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
            child: Column(
              children: children,
            ),
          )
        )
      ],
    );
  }
}

class SubItemWidget extends StatelessWidget {

  final String? title;
  final TextEditingController? controller;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<ActionItem>? onAction;
  final bool readOnly;
  final bool obscureText;
  final List<ActionItem> actions;

  const SubItemWidget({
    Key? key,
    this.title,
    this.controller,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.readOnly = true,
    this.obscureText = false,
    this.actions = const <ActionItem>[],
    this.onAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) XBox.vertical5,
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
                color: XColor.grayColor
            ),
          ),
        XBox.vertical5,
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 32,
                ),
                child: TextField(
                  controller: controller,
                  autofocus: autofocus,
                  decoration: const InputDecoration(
                    border: InputBorder.none
                  ),
                  maxLines: 1,
                  textInputAction: textInputAction,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  obscureText: obscureText,
                ),
              ),
            ),
            actions.isEmpty ? XBox.horizontal20 : XBox.horizontal60,
            for (var action in actions)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  onPressed: () { if (onAction != null) onAction!(action); },
                  tooltip: action.name,
                  icon: SvgPicture.asset(
                    action.icon,
                    color: XColor.black,
                    width: 20
                  )
                ),
              ),
            XBox.horizontal10,
          ],
        ),
      ],
    );
  }
}

class SubItemLine extends StatelessWidget {

  const SubItemLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 24,
      thickness: 1,
    );
  }
}

enum MenuType {
  edit,
  copy,
  delete,
  recall,
  save,
  restore
}

class MenuItem {

  final String icon;
  final String name;
  final MenuType type;
  final Color color;

  MenuItem({
    required this.icon,
    required this.name, 
    required this.type,
    this.color = XColor.black
  });
}

class ActionItem {

  final String icon;
  final String name;

  ActionItem({
    required this.icon,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionItem &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          name == other.name;

  @override
  int get hashCode => icon.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'ActionItem{icon: $icon, name: $name}';
  }
}
