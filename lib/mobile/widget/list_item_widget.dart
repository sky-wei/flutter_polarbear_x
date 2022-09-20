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
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ListItemWidget extends StatelessWidget {

  final SortType type;
  final AccountItem account;
  final ValueChanged<AccountItem> onPressed;
  final ValueChanged<AccountItem> onFavorite;
  final EdgeInsetsGeometry? padding;
  final PointerDownEventListener? onPointerDown;

  ListItemWidget({
    Key? key,
    required this.type,
    required this.account,
    required this.onPressed,
    required this.onFavorite,
    this.padding,
    this.onPointerDown
  }) : super(key: key);

  final DateFormat _dateFormat = DateFormat.yMMMMd()..add_Hm();

  bool get favorite => SortType.trash != type && account.favorite;
  bool get unFavorite => SortType.trash != type && !account.favorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: const BorderRadiusDirectional.all(Radius.circular(6)),
      child: Ink(
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () { onPressed(account); },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.alias,
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
                      account.name,
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
                      _dateFormat.format(account.updateDateTime),
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
                      color: Theme.of(context).favoriteColor
                  ),
                if (unFavorite)
                  _buildFavorite(
                      icon: 'assets/svg/ic_un_favorite.svg',
                      color: Theme.of(context).hintColor
                  ),
              ],
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
}
