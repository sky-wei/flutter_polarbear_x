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
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/dialog/hint_dialog.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/mobile/widget/list_item_widget.dart';
import 'package:flutter_polarbear_x/route/mobile_page_route.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/list_empty_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'edit_account_page.dart';

class AccountListPage extends StatefulWidget {

  final bool pageState;
  final bool openSearch;
  final SortType sortType;
  final FolderItem? folder;

  const AccountListPage({
    Key? key,
    this.pageState = true,
    this.openSearch = false,
    required this.sortType,
    this.folder
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AccountListState();
}

class AccountListState extends State<AccountListPage> {

  final List<AccountItem> _accountItems = [];

  bool _loading = true;
  String _keyword = '';
  late AppMobileModel _appModel;
  late ScrollController _scrollController;

  bool get isFavorite => SortType.favorite == widget.sortType;
  bool get isAllItems => SortType.allItems == widget.sortType;
  bool get isFolder => SortType.folder == widget.sortType;
  bool get isTrash => SortType.trash == widget.sortType;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _appModel = context.read<AppMobileModel>();
    _appModel.allAccountNotifier.addListener(_infoChange);
    _infoChange();
  }

  @override
  void dispose() {
    _appModel.allAccountNotifier.removeListener(_infoChange);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pageState) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: _buildBodyContent(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
    }
    return _buildBodyContent();
  }

  /// 搜索
  Future<void> search(String keyword) async {
    if (widget.openSearch) {
      _keyword = keyword;
      _infoChange();
    }
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(widget.folder?.name ?? _getTitleName()),
      titleTextStyle: TextStyle(
          color: Theme.of(context).mainTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      actions: _buildActions(),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  /// 创建 Widget
  List<Widget>? _buildActions() {
    if (isTrash) {
      return [
        ActionMenuWidget(
          iconName: 'ic_trash.svg',
          tooltip: S.of(context).trash,
          iconColor: Theme.of(context).deleteColor,
          onPressed: () => _clearTrash(),
        )
      ];
    }
    if (isFolder) {
      return [
        ActionMenuWidget(
          iconName: 'ic_add.svg',
          tooltip: S.of(context).newAccount,
          onPressed: () => _newAccount(),
        )
      ];
    }
    return null;
  }

  /// 获取名称
  String _getTitleName() {
    if (isFavorite) {
      return S.of(context).favorite;
    } else if (isTrash) {
      return S.of(context).trash;
    }
    return '';
  }

  /// 创建内容体
  Widget _buildBodyContent() {

    if (_loading) {
      return const Center();
    }

    if (_accountItems.isEmpty) {
      return ListEmptyWidget(
        tips: S.of(context).emptyAccountListTip,
        onPressed: _isHandlerEmptyEvent() ? _newAccount : null,
      );
    }

    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        itemBuilder: (context, index) {
          final account = _accountItems[index];
          return _buildSlidableWidget(account);
        },
        itemCount: _accountItems.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }

  /// 是不处理空控件事件
  bool _isHandlerEmptyEvent() {
    return !isTrash && !widget.openSearch;
  }

  /// 创建 Slidable
  Widget _buildSlidableWidget(AccountItem account) {
    return Slidable(
      groupTag: '0',
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: isTrash ? [
          _buildRestoreAction(onPressed: (context) => _restoreAccount(account)),
          _buildDeleteAction(onPressed: (context) => _deleteAccount(account))
        ] : [
          _buildFavoriteAction(account: account, onPressed: (context) => _favoriteAccount(account)),
          _buildDeleteAction(onPressed: (context) => _deleteAccount(account)),
        ]
      ),
      child: ListItemWidget(
        type: widget.sortType,
        account: account,
        onPressed: _editAccount,
      ),
    );
  }

  /// 创建恢复控件
  SlidableAction _buildRestoreAction({
    required SlidableActionCallback onPressed
  }) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).themeColor,
      foregroundColor: Colors.white,
      icon: Icons.restore,
      label: S.of(context).restore,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
    );
  }

  /// 创建收藏控件
  SlidableAction _buildFavoriteAction({
    required AccountItem account,
    required SlidableActionCallback onPressed
  }) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).favoriteColor,
      foregroundColor: Colors.white,
      icon: account.favorite ? Icons.favorite_border : Icons.favorite,
      label: account.favorite ? S.of(context).cancel : S.of(context).favorite,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
    );
  }

  /// 创建删除控件
  SlidableAction _buildDeleteAction({
    required SlidableActionCallback onPressed
  }) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).deleteColor,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: S.of(context).delete,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
    );
  }

  /// 创建账号
  void _newAccount() {

    final account = AccountItem.formAdmin(
        _appModel.admin.id
    ) ..favorite = isFavorite
      ..folderId = widget.folder?.id ?? FolderItem.noFolder;

    Navigator.push<AccountItem>(
        context,
        MobilePageRoute(child: EditAccountPage(account: account))
    );
  }

  /// 编辑账号
  Future<void> _editAccount(AccountItem account) async {
    Navigator.push<AccountItem>(
        context,
        MobilePageRoute(child: EditAccountPage(editState: false, account: account))
    );
  }

  /// 恢复账号
  Future<void> _restoreAccount(AccountItem account) async {
    _appModel.restoreAccount(account).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 收藏账号
  Future<void> _favoriteAccount(AccountItem account) async {
    _appModel.favoriteAccount(account).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 删除账号
  Future<void> _deleteAccount(AccountItem account) async {
    if (isTrash) {
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
        _appModel.deleteAccount(account).catchError((error, stackTrace) {
          MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
        });
      }
    } else {
      _appModel.moveToTrash(account).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
    }
  }
  
  /// 清除回收箱
  Future<void> _clearTrash() async {

    if (_accountItems.isEmpty) {
      // 不需要处理
      return;
    }

    final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return HintDialog(
            title: S.of(context).clearData,
            message: S.of(context).clearTrashTips,
          );
        }
    );

    if (result == 1) {
      _appModel.deleteAccounts(_accountItems).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
    }
  }

  /// 加载账号
  Future<List<AccountItem>> loadAccount() async {

    if (!widget.openSearch) {
      // 不需要搜索直接返回
      return await _appModel.loadAccountBy(
          type: widget.sortType, folder: widget.folder
      );
    }

    if (_keyword.isEmpty) {
      return [];
    }

    final accounts = await _appModel.loadAccountBy(
        type: widget.sortType, folder: widget.folder
    );

    return _appModel.filterAccount(
        accounts: accounts,
        filter: (item) => item.contains(_keyword)
    );
  }

  /// 信息修改
  Future<void> _infoChange() async {

    final accounts = await loadAccount();

    setState(() {
      _loading = false;
      _accountItems.clear();
      _accountItems.addAll(accounts);
    });
  }
}

