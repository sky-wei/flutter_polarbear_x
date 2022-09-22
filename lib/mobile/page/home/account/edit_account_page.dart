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
import 'package:flutter_polarbear_x/data/item/action_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/dialog/choose_dialog.dart';
import 'package:flutter_polarbear_x/mobile/dialog/hint_dialog.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/launch_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_checkbox_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_dropdown_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_item_line.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_text_widget.dart';
import 'package:provider/provider.dart';


class EditAccountPage extends StatefulWidget {

  final bool editState;
  final AccountItem account;

  const EditAccountPage({
    Key? key,
    this.editState = true,
    required this.account
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {

  final ActionItem _copyAction = ActionItem(icon: 'assets/svg/ic_copy.svg', name: S.current.copyValue);
  final ActionItem _visibilityAction = ActionItem(icon: 'assets/svg/ic_visibility.svg', name: S.current.toggleVisibility);
  final ActionItem _invisibleAction = ActionItem(icon: 'assets/svg/ic_invisible.svg', name: S.current.toggleInvisible);
  final ActionItem _launcherAction = ActionItem(icon: 'assets/svg/ic_launcher.svg', name: S.current.launcher);

  bool _editState = true;
  bool _visibilityPassword = false;
  late AppMobileModel _appModel;
  late AccountItem _rawAccount;
  late AccountItem _editAccount;

  bool get _visibilityNote => _editState || _editAccount.node.isNotEmpty;
  bool get _visibilityUrl => _editState || _editAccount.url.isNotEmpty;
  bool get _isNewAccount => _editAccount.id <= 0;

  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _folderFocus = FocusNode();
  final FocusNode _favoriteFocus = FocusNode();
  final FocusNode _websiteFocus = FocusNode();
  final FocusNode _notesFocus = FocusNode();

  @override
  void initState() {
    _appModel = context.read<AppMobileModel>();
    _editState = widget.editState;
    _rawAccount = widget.account;
    _editAccount = _rawAccount.copy();

    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _websiteController = TextEditingController();
    _notesController = TextEditingController();
    _resetAccountInfo();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBodyContent(),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      onWillPop: _onBack,
    );
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: _handlerBack,
      ),
      title: Text(S.of(context).account),
      titleTextStyle: TextStyle(
          color: Theme.of(context).mainTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      actions: _buildActions(),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    );
  }

  /// 创建菜单
  List<Widget> _buildActions() {
    if (_editAccount.trash) {
      return [
        ActionMenuWidget(
          iconName: 'ic_restore.svg',
          tooltip: S.of(context).restore,
          onPressed: _restoreAccount,
        ),
        ActionMenuWidget(
          iconName: 'ic_trash.svg',
          iconColor: Theme.of(context).deleteColor,
          tooltip: S.of(context).delete,
          onPressed: _deleteAccount,
        )
      ];
    }
    if (_editState) {
      return [
        ActionMenuWidget(
          iconName: 'ic_save.svg',
          tooltip: S.of(context).save,
          onPressed: _saveAccount,
        )
      ];
    }
    return [
      ActionMenuWidget(
        iconName: 'ic_edit.svg',
        tooltip: S.of(context).edit,
        onPressed: () => _editAccountBy(_rawAccount),
      ),
      ActionMenuWidget(
        iconName: 'ic_more.svg',
        onPressed: _moreMenu,
      )
    ];
  }

  /// 创建界面内容
  Widget _buildBodyContent() {

    final itemTitle = (_editState ? S.of(context).editItem : S.of(context).itemInformation).toUpperCase();

    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      children: [
        SubListWidget(
          title: itemTitle,
          padding: const EdgeInsets.only(left: 20),
          children: [
            SubTextWidget(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              controller: _nameController,
              focusNode: _nameFocus,
              title: S.of(context).name,
              autofocus: true,
              readOnly: !_editState,
              onEditingComplete: () => _userNameFocus.requestFocus(),
              onChanged: (value) => _editAccount.alias = value,
            ),
            const SubItemLine(),
            SubTextWidget(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              controller: _userNameController,
              focusNode: _userNameFocus,
              title: S.of(context).userName,
              readOnly: !_editState,
              onEditingComplete: () => _passwordFocus.requestFocus(),
              onChanged: (value) => _editAccount.name = value,
              actions: [_copyAction],
              onAction: (action) => _handlerActionEvent(
                  action: action,
                  value: _userNameController.text
              ),
            ),
            const SubItemLine(),
            SubTextWidget(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              controller: _passwordController,
              focusNode: _passwordFocus,
              title: S.of(context).password,
              readOnly: !_editState,
              obscureText: !_visibilityPassword,
              onEditingComplete: () => _websiteFocus.requestFocus(),
              onChanged: (value) => _editAccount.password = value,
              actions: [_visibilityPassword ? _invisibleAction : _visibilityAction, _copyAction],
              onAction: (action) => _handlerActionEvent(
                  action: action,
                  value: _passwordController.text
              ),
            ),
          ],
        ),
        if (_editState) XBox.vertical30,
        if (_editState)
          SubListWidget(
            // title: 'OPTIONS',
            padding: const EdgeInsets.only(left: 20),
            children: [
              SubDropdownWidget(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                title: S.of(context).folder,
                value: _appModel.findFolderBy(_editAccount),
                items: _appModel.folders,
                focusNode: _folderFocus,
                onChanged: (value) {
                  setState(() {
                    _editAccount.folderId = value.id;
                  });
                },
              ),
              const SubItemLine(),
              SubCheckBoxWidget(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                title: S.of(context).favorite,
                value: _editAccount.favorite,
                focusNode: _favoriteFocus,
                onChanged: (value) {
                  setState(() {
                    _editAccount.favorite = value;
                  });
                },
              ),
            ],
          ),
        if (_visibilityUrl) XBox.vertical30,
        if (_visibilityUrl)
          SubListWidget(
            title: S.of(context).url.toUpperCase(),
            padding: const EdgeInsets.only(left: 20),
            children: [
              SubTextWidget(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                controller: _websiteController,
                focusNode: _websiteFocus,
                hintText: S.of(context).urlEx,
                readOnly: !_editState,
                onEditingComplete: () => _notesFocus.requestFocus(),
                onChanged: (value) => _editAccount.url = value,
                actions: [_launcherAction, _copyAction],
                onAction: (action) => _handlerActionEvent(
                    action: action,
                    value: _editAccount.url
                ),
              ),
            ],
          ),
        if (_visibilityNote) XBox.vertical30,
        if (_visibilityNote)
          SubListWidget(
            title: S.of(context).notes.toUpperCase(),
            padding: const EdgeInsets.only(left: 20),
            children: [
              SubTextWidget(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                controller: _notesController,
                focusNode: _notesFocus,
                hintText: S.of(context).sayWhat,
                readOnly: !_editState,
                onChanged: (value) => _editAccount.node = value,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ],
          )
      ],
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

  /// 返回事件处理
  void _handlerBack() {
    if (isModifyAccount()) {
      _showSaveDialog();
      return;
    }
    if (_isNewAccount || !_editState) {
      Navigator.of(context).pop();
      return;
    }
    _setViewAccount(_rawAccount);
  }

  /// 返回事件处理
  Future<bool> _onBack() async {
    if (isModifyAccount()) {
      _showSaveDialog();
      return Future.value(false);
    }
    if (_isNewAccount || !_editState) {
      return Future.value(true);
    }
    _setViewAccount(_rawAccount);
    return Future.value(false);
  }

  /// 保存
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

    _editAccount.alias = name;
    _editAccount.name = userName;
    _editAccount.password = password;
    _editAccount.url = website;
    _editAccount.node = notes;

    if (_isNewAccount) {
      _createAccount(_editAccount);
    } else {
      _updateAccount(_editAccount);
    }
  }

  /// 创建账号
  void _createAccount(AccountItem account) {
    _appModel.createAccount(account).then((value) {
      Navigator.of(context).pop();
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 更新账号
  void _updateAccount(AccountItem account) {
    _appModel.updateAccount(account).then((value) {
      _setViewAccount(value);
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 显示账号信息
  void _setViewAccount(AccountItem account) {
    setState(() {
      _editState = false;
      _rawAccount = account;
      _editAccount = account.copy();
      _resetAccountInfo();
    });
  }

  /// 编辑账号
  void _editAccountBy(AccountItem account) {
    setState(() {
      _editState = true;
      _rawAccount = account;
      _editAccount = account.copy();
      _resetAccountInfo();
    });
  }

  /// 恢复账号
  void _restoreAccount() {
    _appModel.restoreAccount(_rawAccount).then((value) {
      Navigator.of(context).pop();
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 删除账号
  Future<void> _deleteAccount() async {

    final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return HintDialog(
            title: S.of(context).deleteAccount,
            message: S.of(context).deleteAccountMessage,
          );
        }
    );

    if (result == 1) {
      _appModel.deleteAccount(_editAccount).then((value) {
        Navigator.of(context).pop();
      }).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
    }
  }

  /// 显示更多
  Future<void> _moreMenu() async {

    final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return ChooseDialog(
            actions: [
              ActionItem.name(name: S.of(context).copy),
              ActionItem.name(name: S.of(context).delete, textColor: Theme.of(context).deleteColor),
            ],
          );
        }
    );

    switch(result) {
      case 0: // 复制
        _editAccountBy(
          _rawAccount.copy(id: 0, alias: '${_rawAccount.alias} - copy')
        );
        break;
      case 1: // 删除
        _appModel.moveToTrash(_rawAccount).then((value) {
          Navigator.of(context).pop();
        }).catchError((error, stackTrace) {
          MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
        });
        break;
    }
  }

  /// 复制到粘贴板
  void _copyToClipboard(String value) {
    _appModel.copyToClipboard(value).then((value) {
      MessageUtil.showMessage(context, S.of(context).copyToClipboard);
    });
  }

  /// 显示保存提示框
  Future<void> _showSaveDialog() async {

    final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return HintDialog(
            title: S.of(context).unsavedChanges,
            message: S.of(context).unsavedChangesMessage,
          );
        }
    );

    if (result == 1) {
      Navigator.of(context).pop();
    }
  }

  /// 重置信息
  void _resetAccountInfo() {
    _visibilityPassword = false;
    _nameController.text = _editAccount.alias;
    _userNameController.text = _editAccount.name;
    _passwordController.text = _editAccount.password;
    _websiteController.text = _editAccount.url;
    _notesController.text = _editAccount.node;
  }

  /// 是否修改了账号
  bool isModifyAccount() {
    return _editState && !_rawAccount.unanimous(_editAccount);
  }
}

