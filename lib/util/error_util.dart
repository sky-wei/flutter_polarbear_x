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

import 'package:flutter/cupertino.dart';

import '../data/data_exception.dart';
import '../generated/l10n.dart';

class ErrorUtil {

  ErrorUtil._();

  static String getMessage(BuildContext context, Object? error) {
    if (error is DataException) {
      switch(error.type) {
        case ErrorType.adminExist:
          return S.of(context).accountExists;
        case ErrorType.nameOrPasswordError:
          return S.of(context).accountPasswordError;
        case ErrorType.updateError:
          return S.of(context).updateInfoError;
        case ErrorType.other:
          return S.of(context).handlerError;
        case ErrorType.deleteError:
          return S.of(context).deleteInfoError;
        case ErrorType.passwordError:
          return S.of(context).passwordError;
      }
    }
    return S.of(context).handlerError;
  }
}
