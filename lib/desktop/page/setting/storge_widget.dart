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
import 'package:flutter_polarbear_x/desktop/dialog/hint_dialog.dart';
import 'package:flutter_polarbear_x/desktop/dialog/input_dialog.dart';
import 'package:flutter_polarbear_x/desktop/model/app_desktop_model.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:provider/provider.dart';


class StorageWidget extends StatefulWidget {

  const StorageWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StorageWidgetState();
}

class StorageWidgetState extends State<StorageWidget> {

  late AppDesktopModel _appModel;

  @override
  void initState() {
    super.initState();
    _appModel = context.read<AppDesktopModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        XBox.vertical10,
        Text(
          S.of(context).storage,
          style: const TextStyle(
              fontWeight: FontWeight.w600
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).import,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical20,
        OutlinedButton(
          onPressed: () => _importAccount(),
          child: Text(
            S.of(context).importAccount,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).export,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical20,
        OutlinedButton(
          onPressed: () => _exportAccount(),
          child: Text(
            S.of(context).exportAccount,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
        ),
        XBox.vertical30,
        Text(
          S.of(context).data,
          style: TextStyle(
              color: Theme.of(context).hintColor
          ),
        ),
        XBox.vertical20,
        ElevatedButton(
          onPressed: () => _clearData(),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).deleteColor
              )
          ),
          child: Text(S.of(context).clearData),
        )
      ],
    );
  }

  /// 导入账号
  Future<void> _importAccount() async {

    _appModel.importAccount(() async {
      return await _showPasswordDialog(
        title: S.of(context).importAccount,
      );
    }).then((value) {
      if (value) {
        Navigator.pop(context);
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
        Navigator.pop(context);
        MessageUtil.showMessage(context, S.of(context).exportCompleted);
      }
    }).catchError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 清除数据
  Future<void> _clearData() async {

    final result = await showDialog<int>(
        context: context,
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
          Navigator.pop(context);
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
    return await showDialog<String>(
      context: context,
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