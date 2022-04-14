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

class SecretUtil {

  static final _ivBytes = [98, 10, 60, 80, 20, 1, 9, 8, 9, 20, 21, 11, 10, 26, 6, 97];

  SecretUtil._();

  /// Base64加密
  static String encodeBase64(String data){
    return base64Encode(utf8.encode(data));
  }

  /// Base64解密
  static String decodeBase64(String data){
    return String.fromCharCodes(base64Decode(data));
  }

  /// md5加密
  static String md5sum(String data) {
    return encodeBase64(
      md5.convert(utf8.encode(data)).toString()
    );
  }

  /// 加密数据
  static String encrypt(String password, String data) {

    var key = Key(
      Uint8List.fromList(
        sha256.convert(utf8.encode(password)).bytes
      )
    );
    var iv = IV(Uint8List.fromList(_ivBytes));

    var encrypter = Encrypter(
        AES(key, mode: AESMode.cbc)
    );

    return encrypter.encrypt(data, iv: iv).base64;
  }

  /// 解密数据
  static String decrypt(String password, String data) {

    var key = Key(
      Uint8List.fromList(
        sha256.convert(utf8.encode(password)).bytes
      )
    );
    var iv = IV(Uint8List.fromList(_ivBytes));

    var encrypter = Encrypter(
        AES(key, mode: AESMode.cbc)
    );

    return encrypter.decrypt64(data, iv: iv).toString();
  }
}

