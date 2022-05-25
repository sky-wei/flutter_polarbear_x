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
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/model/side_item.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/sub_title_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../data/item/sort_item.dart';
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

  SortType get sortType => _appModel.sortType;

  bool get _isEdit => accountState == AccountState.edit;

  bool get _isView => accountState == AccountState.view;

  bool get _visibilityNote => _isEdit || _rawAccountItem.node.isNotEmpty;

  bool get _visibilityUrl => _isEdit || _rawAccountItem.url.isNotEmpty;

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

  /// 创建新账号
  void createAccount() {
    _setContent(AccountState.edit, _appModel.newEmptyAccount());
  }

  /// 清除账号
  void _clearAccount() {
    _setContent(AccountState.none, AccountItem.empty);
  }

  /// 是否修改了账号
  bool isModifyAccount() {
    return _isEdit && !_rawAccountItem.unanimous(_editAccountItem);
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
      _websiteController.text = item.url;
      _notesController.text = item.node;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(accountState) {
      case AccountState.view:
      case AccountState.edit:
        return _buildViewContent();
      case AccountState.none:
        return _buildEmptyWidget();
    }
  }

  Widget _buildViewContent() {

    final itemTitle = (_isEdit ? S.of(context).editItem : S.of(context).itemInformation).toUpperCase();

    return SubFrameWidget(
      children: [
        SubListWidget(
          title: itemTitle,
          children: [
            SubTextWidget(
              controller: _nameController,
              title: S.of(context).name,
              autofocus: true,
              readOnly: !_isEdit,
            ),
            const SubItemLine(),
            SubTextWidget(
              controller: _userNameController,
              title: S.of(context).userName,
              readOnly: !_isEdit,
              actions: [_copyAction],
              onAction: (action) => _handlerActionEvent(
                action: action,
                value: _userNameController.text
              ),
            ),
            const SubItemLine(),
            SubTextWidget(
              controller: _passwordController,
              title: S.of(context).password,
              readOnly: !_isEdit,
              obscureText: !_visibilityPassword,
              actions: [_visibilityPassword ? _invisibleAction : _visibilityAction, _copyAction],
              onAction: (action) => _handlerActionEvent(
                action: action,
                value: _passwordController.text
              ),
            ),
          ],
        ),
        if (_isEdit) XBox.vertical30,
        if (_isEdit)
          SubListWidget(
            // title: 'OPTIONS',
            children: [
              SubDropdownWidget(
                title: S.of(context).folder,
                value: _appModel.findFolderBy(_editAccountItem),
                items: _appModel.folders,
                onChanged: (value) {
                  setState(() {
                    _editAccountItem.folderId = value.id;
                  });
                },
              ),
              const SubItemLine(),
              SubCheckBoxWidget(
                title: S.of(context).favorite,
                value: _editAccountItem.favorite,
                onChanged: (value) {
                  setState(() {
                    _editAccountItem.favorite = value;
                  });
                },
              ),
            ],
          ),
        if (_visibilityUrl) XBox.vertical30,
        if (_visibilityUrl)
          SubListWidget(
            title: S.of(context).url.toUpperCase(),
            children: [
              SubTextWidget(
                controller: _websiteController,
                hintText: 'ex. https://www.xxxxxx.com',
                readOnly: !_isEdit,
                actions: [_launcherAction, _copyAction],
                onAction: (action) => _handlerActionEvent(
                  action: action,
                  value: _websiteController.text
                ),
              ),
            ],
          ),
        if (_visibilityNote) XBox.vertical30,
        if (_visibilityNote)
          SubListWidget(
            title: S.of(context).notes.toUpperCase(),
            children: [
              SubTextWidget(
                controller: _notesController,
                hintText: S.of(context).sayWhat,
                readOnly: !_isEdit,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
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

  /// 空内容
  Widget _buildEmptyWidget() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image/ic_head_logo.png',
            width: 65,
            color: XColor.gray2Color,
          ),
          XBox.horizontal10,
          const DefaultTextStyle(
            style: TextStyle(
              color: XColor.gray2Color,
              fontSize: 28,
              // fontWeight: FontWeight.w400
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Password'),
                  TextSpan(
                      text: 'X',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                  )
                ]
              )
            )
          )
        ],
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
        if (_editAccountItem.id == 0) {
          _clearAccount();    // 清除账号信息
        } else {
          _setContent(AccountState.view, _rawAccountItem);
        }
        break;
      case MenuType.save: // 保存账号信息
        _saveAccount();
        break;
      case MenuType.restore:
        break;
    }
  }

  /// 保存账号
  void _saveAccount() {

    final name = _nameController.text;
    final userName = _userNameController.text;
    final password = _passwordController.text;
    final website = _websiteController.text;
    final notes = _notesController.text;

    if (name.isEmpty) {
      MessageUtil.showMessage(context, S.of(context).xCanNotEmpty(S.of(context).name));
      return;
    }

    if (userName.isEmpty) {
      MessageUtil.showMessage(context, S.of(context).xCanNotEmpty(S.of(context).userName));
      return;
    }

    if (password.isEmpty) {
      MessageUtil.showMessage(context, S.of(context).xCanNotEmpty(S.of(context).password));
      return;
    }

    _editAccountItem.alias = name;
    _editAccountItem.name = userName;
    _editAccountItem.password = password;

    _editAccountItem.url = website;
    _editAccountItem.node = notes;

    if (_editAccountItem.id == 0) {
      _createAccount(_editAccountItem);
    } else {
      _updateAccount(_editAccountItem);
    }
  }

  /// 创建账号
  Future<void> _createAccount(AccountItem item) async {

    _appModel.createAccount(item).then((value) {

    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 更新账号
  Future<void> _updateAccount(AccountItem item) async {

    _appModel.updateAccount(item).then((value) {

    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
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

    if (SortType.trash == sortType) {
      return _buildMenuItem([MenuType.restore, MenuType.delete]);
    }

    switch(accountState) {
      case AccountState.view:
        return _buildMenuItem([MenuType.edit, MenuType.copy, MenuType.delete]);
      case AccountState.edit:
        return _buildMenuItem(
          [MenuType.save, MenuType.recall, if (_editAccountItem.id != 0) MenuType.delete]
        );
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
            child: ListView(
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
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 15),
            child: Column(
              children: children,
            ),
          )
        )
      ],
    );
  }
}

class SubCheckBoxWidget extends StatelessWidget {

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SubCheckBoxWidget({
    Key? key,
    required this.title,
    this.value = false,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16)
            ),
          ),
          Checkbox(
            value: value,
            onChanged: (value) {
              if (onChanged != null) onChanged!(value?? false);
            },
          )
        ],
      ),
    );
  }
}

class SubDropdownWidget extends StatelessWidget {

  final String title;
  final FolderItem value;
  final List<FolderItem> items;
  final ValueChanged<FolderItem>? onChanged;

  const SubDropdownWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.items,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16)
            ),
          ),
          DropdownButton<FolderItem>(
            value: value,
            underline: const SizedBox(),
            items: _buildMenuItem(items),
            onChanged: (value) {
              if (onChanged != null) onChanged!(value!);
            },
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<FolderItem>> _buildMenuItem(List<FolderItem> items) {
    return items.map<DropdownMenuItem<FolderItem>>((FolderItem value) {
      return DropdownMenuItem<FolderItem> (
        value: value,
        child: Text(value.name),
      );
    }).toList();
  }
}

class SubTextWidget extends StatelessWidget {

  final String? title;
  final TextEditingController? controller;
  final bool autofocus;
  final int maxLines;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<ActionItem>? onAction;
  final bool readOnly;
  final bool obscureText;
  final List<ActionItem> actions;

  const SubTextWidget({
    Key? key,
    this.title,
    this.controller,
    this.autofocus = false,
    this.maxLines = 1,
    this.hintText,
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
                constraints: BoxConstraints(
                  maxHeight: maxLines == 1 ? 32 : 130,
                ),
                child: TextField(
                  controller: controller,
                  autofocus: autofocus,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                  maxLines: maxLines,
                  textInputAction: textInputAction,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  obscureText: obscureText,
                ),
              ),
            ),
            actions.isEmpty ? XBox.horizontal15 : XBox.horizontal60,
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
            if (actions.isNotEmpty) XBox.horizontal10,
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
