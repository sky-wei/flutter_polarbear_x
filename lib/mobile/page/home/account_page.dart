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
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/route/mobile_page_route.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/list_empty_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'account/edit_account_page.dart';

class AccountPage extends StatefulWidget {

  const AccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {

  final List<AccountItem> _accountItems = [];

  late AppMobileModel _appModel;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _appModel = context.read<AppMobileModel>();
    // _appModel.listNotifier.addListener(_infoChange);
    // _appModel.loadAllAccount();
  }

  @override
  void dispose() {
    super.dispose();
    // _appModel.listNotifier.removeListener(_infoChange);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_accountItems.isEmpty) {
      return ListEmptyWidget(
        tips: S.of(context).emptyAccountListTip,
        onPressed: _newAccount,
      );
    }

    // final SortType type = _appModel.chooseSide.type;

    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        final item = _accountItems[index];
        return ListItemWidget(
          type: SortType.allItems,
          item: item,
          onChoose: (account) { return false; },
          onPressed: (account) {},
          onFavorite: (account) {},
          // onPointerDown: (event) => _onPointerDown(item, event),
        );
      },
      itemCount: _accountItems.length,
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Divider(color: Theme.of(context).listChooseColor),
        );
      },
    );
  }

  Future<void> _newAccount() async {

    final account = AccountItem.formAdmin(
        _appModel.admin.id
    );

    Navigator.push<AccountItem>(
        context,
        MobilePageRoute(child: EditAccountPage(account: account))
    );
  }

  /// 信息修改
  void _infoChange() {
    setState(() {
      _accountItems.clear();
      _accountItems.addAll(_appModel.accounts);
    });
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
                color: choose ? Theme.of(context).listChooseColor : XColor.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: InkWell(
                splashColor: Theme.of(context).listChooseColor,
                highlightColor: Theme.of(context).listChooseColor,
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
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14
                            ),
                          ),
                          XBox.vertical5,
                          Text(
                            _dateFormat.format(widget.item.updateDateTime),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      if (favorite)
                        _buildFavorite(
                            icon: 'assets/svg/ic_favorite.svg',
                            color: Theme.of(context).favoriteColor,
                            onPressed: _handlerFavorite
                        ),
                      if (unFavorite)
                        _buildFavorite(
                            icon: 'assets/svg/ic_un_favorite.svg',
                            color: Theme.of(context).hintColor,
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
