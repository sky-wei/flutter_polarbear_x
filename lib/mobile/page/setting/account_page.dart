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

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/constant.dart';
import 'package:flutter_polarbear_x/data/item/admin_item.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/mobile/dialog/input_dialog.dart';
import 'package:flutter_polarbear_x/mobile/dialog/password_dialog.dart';
import 'package:flutter_polarbear_x/mobile/model/app_mobile_model.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/image_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/widget/action_menu_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_item_line.dart';
import 'package:flutter_polarbear_x/widget/sub_list_widget.dart';
import 'package:flutter_polarbear_x/widget/sub_menu_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class AccountPage extends StatefulWidget {

  const AccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final DateFormat _dateFormat = DateFormat.yMMMMd()..add_Hm();

  late AppMobileModel _appModel;

  AdminItem get admin => _appModel.admin;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppMobileModel>();
    _appModel.addListener(_infoChange);
  }

  @override
  void dispose() {
    super.dispose();
    _appModel.removeListener(_infoChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBodyContent(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 创建AppBar
  AppBar _buildAppBar() {
    return AppBar(
      leading: ActionMenuWidget(
        iconName: 'ic_back.svg',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(S.of(context).account),
      titleTextStyle: TextStyle(
        color: Theme.of(context).mainTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  /// 创建界面内容
  Widget _buildBodyContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: _buildHeadWidget(
                  onPressed: () => _changeHeadImage(admin)
              ),
            )
          ],
        ),
        XBox.vertical20,
        SubListWidget(
          children: [
            _buildTextMenuWidget(
              title: S.of(context).name,
              value: admin.name,
              onTap: () => _changeName(admin),
            ),
            _buildLineWidget(),
            _buildTextMenuWidget(
              title: S.of(context).password,
              value: '********',
              onTap: () => _changePassword(admin),
            ),
            _buildLineWidget(),
            _buildTextMenuWidget(
              title: S.of(context).notes,
              value: admin.desc,
              onTap: () => _changeNotes(admin),
            ),
          ],
        ),
        XBox.vertical20,
        SubListWidget(
          children: [
            _buildTextMenuWidget(
              title: S.of(context).updated,
              value: _dateFormat.format(admin.updateDateTime),
              moreIconName: null,
            ),
          ],
        )
      ],
    );
  }

  /// 创建菜单
  Widget _buildTextMenuWidget({
    required String title,
    required String value,
    String? moreIconName = 'ic_arrow_right.svg',
    GestureTapCallback? onTap
  }) {
    return SubMenuWidget(
      title: title,
      value: value,
      moreIconName: moreIconName,
      padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
      onTap: onTap,
    );
  }

  /// 创建分割线
  Widget _buildLineWidget() {
    return const SubItemLine(padding: EdgeInsets.only(left: 20));
  }

  /// 生成头像
  Widget _buildHeadWidget({required VoidCallback onPressed}) {
    return ClipOval(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          ImageUtil.create(
            admin.getUserImage(),
            width: 70
          ),
          Positioned(
            top: 50,
            width: 70,
            height: 20,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  color: Color(0x60000000)
              ),
              child: Center(
                child: InkWell(
                  onTap: onPressed,
                  child: Text(
                    S.of(context).edit,
                    style: const TextStyle(
                        color: Color(0xEEFFFFFF),
                        fontSize: 12
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 信息修改
  void _infoChange() {
    setState(() {
      // 信息修改需要刷新
    });
  }

  /// 修改用户名
  void _changeName(AdminItem admin) {
    _showEditDialog(
        title: S.of(context).edit,
        labelText: S.of(context).name,
        value: admin.name,
        callback: (value) {
          // 更新管理员信息
          _appModel.updateAdmin(
              admin.copy(name: value)
          ).then((value) {
            MessageUtil.showMessage(context, S.of(context).updateCompleted);
          }).catchError((error, stackTrace) {
            MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
          });
        }
    );
  }

  /// 修改密码
  Future<void> _changePassword(AdminItem admin) async {

    final result = await showModalBottomSheet<PasswordResult>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return const PasswordDialog();
        }
    );

    if (result == null) {
      return;
    }

    final oldPassword = result.oldPassword;
    final newPassword = result.newPassword;
    final confirmPassword = result.confirmPassword;

    if (newPassword != confirmPassword) {
      MessageUtil.showMessage(context, S.of(context).passwordNotMatch);
      return;
    }

    if (admin.password != oldPassword) {
      MessageUtil.showMessage(context, S.of(context).passwordError);
      return;
    }

    // 更新管理员密码
    _appModel.updateAdminPassword(
        newPassword
    ).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    }).then((value) {
      MessageUtil.showMessage(context, S.of(context).updateCompleted);
    });
  }

  /// 修改用户备注
  void _changeNotes(AdminItem admin) {
    _showEditDialog(
        title: S.of(context).edit,
        labelText: S.of(context).notes,
        value: admin.desc,
        maxLines: 6,
        callback: (value) {
          // 更新管理员信息
          _appModel.updateAdmin(
              admin.copy(desc: value)
          ).then((value) {
            MessageUtil.showMessage(context, S.of(context).updateCompleted);
          }).catchError((error, stackTrace) {
            MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
          });
        }
    );
  }

  /// 修改头像
  Future<void> _changeHeadImage(AdminItem admin) async {

    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    final file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup]
    );

    if (file == null) {
      return;
    }

    // 更新头像信息
    _appModel.updateHeadImage(
        admin, file
    ).then((value) {
      Navigator.pop(context);
      MessageUtil.showMessage(context, S.of(context).updateCompleted);
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 显示编辑Dialog
  Future<void> _showEditDialog({
    required String title,
    required String labelText,
    required String value,
    int maxLines = 1,
    required ValueChanged<String> callback
  }) async {

    final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: XColor.transparent,
        builder: (context) {
          return InputDialog(
            title: title,
            labelText: labelText,
            value: value,
            maxLines: maxLines,
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

    if (result != value) callback(result);
  }
}
