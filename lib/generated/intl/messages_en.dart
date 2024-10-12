// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(value) => "Count: ${value}";

  static String m1(value) => "Mail: ${value}";

  static String m2(value) => "Source: ${value}";

  static String m3(value) => "Version: ${value}";

  static String m4(value) => "${value} can not be empty!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountExists":
            MessageLookupByLibrary.simpleMessage("Account already exists!"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Account Information"),
        "accountPasswordError": MessageLookupByLibrary.simpleMessage(
            "Incorrect username or password!"),
        "addAccountTip": MessageLookupByLibrary.simpleMessage("Add Account"),
        "addFolderTip": MessageLookupByLibrary.simpleMessage("Add Folder"),
        "allItems": MessageLookupByLibrary.simpleMessage("All Items"),
        "appDirectory": MessageLookupByLibrary.simpleMessage("App Directory"),
        "appName": MessageLookupByLibrary.simpleMessage("PasswordX"),
        "brightColorMode":
            MessageLookupByLibrary.simpleMessage("Bright color Mode"),
        "canNotEmpty": MessageLookupByLibrary.simpleMessage("Can not be empty"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeDirectory":
            MessageLookupByLibrary.simpleMessage("Change Directory"),
        "changeName": MessageLookupByLibrary.simpleMessage("Change Name"),
        "changeNotes": MessageLookupByLibrary.simpleMessage("Change Notes"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "clearClipboard":
            MessageLookupByLibrary.simpleMessage("Clear Clipboard"),
        "clearClipboardTips": MessageLookupByLibrary.simpleMessage(
            "Automatically clear value copied to clipboard！"),
        "clearCompleted":
            MessageLookupByLibrary.simpleMessage("Clear Completed!"),
        "clearData": MessageLookupByLibrary.simpleMessage("Clear Data"),
        "clearDataMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to clear all accounts under this account!"),
        "clearTrashTips": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to clear all current data！"),
        "clone": MessageLookupByLibrary.simpleMessage("Clone"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "copyToClipboard": MessageLookupByLibrary.simpleMessage(
            "The current information has been copied!"),
        "copyValue": MessageLookupByLibrary.simpleMessage("Copy Value"),
        "countX": m0,
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark mode"),
        "data": MessageLookupByLibrary.simpleMessage("Data"),
        "dateCreated": MessageLookupByLibrary.simpleMessage("Date created"),
        "dateModified": MessageLookupByLibrary.simpleMessage("Date modified"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteAccountMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this account!"),
        "deleteFolder": MessageLookupByLibrary.simpleMessage("Delete Folder"),
        "deleteFolderMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this folder!"),
        "deleteInfoError":
            MessageLookupByLibrary.simpleMessage("Delete error!"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editFolder": MessageLookupByLibrary.simpleMessage("Edit Folder"),
        "editItem": MessageLookupByLibrary.simpleMessage("Edit Item"),
        "emptyAccountListTip":
            MessageLookupByLibrary.simpleMessage("There are no items to list."),
        "end": MessageLookupByLibrary.simpleMessage("End"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "exitTips": MessageLookupByLibrary.simpleMessage(
            "Press again to return to desktop！"),
        "export": MessageLookupByLibrary.simpleMessage("Export"),
        "exportAccount": MessageLookupByLibrary.simpleMessage("Export Account"),
        "exportCompleted":
            MessageLookupByLibrary.simpleMessage("Export Completed!"),
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "folder": MessageLookupByLibrary.simpleMessage("Folder"),
        "folderExists":
            MessageLookupByLibrary.simpleMessage("Folder already exists!"),
        "folders": MessageLookupByLibrary.simpleMessage("Folders"),
        "followSystem": MessageLookupByLibrary.simpleMessage("Follow System"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forget Password?"),
        "handlerError":
            MessageLookupByLibrary.simpleMessage("Handling exceptions!"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "hour": MessageLookupByLibrary.simpleMessage("Hour"),
        "import": MessageLookupByLibrary.simpleMessage("Import"),
        "importAccount": MessageLookupByLibrary.simpleMessage("Import Account"),
        "importCompleted":
            MessageLookupByLibrary.simpleMessage("Import Completed!"),
        "importTips": MessageLookupByLibrary.simpleMessage(
            "Tip: No need to enter when there is no password！"),
        "itemInformation":
            MessageLookupByLibrary.simpleMessage("Item Information"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "launcher": MessageLookupByLibrary.simpleMessage("Launcher"),
        "license": MessageLookupByLibrary.simpleMessage(
            "Copyright 2022 The sky Authors\n\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\n   http://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License."),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "lock": MessageLookupByLibrary.simpleMessage("Lock"),
        "lockApp": MessageLookupByLibrary.simpleMessage("Lock App"),
        "lockAppTips": MessageLookupByLibrary.simpleMessage(
            "Automatically lock apps over time！"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "mailX": m1,
        "minute": MessageLookupByLibrary.simpleMessage("Minute"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "never": MessageLookupByLibrary.simpleMessage("Never"),
        "newAccount": MessageLookupByLibrary.simpleMessage("New Account"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
        "noFolder": MessageLookupByLibrary.simpleMessage("No Folder"),
        "notSupport":
            MessageLookupByLibrary.simpleMessage("Not currently supported!"),
        "notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "oldPassword": MessageLookupByLibrary.simpleMessage("Old Password"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordError":
            MessageLookupByLibrary.simpleMessage("Wrong password!"),
        "passwordNotMatch":
            MessageLookupByLibrary.simpleMessage("Password does not match!"),
        "preference": MessageLookupByLibrary.simpleMessage("Preference"),
        "recall": MessageLookupByLibrary.simpleMessage("Recall"),
        "restore": MessageLookupByLibrary.simpleMessage("Restore"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "sayWhat": MessageLookupByLibrary.simpleMessage("say what!"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "second": MessageLookupByLibrary.simpleMessage("Second"),
        "security": MessageLookupByLibrary.simpleMessage("Security"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "simplifiedChinese": MessageLookupByLibrary.simpleMessage("简体中文"),
        "sortBy": MessageLookupByLibrary.simpleMessage("Sort by"),
        "sourceX": m2,
        "storage": MessageLookupByLibrary.simpleMessage("Storage"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "toggleInvisible":
            MessageLookupByLibrary.simpleMessage("Toggle Invisible"),
        "toggleVisibility":
            MessageLookupByLibrary.simpleMessage("Toggle Visibility"),
        "toolbox": MessageLookupByLibrary.simpleMessage("Toolbox"),
        "trash": MessageLookupByLibrary.simpleMessage("Trash"),
        "unlock": MessageLookupByLibrary.simpleMessage("Unlock"),
        "unsavedChanges":
            MessageLookupByLibrary.simpleMessage("Unsaved Changes"),
        "unsavedChangesMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to leave? If you leave now them your current information will not be saved."),
        "updateCompleted":
            MessageLookupByLibrary.simpleMessage("Update Completed!"),
        "updateInfoError":
            MessageLookupByLibrary.simpleMessage("Update error!"),
        "updated": MessageLookupByLibrary.simpleMessage("Updated"),
        "url": MessageLookupByLibrary.simpleMessage("Url"),
        "urlEx": MessageLookupByLibrary.simpleMessage(
            "\'ex. https://www.xxxxxx.com\'"),
        "userName": MessageLookupByLibrary.simpleMessage("UserName"),
        "versionX": m3,
        "view": MessageLookupByLibrary.simpleMessage("View"),
        "xCanNotEmpty": m4
      };
}
