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

extension XList<E> on List<E> {

  /// 是否在安全范围
  bool isSafeRange(int index) {
    return index >= 0 && index < length;
  }

  /// 循环调用处理
  List<E> forEachX(void Function(E element) action) {
    for (var element in this) {
      action(element);
    }
    return this;
  }
}


extension XString on String {

  String toAssetsSvg() {
    return 'assets/svg/$this';
  }

  String toAssetsImage() {
    return 'assets/image/$this';
  }

  String toAssetsAvatar() {
    return 'assets/avatar/$this';
  }

  String toAssetsPath() {
    return 'assets/$this';
  }
}