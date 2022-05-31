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

import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/item/sort_item.dart';
import '../../dialog/hint_dialog.dart';
import '../../generated/l10n.dart';
import '../../model/app_model.dart';
import '../../util/error_util.dart';
import '../../util/message_util.dart';
import 'home_side.dart';

class HomeList extends StatefulWidget {

  const HomeList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  final List<AccountItem> _accountItems = [];

  late AppModel _appModel;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _appModel = context.read<AppModel>();
    _appModel.listNotifier.addListener(_infoChange);
    _appModel.loadAllAccount();
  }

  @override
  void dispose() {
    super.dispose();
    _appModel.listNotifier.removeListener(_infoChange);
    _scrollController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColor.listColor,
      constraints: const BoxConstraints.expand(width: 340),
      padding: EdgeInsets.only(top: appWindow.titleBarHeight),
      child: Column(
        children: [
          _buildListHead(),
          XBox.horizontal20,
          Expanded(
            child: _buildAccountList(),
          )
        ],
      ),
    );
  }

  /// 创建列表头
  Widget _buildListHead() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20, top: 26, right: 20, bottom: 30
      ),
      child: Row(
        children: [
          Expanded(
            child: ListSearchWidget(
              iconName: 'ic_search.svg',
              labelText: S.of(context).search,
              onChanged: _infoSearch,
            ),
          ),
          XBox.horizontal5,
          IconButton(
            onPressed: _newAccount,
            icon: SvgPicture.asset(
              'assets/svg/ic_add.svg',
              color: XColor.black,
              width: 20,
              height: 20,
            ),
            tooltip: S.of(context).addAccountTip,
          )
        ],
      ),
    );
  }

  /// 创建账号列表
  Widget _buildAccountList() {

    if (_accountItems.isEmpty) {
      return ListEmptyWidget(
        tips: S.of(context).emptyAccountListTip,
        onPressed: _newAccount,
      );
    }

    final SortType type = _appModel.chooseSide.type;

    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        final item = _accountItems[index];
        return ListItemWidget(
          type: type,
          item: item,
          onChoose: _isChooseItem,
          onPressed: _chooseHandler,
          onFavorite: _handlerFavorite,
          onPointerDown: (event) => _onPointerDown(item, event),
        );
      },
      itemCount: _accountItems.length,
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Divider(color: XColor.listChooseColor),
        );
      },
    );
  }

  /// 鼠标事件
  Future<void> _onPointerDown(AccountItem item, PointerDownEvent event) async {

    if (event.kind != PointerDeviceKind.mouse
        || event.buttons != kSecondaryMouseButton) {
      return;
    }

    final overlay = Overlay.of(context)!.context
        .findRenderObject() as RenderBox;

    final menuItem = await showMenu<int>(
      context: context,
      items: [
        PopupMenuItem(value: 1, child: Text(S.of(context).view)),
        if (!item.trash)
          PopupMenuItem(value: 2, child: Text(S.of(context).edit)),
        PopupMenuItem(value: 3, child: Text(S.of(context).delete)),
      ],
      position: RelativeRect.fromSize(
        event.position & const Size(48.0, 48.0), overlay.size
      )
    );

    switch (menuItem) {
      case 1: // 显示账号
        _viewAccount(item: item);
        break;
      case 2: // 编辑账号
        _editAccount(item: item);
        break;
      case 3: // 删除账号
        _deleteAccount(item: item);
        break;
      default:
    }
  }

  /// 删除账号
  Future<void> _deleteAccount({required AccountItem item}) async {

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

  /// 显示账号
  Future<void> _viewAccount({required AccountItem item}) async {
    if (!await checkModifyAccount()) {
      _appModel.viewAccountBy(item);
    }
  }

  /// 编辑账号
  Future<void> _editAccount({required AccountItem item}) async {
    if (!await checkModifyAccount()) {
      _appModel.editAccountBy(item);
    }
  }

  /// 搜索
  void _infoSearch(String keyword) {
    _appModel.searchAccount(keyword: keyword);
  }

  /// 创建账号
  Future<void> _newAccount() async {
    if (!await checkModifyAccount()) {
      _appModel.newAccount();
    }
  }

  /// 信息修改
  void _infoChange() {
    setState(() {
      _accountItems.clear();
      _accountItems.addAll(_appModel.accounts);
    });
  }

  /// 处理收藏
  void _handlerFavorite(AccountItem item) {
    _appModel.favoriteAccount(item).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 处理账号修改
  Future<bool> checkModifyAccount() async {

    if (!_appModel.isModifyAccount()) {
      return false;
    }

    final result = await showDialog<int>(
        context: context,
        builder: (context) {
          return HintDialog(
            title: S.of(context).unsavedChanges,
            message: S.of(context).unsavedChangesMessage,
          );
        }
    );

    return result != 1;
  }

  bool _isChooseItem(AccountItem item) => _appModel.chooseAccount == item;

  void _chooseHandler(AccountItem item) {
    if (!_isChooseItem(item)) {
      _viewAccount(item: item);
    }
  }
}

class ListItemWidget extends StatefulWidget {

  final SortType type;
  final AccountItem item;
  final ChooseItem<AccountItem> onChoose;
  final ValueChanged<AccountItem> onPressed;
  final ValueChanged<AccountItem> onFavorite;
  final EdgeInsetsGeometry? padding;
  final PointerDownEventListener? onPointerDown;

  const ListItemWidget({
    Key? key,
    required this.type,
    required this.item,
    required this.onChoose,
    required this.onPressed,
    required this.onFavorite,
    this.padding,
    this.onPointerDown
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListItemWidgetState();
}

class ListItemWidgetState extends State<ListItemWidget> {

  bool _favoriteState = false;

  final DateFormat _dateFormat = DateFormat.yMMMMd()..add_Hm();

  bool get favorite => SortType.trash != widget.type && widget.item.favorite;
  bool get unFavorite => SortType.trash != widget.type && _favoriteState && !widget.item.favorite;

  @override
  Widget build(BuildContext context) {

    final choose = widget.onChoose(widget.item);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: XColor.transparent,
        child: MouseRegion(
          onEnter: (event) { _setFavorite(true); },
          onExit: (event) { _setFavorite(false); },
          child: Listener(
            onPointerDown: widget.onPointerDown,
            child: Ink(
              decoration: BoxDecoration(
                color: choose ? XColor.listChooseColor : XColor.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: InkWell(
                splashColor: XColor.listChooseColor,
                highlightColor: XColor.listChooseColor,
                enableFeedback: false,
                borderRadius: BorderRadius.circular(6),
                onTap: () { widget.onPressed(widget.item); },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.alias,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              // color: XColor.sideTextColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 16
                            ),
                          ),
                          XBox.vertical10,
                          Text(
                            widget.item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: XColor.grayColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14
                            ),
                          ),
                          XBox.vertical5,
                          Text(
                            _dateFormat.format(widget.item.updateDateTime),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: XColor.grayColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      if (favorite)
                        _buildFavorite(
                          icon: 'assets/svg/ic_favorite.svg',
                          color: XColor.favoriteColor,
                          onPressed: _handlerFavorite
                        ),
                      if (unFavorite)
                        _buildFavorite(
                          icon: 'assets/svg/ic_un_favorite.svg',
                          color: XColor.gray2Color,
                          onPressed: _handlerFavorite
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 创建收藏控件
  Widget _buildFavorite({
    required String icon,
    required Color color,
    VoidCallback? onPressed
  }) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        iconSize: 18,
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints(
          maxWidth: 18
        ),
        onPressed: onPressed,
        icon: SvgPicture.asset(
          icon,
          color: color,
          width: 18,
        )
      ),
    );
  }

  /// 处理收藏事件
  void _handlerFavorite() {
    widget.onFavorite(widget.item);
  }

  /// 设置收藏状态
  void _setFavorite(bool show) {
    setState(() {
      _favoriteState = show;
    });
  }
}

class ListSearchWidget extends StatelessWidget {

  final TextEditingController? controller;
  final String iconName;
  final String? labelText;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const ListSearchWidget({
    Key? key,
    this.controller,
    required this.iconName,
    this.labelText,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 32,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SvgPicture.asset(
              'assets/svg/$iconName',
              color: XColor.black,
              width: 12,
              height: 12,
            ),
          ),
          hintText: labelText,
          hintStyle: const TextStyle(
            fontSize: 14
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
        ),
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}

class ListEmptyWidget extends StatelessWidget {

  final String tips;
  final VoidCallback? onPressed;

  const ListEmptyWidget({
    Key? key,
    required this.tips,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 130),
        child: Material(
          child: Ink(
            decoration: BoxDecoration(
              color: XColor.listColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 28, top: 24, right: 28, bottom: 24
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/ic_empty.svg',
                      color: XColor.themeColor,
                      width: 46,
                      height: 46
                    ),
                    const SizedBox(height: 20),
                    Text(tips),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

