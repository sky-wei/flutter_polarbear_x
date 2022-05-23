// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `PasswordX`
  String get appName {
    return Intl.message(
      'PasswordX',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Account already exists!`
  String get accountExists {
    return Intl.message(
      'Account already exists!',
      name: 'accountExists',
      desc: '',
      args: [],
    );
  }

  /// `Folder already exists!`
  String get folderExists {
    return Intl.message(
      'Folder already exists!',
      name: 'folderExists',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect username or password!`
  String get accountPasswordError {
    return Intl.message(
      'Incorrect username or password!',
      name: 'accountPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Update error!`
  String get updateInfoError {
    return Intl.message(
      'Update error!',
      name: 'updateInfoError',
      desc: '',
      args: [],
    );
  }

  /// `Handling exceptions!`
  String get handlerError {
    return Intl.message(
      'Handling exceptions!',
      name: 'handlerError',
      desc: '',
      args: [],
    );
  }

  /// `Delete error!`
  String get deleteInfoError {
    return Intl.message(
      'Delete error!',
      name: 'deleteInfoError',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password!`
  String get passwordError {
    return Intl.message(
      'Wrong password!',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Not currently supported!`
  String get notSupport {
    return Intl.message(
      'Not currently supported!',
      name: 'notSupport',
      desc: '',
      args: [],
    );
  }

  /// `Password does not match!`
  String get passwordNotMatch {
    return Intl.message(
      'Password does not match!',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Folders`
  String get folders {
    return Intl.message(
      'Folders',
      name: 'folders',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `All Items`
  String get allItems {
    return Intl.message(
      'All Items',
      name: 'allItems',
      desc: '',
      args: [],
    );
  }

  /// `No Folder`
  String get noFolder {
    return Intl.message(
      'No Folder',
      name: 'noFolder',
      desc: '',
      args: [],
    );
  }

  /// `Trash`
  String get trash {
    return Intl.message(
      'Trash',
      name: 'trash',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Can not be empty`
  String get canNotEmpty {
    return Intl.message(
      'Can not be empty',
      name: 'canNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `{value} can not be empty!`
  String xCanNotEmpty(Object value) {
    return Intl.message(
      '$value can not be empty!',
      name: 'xCanNotEmpty',
      desc: '',
      args: [value],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit Folder`
  String get editFolder {
    return Intl.message(
      'Edit Folder',
      name: 'editFolder',
      desc: '',
      args: [],
    );
  }

  /// `Delete Folder`
  String get deleteFolder {
    return Intl.message(
      'Delete Folder',
      name: 'deleteFolder',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Add Folder`
  String get addFolderTip {
    return Intl.message(
      'Add Folder',
      name: 'addFolderTip',
      desc: '',
      args: [],
    );
  }

  /// `Add Account`
  String get addAccountTip {
    return Intl.message(
      'Add Account',
      name: 'addAccountTip',
      desc: '',
      args: [],
    );
  }

  /// `New Account`
  String get newAccount {
    return Intl.message(
      'New Account',
      name: 'newAccount',
      desc: '',
      args: [],
    );
  }

  /// `There are no items to list.`
  String get emptyAccountListTip {
    return Intl.message(
      'There are no items to list.',
      name: 'emptyAccountListTip',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this folder!`
  String get deleteFolderMessage {
    return Intl.message(
      'Are you sure you want to delete this folder!',
      name: 'deleteFolderMessage',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this account!`
  String get deleteAccountMessage {
    return Intl.message(
      'Are you sure you want to delete this account!',
      name: 'deleteAccountMessage',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Clone`
  String get clone {
    return Intl.message(
      'Clone',
      name: 'clone',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Copy Value`
  String get copyValue {
    return Intl.message(
      'Copy Value',
      name: 'copyValue',
      desc: '',
      args: [],
    );
  }

  /// `Recall`
  String get recall {
    return Intl.message(
      'Recall',
      name: 'recall',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message(
      'Restore',
      name: 'restore',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get userName {
    return Intl.message(
      'UserName',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Launcher`
  String get launcher {
    return Intl.message(
      'Launcher',
      name: 'launcher',
      desc: '',
      args: [],
    );
  }

  /// `Toggle Visibility`
  String get toggleVisibility {
    return Intl.message(
      'Toggle Visibility',
      name: 'toggleVisibility',
      desc: '',
      args: [],
    );
  }

  /// `Toggle Invisible`
  String get toggleInvisible {
    return Intl.message(
      'Toggle Invisible',
      name: 'toggleInvisible',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Folder`
  String get folder {
    return Intl.message(
      'Folder',
      name: 'folder',
      desc: '',
      args: [],
    );
  }

  /// `say what!`
  String get sayWhat {
    return Intl.message(
      'say what!',
      name: 'sayWhat',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Url`
  String get url {
    return Intl.message(
      'Url',
      name: 'url',
      desc: '',
      args: [],
    );
  }

  /// `Edit Item`
  String get editItem {
    return Intl.message(
      'Edit Item',
      name: 'editItem',
      desc: '',
      args: [],
    );
  }

  /// `Item Information`
  String get itemInformation {
    return Intl.message(
      'Item Information',
      name: 'itemInformation',
      desc: '',
      args: [],
    );
  }

  /// `The current information has been copied!`
  String get copyToClipboard {
    return Intl.message(
      'The current information has been copied!',
      name: 'copyToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Version: {value}`
  String versionX(Object value) {
    return Intl.message(
      'Version: $value',
      name: 'versionX',
      desc: '',
      args: [value],
    );
  }

  /// `Mail: {value}`
  String mailX(Object value) {
    return Intl.message(
      'Mail: $value',
      name: 'mailX',
      desc: '',
      args: [value],
    );
  }

  /// `Source: {value}`
  String sourceX(Object value) {
    return Intl.message(
      'Source: $value',
      name: 'sourceX',
      desc: '',
      args: [value],
    );
  }

  /// `Copyright 2022 The sky Authors\n\nLicensed under the Apache License, Version 2.0 (the "License");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\n   http://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an "AS IS" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.`
  String get license {
    return Intl.message(
      'Copyright 2022 The sky Authors\n\nLicensed under the Apache License, Version 2.0 (the "License");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\n   http://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an "AS IS" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License.',
      name: 'license',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get end {
    return Intl.message(
      'End',
      name: 'end',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
