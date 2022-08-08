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
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/page/setting/about_widget.dart';
import 'package:flutter_polarbear_x/page/setting/account_widget.dart';
import 'package:flutter_polarbear_x/page/setting/preference_widget.dart';
import 'package:flutter_polarbear_x/page/setting/security_widget.dart';
import 'package:flutter_polarbear_x/page/setting/storge_widget.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_svg/svg.dart';

import '../../generated/l10n.dart';
import '../../model/side_item.dart';
import '../../util/size_box_util.dart';


typedef ChooseItem<T> = bool Function(T value);

class SettingDialog extends StatelessWidget {

  const SettingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 900,
        height: 700,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: const EdgeInsets.all(12),
                onPressed: () { Navigator.pop(context); },
                icon: CloseIcon(color: Theme.of(context).closeColor)
              ),
            ),
            const SettingWidget()
          ],
        ),
      ),
    );
  }
}

class SettingWidget extends StatefulWidget {
  
  const SettingWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {

  final List<SideItem> _items = [
    SideItem(id: 0, name: S.current.account, icon: 'assets/svg/ic_user.svg'),
    SideItem(id: 1, name: S.current.preference, icon: 'assets/svg/ic_all_items.svg'),
    SideItem(id: 2, name: S.current.security, icon: 'assets/svg/ic_security.svg'),
    SideItem(id: 3, name: S.current.storage, icon: 'assets/svg/ic_storage.svg'),
    SideItem(id: 4, name: S.current.about, icon: 'assets/svg/ic_about.svg'),
  ];

  SideItem? _curSideItem;

  @override
  void initState() {
    super.initState();
    _curSideItem = _items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSide(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: _buildContent(_curSideItem!),
          ),
        )
      ],
    );
  }

  Widget _buildSide() {
    return Container(
      constraints: const BoxConstraints.expand(width: 230),
      decoration: BoxDecoration(
        color: Theme.of(context).listColor,
        borderRadius: const BorderRadius.all(Radius.circular(4))
      ),
      child: Column(
        children: [
          XBox.vertical30,
          for (var item in _items)
            SideItemWidget(
              item: item,
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            )
        ],
      ),
    );
  }

  Widget _buildContent(SideItem item) {
    switch(item.id) {
      case 0:
        return const AccountWidget();
      case 1:
        return const PreferenceWidget();
      case 2:
        return const SecurityWidget();
      case 3:
        return const StorageWidget();
      case 4:
        return const AboutWidget();
      default:
        return const Center(
          child: Text(''),
        );
    }
  }

  bool _isChooseItem(SideItem item) => _curSideItem == item;

  void _chooseHandler(SideItem item) {
    setState(() {
      _curSideItem = item;
    });
  }
}

class SideItemWidget extends StatelessWidget {

  final SideItem item;
  final ChooseItem<SideItem> onChoose;
  final ValueChanged<SideItem>? onPressed;
  final EdgeInsetsGeometry? padding;

  const SideItemWidget({
    Key? key,
    required this.item,
    required this.onChoose,
    this.onPressed,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final choose = onChoose(item);

    return Padding(
      padding: padding?? const EdgeInsets.only(left: 10, top: 5, right: 10),
      child: Material(
        color: XColor.transparent,
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
            onTap: () { if (onPressed != null) onPressed!(item); },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  if (item.icon != null)
                    SvgPicture.asset(
                      item.icon!,
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 18,
                    ),
                  if (item.icon != null)
                    XBox.horizontal15,
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

