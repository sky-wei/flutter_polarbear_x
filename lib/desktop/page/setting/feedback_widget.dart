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
import 'package:flutter/services.dart';
import 'package:flutter_polarbear_x/generated/l10n.dart';
import 'package:flutter_polarbear_x/theme/color.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/app_extension.dart';
import 'package:flutter_polarbear_x/util/error_util.dart';
import 'package:flutter_polarbear_x/util/export_util.dart';
import 'package:flutter_polarbear_x/util/message_util.dart';
import 'package:flutter_polarbear_x/util/platform_util.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_polarbear_x/util/time_util.dart';
import 'package:path_provider/path_provider.dart';

class FeedbackWidget extends StatefulWidget {

  const FeedbackWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildFeedbackWidget(),
    );
  }

  Widget _buildFeedbackWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        XBox.vertical60,
        _buildQrCodeWidget(),
        Spacer(flex: 1),
        _buildSaveWidget(onPressed: () => _saveImage()),
        Spacer(flex: 2),
      ],
    );
  }

  Widget _buildQrCodeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          XBox.vertical5,
          _buildSearchWidget(),
          XBox.vertical10,
          Image.asset(
            'qrcode_for_gh.jpg'.toAssetsImage(),
            width: 210,
            height: 210,
          ),
          XBox.vertical10,
          Text(
            S.current.scanQrcodeFeedbackTips,
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).highlightColor.withAlpha(150)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).themeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          XBox.horizontal5,
          Text(
            '微信搜一搜',
            style: TextStyle(
                fontSize: 13,
                color: XColor.white
            ),
          ),
          XBox.horizontal5,
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            decoration: BoxDecoration(
                color: XColor.white,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text(
              '星空下的风',
              style: TextStyle(
                  fontSize: 15,
                  color: XColor.black
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 保存控件
  Widget _buildSaveWidget({
    VoidCallback? onPressed
  }) {
    return TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Text(
            S.current.saveImage,
            style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).themeColor
            ),
          ),
        )
    );
  }

  /// 保存图片
  void _saveImage() {
    _saveImageToPath().then((value) {
      if (value != null) {
        MessageUtil.showMessage(context, S.current.saveTo(value));
      }
    }).onError((error, stackTrace) {
      MessageUtil.showMessage(context, ErrorUtil.getMessage(context, error));
    });
  }

  /// 保存图片
  Future<String?> _saveImageToPath() async {

    final byteData = await rootBundle.load('qrcode_for_gh.jpg'.toAssetsImage());

    if (PlatformUtil.isMobile()) {
      final saveName = '${TimeUtil.getCurTime()}.jpg';
      return await ExportUtil.saverGallery(byteData, saveName);
    }

    final directory = await getApplicationDocumentsDirectory();
    final savePath = await getSaveLocation(
        acceptedTypeGroups: [XTypeGroup(label: 'jpg', extensions: ['jpg'])],
        initialDirectory: directory.path,
        suggestedName: 'feedback_qr_image.jpg',
        confirmButtonText: S.current.ok
    );

    if (savePath == null) {
      return null;
    }
    return ExportUtil.saveByteData(savePath.path, byteData);
  }
}

