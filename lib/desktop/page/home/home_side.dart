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

import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/item/side_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/desktop/dialog/hint_dialog.dart';
import 'package:flutter_polarbear_x/desktop/dialog/input_dialog.dart';
import 'package:flutter_polarbear_x/desktop/model/app_desktop_model.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/route.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/head_logo_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'home_user_info.dart';


class HomeSide extends StatefulWidget {

  const HomeSide({super.key});

  @override
  State<StatefulWidget> createState() => _HomeSideState();
}

class _HomeSideState extends State<HomeSide> {

  late AppDesktopModel _appModel;

  final List<SideItem> _sideItems = [];

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppDesktopModel>();
    _appModel.folderNotifier.addListener(_infoChange);
    _appModel.lockManager.addListener(_lockChange);
    _appModel.loadFolders();
  }

  @override
  void dispose() {
    _appModel.folderNotifier.removeListener(_infoChange);
    _appModel.lockManager.removeListener(_lockChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).sideColor,
      constraints: const BoxConstraints.expand(width: 260),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Platform.isLinux || Platform.isWindows)
            HeadLogoWidget(
              logo: XConstant.headLogo,
              title: S.of(context).appName,
            ),
          if (Platform.isMacOS)
            XBox.vertical36,
          const HomeUserInfoWidget(),
          XBox.vertical5,
          for (var item in _appModel.fixedSide)
            SideItemWidget(
              item: item,
              onChoose: _isChooseItem,
              onPressed: _chooseHandler,
            ),
          XBox.vertical10,
          SideFolderWidget(
            name: S.of(context).folders,
            onPressed: _editFolder,
          ),
          Expanded(
            child: _buildFolderSideList()
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: _buildToolboxWidget()
          ),
        ],
      ),
    );
  }

  /// 创建工具箱控件
  Widget _buildToolboxWidget() {
    return PopupMenuButton<int>(
      tooltip: S.of(context).toolbox,
      icon: SvgPicture.asset(
        'assets/svg/ic_tools.svg',
        color: Theme.of(context).sideTextColor,
      ),
      itemBuilder: (context) {
        return [
          _buildMenuItem(
            value: 0,
            iconName: 'assets/svg/ic_lock.svg',
            labelText: S.of(context).lock
          ),
          _buildMenuItem(
            value: 1,
            iconName: 'assets/svg/ic_exit.svg',
            iconColor: Theme.of(context).deleteColor,
            labelText: S.of(context).logout,
          ),
        ];
      },
      onSelected: (index) {
        switch(index) {
          case 0:
            _appModel.lockNotice();
            break;
          case 1:
            _appModel.restartApp(context);
            break;
        }
      },
    );
  }

  /// 创建文件夹列表
  Widget _buildFolderSideList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = _sideItems[index];
        return SideItemWidget(
          item: item,
          onChoose: _isChooseItem,
          onPressed: _chooseHandler,
          onPointerDown: (event) =>
          item.id > 0 ? _onPointerDown(item, event) : null,
        );
      },
      itemCount: _sideItems.length,
    );
  }

  /// 创建菜单项
  PopupMenuItem<int> _buildMenuItem({
    required int value,
    required String iconName,
    Color? iconColor,
    required String labelText,
    Color? labelColor,
  }) {
    return PopupMenuItem(
      value: value,
      child: TextButton.icon(
        onPressed: null,
        icon: SvgPicture.asset(
          iconName,
          color: iconColor ?? Theme.of(context).iconColor,
          width: 18
        ),
        label: Text(
          labelText,
          style: TextStyle(
            color: labelColor ?? Theme.of(context).iconColor,
          ),
        ),
      ),
    );
  }

  /// 鼠标事件
  Future<void> _onPointerDown(SideItem item, PointerDownEvent event) async {

    if (event.kind != PointerDeviceKind.mouse
        || event.buttons != kSecondaryMouseButton) {
      return;
    }

    final overlay = Overlay.of(context)!.context
        .findRenderObject() as RenderBox;

    final menuItem = await showMenu<int>(
        context: context,
        items: [
          PopupMenuItem(value: 1, child: Text(S.of(context).edit)),
          PopupMenuItem(value: 2, child: Text(S.of(context).delete)),
        ],
        position: RelativeRect.fromSize(
            event.position & const Size(48.0, 48.0), overlay.size
        )
    );
    
    switch (menuItem) {
      case 1: // 编辑
        _editFolder(item: item);
        break;
      case 2: // 删除
        _deleteFolder(item: item);
        break;
      default:
    }
  }

  /// 编辑文件夹
  Future<void> _editFolder({SideItem? item}) async {

    final FolderItem? folder = item?.data;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return InputDialog(
          title: S.of(context).editFolder,
          labelText: S.of(context).name,
          value: folder?.name ?? '',
        );
      }
    );

    if (result == null) {
      return;
    }

    if (result.isEmpty) {
      MessageUtil.showMessage(context, S.of(context).canNotEmpty);
      return;
    }

    if (folder == null) {
      // 创建文件夹
      _appModel.createFolder(result).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
      return;
    }

    // 更新文件夹
    _appModel.updateFolder(folder.copy(name: result)).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 删除文件夹
  Future<void> _deleteFolder({required SideItem item}) async {

    final FolderItem folder = item.data;

    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return HintDialog(
          title: S.of(context).deleteFolder,
          message: S.of(context).deleteFolderMessage,
        );
      }
    );

    if (result == 1) {
      _appModel.deleteFolder(folder).then((value) {
        if (_isChooseItem(item)) {
          _chooseHandler(_appModel.allItems);
        } else {
          _appModel.refreshAccounts();
        }
      }).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
    }
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

  /// 锁屏修改
  Future<void> _lockChange() async {
    if (_appModel.lockManager.value) {
      Navigator.pushNamed(context, XRoute.lock);
    }
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

class SideFolderWidget extends StatelessWidget {

  final String name;
  final VoidCallback? onPressed;

  const SideFolderWidget({
    Key? key,
    required this.name,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: XColor.hintColor,
                fontWeight: FontWeight.normal
              ),
            )
          ),
          IconButton(
            onPressed: onPressed,
            icon: SvgPicture.asset(
              'assets/svg/ic_add.svg',
              color: Theme.of(context).sideTextColor,
              width: 16,
            ),
            tooltip: S.of(context).addFolderTip,
          ),
        ],
      ),
    );
  }
}

