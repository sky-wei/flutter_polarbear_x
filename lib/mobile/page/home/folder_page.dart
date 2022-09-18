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
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';
import '../../../data/item/folder_item.dart';
import '../../../data/item/sort_item.dart';
import '../../../model/app_model.dart';
import '../../../model/side_item.dart';
import '../../../theme/color.dart';
import '../../../util/size_box_util.dart';

class FolderPage extends StatefulWidget {

  const FolderPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FolderPageState();
}

class FolderPageState extends State<FolderPage> {

  late AppModel _appModel;

  final List<SideItem> _sideItems = [];

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
    _appModel.folderNotifier.addListener(_infoChange);
    _appModel.loadFolders();
  }

  @override
  void dispose() {
    _appModel.folderNotifier.removeListener(_infoChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = _sideItems[index];
        return SideItemWidget(
          item: item,
          onChoose: _isChooseItem,
          onPressed: _chooseHandler,
          onPointerDown: (event) {}
          // item.id > 0 ? _onPointerDown(item, event) : null,
        );
      },
      itemCount: _sideItems.length,
    );
  }

  /// 信息修改
  Future<void> _infoChange() async {

    final items = _appModel.folders;
    final sideItems = items.map((value) => _buildSideItem(value)).toList();

    setState(() {
      _sideItems.clear();
      _sideItems.addAll(sideItems);
    });
  }

  /// 创建SideItem
  SideItem _buildSideItem(FolderItem item) {
    return SideItem(
        id: item.id,
        name: item.name,
        icon: 'assets/svg/ic_folder.svg',
        type: SortType.folder,
        value: item
    );
  }

  /// 是否选择
  bool _isChooseItem(SideItem item) => _appModel.chooseSide == item;

  /// 选择处理
  void _chooseHandler(SideItem item) {
    if (!_isChooseItem(item)) {
      setState(() {
        _appModel.switchSide(side: item);
      });
    }
  }
}

class SideItemWidget extends StatelessWidget {

  final SideItem item;
  final ChooseItem<SideItem> onChoose;
  final ValueChanged<SideItem>? onPressed;
  final EdgeInsetsGeometry? padding;
  final PointerDownEventListener? onPointerDown;

  const SideItemWidget({
    Key? key,
    required this.item,
    required this.onChoose,
    this.onPressed,
    this.padding,
    this.onPointerDown
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final choose = onChoose(item);

    return Padding(
      padding: padding?? const EdgeInsets.only(left: 10, top: 5, right: 10),
      child: Material(
        color: XColor.transparent,
        child: Listener(
          onPointerDown: onPointerDown,
          child: Ink(
            decoration: BoxDecoration(
              color: choose ? Theme.of(context).sideChooseColor : XColor.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              splashColor: Theme.of(context).sideChooseColor,
              highlightColor: Theme.of(context).sideChooseColor,
              enableFeedback: false,
              borderRadius: BorderRadius.circular(6),
              onTap: () { if (onPressed != null) onPressed!(item); },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  children: [
                    if (item.icon != null)
                      SvgPicture.asset(
                        item.icon!,
                        color: choose ? item.color : Theme.of(context).sideTextColor,
                        width: 18,
                      ),
                    if (item.icon != null)
                      XBox.horizontal15,
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).sideTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
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
