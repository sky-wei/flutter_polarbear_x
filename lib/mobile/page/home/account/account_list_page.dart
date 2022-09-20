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
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/mobile/widget/list_item_widget.dart';
import 'package:flutter_polarbear_x/route/mobile_page_route.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/list_empty_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'edit_account_page.dart';

class AccountListPage extends StatefulWidget {

  final bool pageState;
  final SortType sortType;
  final FolderItem? folder;

  const AccountListPage({
    Key? key,
    this.pageState = true,
    required this.sortType,
    this.folder
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountListState();
}

class _AccountListState extends State<AccountListPage> {

  late AppMobileModel _appModel;
  late ScrollController _scrollController;

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
        appBar: AppBar(
          leading: ActionMenuWidget(
            iconName: 'ic_back.svg',
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.folder?.name ?? _getNameByType(widget.sortType)),
          titleTextStyle: TextStyle(
              color: Theme.of(context).mainTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w500
          ),
          centerTitle: true,
          actions: _buildActions(widget.sortType),
          elevation: 0,
          backgroundColor: Theme.of(context).dialogBackgroundColor,
        ),
        body: _buildBodyContent(),
        backgroundColor: Theme.of(context).backgroundColor,
      );
    }
    return _buildBodyContent();
  }

  /// 创建 Widget
  List<Widget>? _buildActions(SortType type) {
    if (SortType.trash == type) {
      return [
        ActionMenuWidget(
          iconName: 'ic_trash.svg',
          iconColor: Theme.of(context).deleteColor,
          onPressed: () => _cleanTrash(),
        )
      ];
    }
    return null;
  }

  /// 获取名称
  String _getNameByType(SortType type) {
    if (SortType.favorite == type) {
      return S.of(context).favorite;
    } else if (SortType.trash == type) {
      return S.of(context).trash;
    }
    return '';
  }

  /// 创建内容体
  Widget _buildBodyContent() {
    return FutureBuilder<List<AccountItem>>(
      future: loadAccount(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final accountItems = snapshot.data!;
            
            if (accountItems.isEmpty) {
              return ListEmptyWidget(
                tips: S.of(context).emptyAccountListTip,
                onPressed: SortType.allItems == widget.sortType ? _newAccount : null,
              );
            }
            return _buildListWidget(accountItems);
          }

          if (snapshot.hasError) {
            return _buildErrorWidget();
          }
        }
        return const Center();
      },
    );
  }

  /// 创建列表的控件
  Widget _buildListWidget(List<AccountItem> accountItems) {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        itemBuilder: (context, index) {
          final account = accountItems[index];
          return _buildSlidableWidget(account);
        },
        itemCount: accountItems.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }

  /// 创建 Slidable
  Widget _buildSlidableWidget(AccountItem account) {
    return Slidable(
      groupTag: '0',
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: SortType.trash == widget.sortType ? [
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
  SlidableAction _buildCopyAction({
    required SlidableActionCallback onPressed
  }) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).themeColor,
      foregroundColor: Colors.white,
      icon: Icons.copy,
      label: S.of(context).copy,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
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
      label: S.of(context).favorite,
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

  /// 创建错误的控件
  Widget _buildErrorWidget() {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 48,
            ),
            XBox.vertical20,
            Text(S.of(context).handlerError)
          ],
        )
    );
  }

  /// 创建账号
  Future<void> _newAccount() async {

    final account = AccountItem.formAdmin(
        _appModel.admin.id
    );

    Navigator.push<AccountItem>(
        context,
        MobilePageRoute(child: EditAccountPage(account: account))
    );
  }

  /// 编辑账号
  Future<void> _editAccount(AccountItem account) async {
    Navigator.push<AccountItem>(
        context,
        MobilePageRoute(child: EditAccountPage(account: account))
    );
  }

  /// 恢复账号
  Future<void> _restoreAccount(AccountItem account) async {

  }

  /// 收藏账号
  Future<void> _favoriteAccount(AccountItem account) async {
    _appModel.favoriteAccount(account).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 删除账号
  Future<void> _deleteAccount(AccountItem account) async {

  }
  
  /// 清除回收箱
  Future<void> _cleanTrash() async {
    
  }

  /// 加载账号
  Future<List<AccountItem>> loadAccount() {
    return _appModel.loadAccountBy(type: widget.sortType, folder: widget.folder);
  }

  /// 信息修改
  void _infoChange() {
    setState(() {  });
  }
}

