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
import 'package:flutter_polarbear_x/data/item/folder_item.dart';
import 'package:flutter_polarbear_x/data/item/side_item.dart';
import 'package:flutter_polarbear_x/data/item/sort_item.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class FolderPage extends StatefulWidget {

  const FolderPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FolderPageState();
}

class FolderPageState extends State<FolderPage> {

  late AppMobileModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppMobileModel>();
    _appModel.folderNotifier.addListener(_infoChange);
  }

  @override
  void dispose() {
    _appModel.folderNotifier.removeListener(_infoChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      itemBuilder: (context, index) {
        final folder = _appModel.folders[index];
        return _SideItemWidget(
          item: _buildSideItem(folder),
          moreIcon: 'assets/svg/ic_arrow_right.svg',
          onPressed: _chooseHandler,
          onLongPress: () {}
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemCount: _appModel.folders.length,
    );
  }

  /// 信息修改
  Future<void> _infoChange() async {
    setState(() { });
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

  /// 选择处理
  void _chooseHandler(SideItem item) {

  }
}

class _SideItemWidget extends StatelessWidget {

  final SideItem item;
  final String? moreIcon;
  final ValueChanged<SideItem>? onPressed;
  final GestureLongPressCallback? onLongPress;

  const _SideItemWidget({
    Key? key,
    required this.item,
    this.moreIcon,
    this.onPressed,
    this.onLongPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: const BorderRadiusDirectional.all(Radius.circular(6)),
      child: Ink(
        height: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () { if (onPressed != null) onPressed!(item); },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                if (item.icon != null)
                  SvgPicture.asset(
                    item.icon!,
                    color: Theme.of(context).mainTextColor,
                    width: 18,
                  ),
                if (item.icon != null)
                  XBox.horizontal20,
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).mainTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                if (moreIcon != null)
                  XBox.horizontal20,
                if (moreIcon != null)
                  SvgPicture.asset(
                    moreIcon!,
                    color: Theme.of(context).mainTextColor,
                    width: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
