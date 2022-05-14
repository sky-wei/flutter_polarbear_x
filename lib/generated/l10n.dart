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

  /// `Add folder`
  String get addFolderTip {
    return Intl.message(
      'Add folder',
      name: 'addFolderTip',
      desc: '',
      args: [],
    );
  }

  /// `Add account`
  String get addAccountTip {
    return Intl.message(
      'Add account',
      name: 'addAccountTip',
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
