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

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptStore {

  final _ivBytes = [98, 10, 60, 80, 20, 1, 9, 8, 9, 20, 21, 11, 10, 26, 6, 97];

  /// Base64加密
  String encodeBase64(String data){
    return base64Encode(utf8.encode(data));
  }

  /// Base64解密
  String decodeBase64(String data){
    return String.fromCharCodes(base64Decode(data));
  }

  /// md5加密
  String md5sum(String data) {
    return encodeBase64(
        md5.convert(utf8.encode(data)).toString()
    );
  }

  /// 加密数据
  String encrypt(String password, String data) {

    if (data.isEmpty) return "";

    final key = buildKey(password);
    final iv = IV(Uint8List.fromList(_ivBytes));

    final encrypt = Encrypter(
        AES(key, mode: AESMode.cbc)
    );

    return encrypt.encrypt(data, iv: iv).base64;
  }

  /// 解密数据
  String decrypt(String password, String data) {

    if (data.isEmpty) return "";

    final key = buildKey(password);
    final iv = IV(Uint8List.fromList(_ivBytes));

    final encrypt = Encrypter(
        AES(key, mode: AESMode.cbc)
    );

    return encrypt.decrypt64(data, iv: iv).toString();
  }

  /// 生成Key
  Key buildKey(String password) {
    return Key(
      Uint8List.fromList(
        sha256.convert(utf8.encode(password)).bytes
      )
    );
  }
}

