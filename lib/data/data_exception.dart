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

class DataException implements Exception {

  final ErrorType type;
  final dynamic message;

  DataException({
    this.type = ErrorType.other,
    this.message = 'Exception'
  });

  DataException.type({
    this.type = ErrorType.other
  }) : message = 'Exception';

  DataException.message([this.message]) : type = ErrorType.other;

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

enum ErrorType {

  adminExist,
  nameOrPasswordError,
  updateError,
  deleteError,
  passwordError,
  other
}

