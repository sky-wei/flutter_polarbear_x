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
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/dialog/hint_dialog.dart';
import 'package:flutter_polarbear_x/mobile/dialog/input_dialog.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_item_line.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_menu_widget.dart';
import 'package:provider/provider.dart';


class StoragePage extends StatefulWidget {

  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {

  late AppMobileModel _appModel;

  @override
  void initState() {
    _appModel = context.read<AppMobileModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(S.of(context).storage),
      titleTextStyle: TextStyle(
        color: Theme.of(context).mainTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  /// 创建界面内容
  Widget _buildBodyContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      children: [
        SubListWidget(
          title: "${S.of(context).import}/${S.of(context).export}".toUpperCase(),
          children: [
            _buildTextMenuWidget(
              title: S.of(context).import,
              onTap: _importAccount,
            ),
            _buildLineWidget(),
            _buildTextMenuWidget(
              title: S.of(context).export,
              onTap: _exportAccount,
            ),
          ],
        ),
        XBox.vertical20,
        SubListWidget(
          title: S.of(context).data.toUpperCase(),
          children: [
            _buildTextMenuWidget(
              title: S.of(context).clearData,
              onTap: _clearData,
            ),
          ],
        )
      ],
    );
  }

  /// 创建菜单
  Widget _buildTextMenuWidget({
    required String title,
    required GestureTapCallback onTap
  }) {
    return SubMenuWidget(
      title: title,
      moreIconName: 'ic_arrow_right.svg',
      padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
      onTap: onTap,
    );
  }

  /// 创建分割线
  Widget _buildLineWidget() {
    return const SubItemLine(padding: EdgeInsets.only(left: 20));
  }

  /// 导入账号
  Future<void> _importAccount() async {

    _appModel.importAccount(() async {
      return await _showPasswordDialog(
        title: S.of(context).importAccount,
      );
    }).then((value) {
      if (value) {
        MessageUtil.showMessage(context, S.of(context).importCompleted);
      }
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 导出账号
  Future<void> _exportAccount() async {

    _appModel.exportAccount(() async {
      return await _showPasswordDialog(
        title: S.of(context).exportAccount,
      );
    }).then((value) {
      if (value) {
        MessageUtil.showMessage(context, S.of(context).exportCompleted);
      }
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 清除数据
  Future<void> _clearData() async {

    final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return HintDialog(
            title: S.of(context).clearData,
            message: S.of(context).clearDataMessage,
          );
        }
    );

    if (result == 1) {
      _appModel.clearData().then((value) {
        if (value) {
          MessageUtil.showMessage(context, S.of(context).clearCompleted);
        }
      }).catchError((error, stackTrace) {
        MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
      });
    }
  }

  /// 显示密码输入框
  Future<String?> _showPasswordDialog({
    required String title
  }) async {
    return await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return InputDialog(
            title: title,
            labelText: S.of(context).password,
            obscureText: true,
            tips: S.of(context).importTips,
          );
        }
    );
  }
}
