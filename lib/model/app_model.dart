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

import 'package:flutter_polarbear_x/data/item/account_item.dart';
import 'package:flutter_polarbear_x/data/repository/app_setting.dart';
import 'package:flutter_polarbear_x/data/repository/encrypt_store.dart';
import 'package:flutter_polarbear_x/model/side_item.dart';
import 'package:flutter_polarbear_x/util/easy_notifier.dart';
import 'package:path_provider/path_provider.dart';

import '../data/item/admin_item.dart';
import '../data/item/folder_item.dart';
import '../data/item/sort_item.dart';
import '../data/objectbox.dart';
import '../data/repository/app_repository.dart';
import '../generated/l10n.dart';
import '../theme/color.dart';


typedef AccountFilter = bool Function(AccountItem account);

class AbstractModel extends EasyNotifier {

}

enum FunState {
  view,
  edit,
  none
}

class AppModel extends AbstractModel {

  bool _init = false;
  late AppRepository _appRepository;
  final AppSetting _appSetting;

  AdminItem _admin = AdminItem(id: 1, name: 'Sky', password: '123456');

  final List<SideItem> fixedSide = [
    SideItem(name: S.current.favorites, icon: 'assets/svg/ic_favorites.svg', type: SortType.favorite, color: XColor.favoriteColor),
    SideItem(name: S.current.allItems, icon: 'assets/svg/ic_all_items.svg', type: SortType.allItems),
    SideItem(name: S.current.trash, icon: 'assets/svg/ic_trash.svg', type: SortType.trash, color: XColor.deleteColor),
  ];

  SideItem get allItems => fixedSide[1];

  final EasyNotifier folderNotifier = EasyNotifier();
  final EasyNotifier listNotifier = EasyNotifier();
  final EasyNotifier infoNotifier = EasyNotifier();
  final EasyNotifier funStateNotifier = EasyNotifier();

  final List<FolderItem> folders = [];    /// ?????????
  final List<AccountItem> accounts = [];  /// ??????

  late SideItem chooseSide;
  SortType get sortType => chooseSide.type;
  AccountItem chooseAccount = AccountItem.empty;
  String keyword = '';
  FunState funState = FunState.none;
  AccountItem editAccount = AccountItem.empty;
  
  List<AccountItem> _allAccountItems = [];      // ?????????????????????????????????
  List<AccountItem> _filterAccountItems = [];   // ??????????????????
  
  AdminItem get admin => _admin;        // ?????????????????????

  AppModel({
    required AppSetting appSetting
  }): _appSetting = appSetting;

  @override
  void dispose() {
    folderNotifier.dispose();
    listNotifier.dispose();
    infoNotifier.dispose();
    funStateNotifier.dispose();
    _appRepository.dispose();
    super.dispose();
  }

  /// ?????????
  Future<AppModel> initialize() async {
    if (!_init) {
      _init = true;
      chooseSide = allItems;
      final dir = await getApplicationSupportDirectory();
      _appRepository = AppRepository(
        objectBox: await ObjectBox.create(directory: dir.path),
        encryptStore: EncryptStore()
      );
      await Future.delayed(const Duration(milliseconds: 200));
    }
    return this;
  }

  /// ????????????
  Future<AdminItem> createAdmin({
    required String name,
    required String password
  }) async {

    final item = _appRepository.encryptAdmin(
      AdminItem(
        name: name,
        password: password
      )
    );

    final admin = await _appRepository.createAdmin(item);

    return _updateAdmin(admin.copy(password: password));
  }

  /// ??????????????????
  Future<AdminItem> updateAdmin(AdminItem admin) async {

    admin.updateTime = DateTime.now().millisecondsSinceEpoch;

    await _appRepository.updateAdmin(
        _appRepository.encryptAdmin(admin)
    );

    return _updateAdmin(admin);
  }

  /// ??????????????????
  Future<AdminItem> updateAdminPassword(String newPassword) async {

    final admin = this.admin.copy(password: newPassword);

    admin.updateTime = DateTime.now().millisecondsSinceEpoch;

    await _appRepository.updateAdmin(
        _appRepository.encryptAdmin(admin)
    );

    await _appRepository.updateAccounts(
      _allAccountItems.map((account) {
        return _appRepository.encryptAccount(admin, account);
      }).toList()
    );

    return _updateAdmin(admin);
  }

  /// ????????????
  Future<AdminItem> loginByAdmin({
    required String name,
    required String password
  }) async {

    var item = _appRepository.encryptAdmin(
      AdminItem(name: name, password: password)
    );

    var admin = await _appRepository.loginByAdmin(item);

    return _updateAdmin(admin.copy(password: password));
  }

  /// ???????????????
  Future<FolderItem> createFolder(String name) async {

    var item = await _appRepository.createFolder(
      FolderItem(adminId: admin.id, name: name)
    );

    folderNotifier.notify(() {
      folders.insert(folders.length - 1, item);
    });
    infoNotifier.notifyListeners();

    return item;
  }

  /// ???????????????
  Future<FolderItem> updateFolder(FolderItem item) async {

    final result = await _appRepository.updateFolder(item);

    folderNotifier.notify(() {
      final index = folders.indexOf(result);
      folders.removeAt(index);
      folders.insert(index, result);
    });
    infoNotifier.notifyListeners();

    return result;
  }

  /// ???????????????
  Future<FolderItem> deleteFolder(FolderItem item) async {

    final result = await _appRepository.deleteFolder(item);

    final items = _filterAccount(
      accounts: _allAccountItems,
      filter: (account) => item.id == account.folderId
    );
    for (var item in items) {
      item.folderId = FolderItem.noFolder;
    }

    if (items.isNotEmpty) {
      // ??????????????????
      await _appRepository.updateAccounts(
        items.map((account) {
          return _appRepository.encryptAccount(admin, account);
        }).toList()
      );
    }

    folderNotifier.notify(() {
      folders.remove(result);
    });
    infoNotifier.notifyListeners();

    return result;
  }

  /// ???????????????
  FolderItem findFolderBy(AccountItem account) {

    for (var item in folders) {
      if (item.id == account.folderId) {
        return item;
      }
    }
    return folders[folders.length - 1];
  }

  /// ???????????????
  Future<List<FolderItem>> loadFolders() async {

    // ?????????????????????
    final items = await _appRepository.loadFoldersBy(admin);

    items.add(
      FolderItem(adminId: admin.id, name: S.current.noFolder)
    );
    
    folderNotifier.notify(() {
      folders.clear();
      folders.addAll(items);
    });

    return folders;
  }

  /// ??????????????????
  Future<List<AccountItem>> loadAllAccount() async {

    final items = await _appRepository.loadAllAccountBy(admin);

    _allAccountItems = items.map((account) {
      return _appRepository.decryptAccount(admin, account);
    }).toList();

    return await switchSide(side: allItems);
  }

  /// ????????????
  Future<List<AccountItem>> refreshAccounts() async {
    return await switchSide(side: chooseSide);
  }

  /// ??????????????????
  Future<List<AccountItem>> switchSide({
    required SideItem side
  }) async {

    chooseSide = side;

    final List<AccountItem> items;

    switch(side.type) {
      case SortType.favorite:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.favorite && !item.trash
        );
        break;
      case SortType.allItems:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => !item.trash
        );
        break;
      case SortType.trash:
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.trash
        );
        break;
      case SortType.folder:
        FolderItem folder = side.data;
        items = _filterAccount(
            accounts: _allAccountItems,
            filter: (item) => item.folderId == folder.id && !item.trash
        );
        break;
      default:
        items = [];
    }

    _filterAccountItems = items;

    return await searchAccount(keyword: keyword);
  }

  /// ????????????
  Future<List<AccountItem>> searchAccount({
    required String keyword
  }) async {

    this.keyword = keyword;

    if (keyword.isEmpty) {
      _updateAccounts(_filterAccountItems);
      return accounts;
    }

    final items = _filterAccount(
      accounts: _filterAccountItems,
      filter: (item) => item.contains(keyword)
    );

    _updateAccounts(items);
    
    return accounts;
  }

  /// ????????????
  Future<AccountItem> createAccount(AccountItem item) async {

    final result = await _appRepository.createAccount(
      _appRepository.encryptAccount(admin, item)
    );
    final account = result.copy(password: item.password);

    _allAccountItems.add(account);

    refreshAccounts();
    viewAccountBy(account);

    return account;
  }

  /// ????????????
  Future<AccountItem> deleteAccount(AccountItem item) async {

    if (SortType.trash == chooseSide.type) {
      // ??????????????????
      _allAccountItems.remove(item);
      await _appRepository.deleteAccount(item);
    } else {
      // ??????????????????
      item.trash = true;
      _updateListAccount(item);
      await _appRepository.updateAccount(
        _appRepository.encryptAccount(admin, item)
      );
    }

    // ????????????
    await refreshAccounts();

    if (chooseAccount == item) {
      clearChooseAccount();
      clearAccount();
    }

    return item;
  }

  Future<AccountItem> updateAccount(AccountItem item) async {

    item.updateTime = DateTime.now().millisecondsSinceEpoch;
    final result = await _appRepository.updateAccount(
        _appRepository.encryptAccount(admin, item)
    );
    final account = result.copy(password: item.password);

    _updateListAccount(account);

    refreshAccounts();
    viewAccountBy(account);

    return account;
  }

  /// ?????????????????????
  Future<AccountItem> favoriteAccount(AccountItem item) async {

    item.favorite = !item.favorite;
    item.updateTime = DateTime.now().millisecondsSinceEpoch;
    final result = await _appRepository.updateAccount(
      _appRepository.encryptAccount(admin, item)
    );
    final account = result.copy(password: item.password);

    _updateListAccount(account);
    refreshAccounts();

    return account;
  }

  /// ????????????
  Future<AccountItem> restoreAccount(AccountItem item) async {

    // ???????????????
    item.trash = false;

    final result = await _appRepository.updateAccount(
        _appRepository.encryptAccount(admin, item)
    );
    final account = result.copy(password: item.password);

    // ????????????
    await refreshAccounts();

    if (chooseAccount == account) {
      clearChooseAccount();
      clearAccount();
    }

    return account;
  }

  void viewAccountBy(AccountItem item) {
    listNotifier.notify();
    funStateNotifier.notify(() {
      chooseAccount = item;
      editAccount = item.copy();
      funState = FunState.view;
    });
  }

  void editAccountBy(AccountItem item) {
    listNotifier.notify();
    funStateNotifier.notify(() {
      chooseAccount = item;
      editAccount = item.copy();
      funState = FunState.edit;
    });
  }

  void newAccount() {
    listNotifier.notify();
    funStateNotifier.notify(() {
      chooseAccount = AccountItem.formAdmin(admin.id);
      editAccount = chooseAccount.copy();
      funState = FunState.edit;
    });
  }

  /// ??????????????????
  void clearChooseAccount() {
    listNotifier.notify(() {
      chooseAccount = AccountItem.empty;
    });
  }

  /// ????????????
  void clearAccount() {
    funStateNotifier.notify(() {
      chooseAccount = AccountItem.empty;
      editAccount = AccountItem.empty;
      funState = FunState.none;
    });
  }

  /// ?????????????????????
  bool isModifyAccount() {
    return FunState.edit == funState && !chooseAccount.unanimous(editAccount);
  }

  /// ????????????
  AppSetting getAppSetting() {
    return _appSetting;
  }

  /// ????????????
  List<AccountItem> _filterAccount({
    required List<AccountItem> accounts,
    required AccountFilter filter
  }) {

    final List<AccountItem> items = [];

    for (var item in accounts) {
      if (filter(item)) items.add(item);
    }

    return items;
  }

  /// ?????????????????????
  AdminItem _updateAdmin(AdminItem item) {
    notify(() => _admin = item);
    return item;
  }
  
  /// ????????????
  List<AccountItem> _updateAccounts(List<AccountItem> items) {

    // final result = List.of(items);
    // result.sort((a, b) => -a.updateTime.compareTo(b.updateTime));

    listNotifier.notify(() {
      accounts.clear();
      accounts.addAll(items);
    });
    return items;
  }

  /// ????????????????????????
  void _updateListAccount(AccountItem item) {
    final index = _allAccountItems.indexOf(item);
    if (index != -1) {
      _allAccountItems.removeAt(index);
      _allAccountItems.insert(index, item);
    }
  }
}
