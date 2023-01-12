/*
 * Copyright (c) 2023 The sky Authors.
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

import 'package:flutter/material.dart';

class ImageUtil {
  
  static Image create(
    String path, {
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
  }) {

    final error = errorBuilder ?? (context, error, a) => Image.asset(
      'assets/image/ic_image_error.png',
      width: width,
      height: height,
    );

    if (path.startsWith('assets')) {
      return Image.asset(
        path,
        errorBuilder: error,
        width: width,
        height: height,
      );
    }

    return Image.file(
      File(path),
      errorBuilder: error,
      width: width,
      height: height,
    );
  }
}

