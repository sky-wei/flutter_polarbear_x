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
import 'package:flutter_polarbear_x/data/item/admin_item.dart';
import 'package:flutter_polarbear_x/main.dart';
import 'package:flutter_polarbear_x/page/setting/password_dialog.dart';
import 'package:flutter_polarbear_x/page/setting/sub_text_widget.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dialog/input_dialog.dart';
import '../../generated/l10n.dart';
import '../../model/app_model.dart';
import '../../util/error_util.dart';
import '../../util/message_util.dart';
import '../../util/size_box_util.dart';

class AccountWidget extends StatefulWidget {

  const AccountWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {

  final DateFormat _dateFormat = DateFormat.yMMMMd()..add_Hm();

  late AppModel _appModel;

  AdminItem get admin => _appModel.admin;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppModel>();
    _appModel.addListener(_infoChange);
  }

  @override
  void dispose() {
    super.dispose();
    _appModel.removeListener(_infoChange);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            XBox.vertical10,
            Text(
              S.of(context).accountInformation,
              style: const TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).name,
              content: admin.name,
              action: S.of(context).changeName,
              onPressed: () { _changeName(admin); },
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).password,
              content: '********',
              action: S.of(context).changePassword,
              onPressed: () { _changePassword(admin); },
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).notes,
              content: admin.desc,
              action: S.of(context).changeNotes,
              onPressed: () { _changeNotes(admin); },
            ),
            XBox.vertical30,
            SubTextWidget(
              title: S.of(context).updated,
              content: _dateFormat.format(admin.updateDateTime)
            ),
            XBox.vertical40,
            ElevatedButton(
              onPressed: () {
                RestartWidget.restartApp(context);
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(XColor.deleteColor)
              ),
              child: Text(S.of(context).logout),
            )
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50, right: 10),
            child: _buildHeadWidget(
              onPressed: () {
                MessageUtil.showMessage(context, S.of(context).notSupport);
              }
            ),
          ),
        )
      ],
    );
  }

  /// 生成头像
  Widget _buildHeadWidget({required VoidCallback onPressed}) {
    return ClipOval(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Image.asset(
            'assets/image/ic_user_head.jpg',
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
        _appModel.updateAdmin(admin.copy(name: value)).catchError((error, stackTrace) {
          MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
        });
      }
    );
  }

  /// 修改密码
  Future<void> _changePassword(AdminItem admin) async {

    final result = await showDialog<PasswordResult>(
        context: context,
        builder: (context) {
          return const PasswordDialog();
        }
    );

    if (result == null) {
      return;
    }

    final oldPassword = result.oldPassword;
    final newPassword = result.newPassword;

    if (admin.password != oldPassword) {
      MessageUtil.showMessage(context, S.of(context).passwordError);
      return;
    }

    // 更新管理员密码
    _appModel.updateAdminPassword(
        newPassword
    ).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    }).then((value) => {
      MessageUtil.showMessage(context, S.of(context).updateCompleted)
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
          _appModel.updateAdmin(admin.copy(desc: value)).catchError((error, stackTrace) {
            MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
          });
        }
    );
  }

  /// 显示编辑Dialog
  Future<void> _showEditDialog({
    required String title,
    required String labelText,
    required String value,
    int maxLines = 1,
    required ValueChanged<String> callback
  }) async {

    final result = await showDialog<String>(
        context: context,
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

