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

  static String m0(value) => "Mail: ${value}";

  static String m1(value) => "Source: ${value}";

  static String m2(value) => "Version: ${value}";

  static String m3(value) => "${value} can not be empty!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountExists":
            MessageLookupByLibrary.simpleMessage("Account already exists!"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("Account Information"),
        "accountPasswordError": MessageLookupByLibrary.simpleMessage(
            "Incorrect username or password!"),
        "addAccountTip": MessageLookupByLibrary.simpleMessage("Add Account"),
        "addFolderTip": MessageLookupByLibrary.simpleMessage("Add Folder"),
        "allItems": MessageLookupByLibrary.simpleMessage("All Items"),
        "appName": MessageLookupByLibrary.simpleMessage("PasswordX"),
        "canNotEmpty": MessageLookupByLibrary.simpleMessage("Can not be empty"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeName": MessageLookupByLibrary.simpleMessage("Change Name"),
        "changeNotes": MessageLookupByLibrary.simpleMessage("Change Notes"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "clone": MessageLookupByLibrary.simpleMessage("Clone"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "copyToClipboard": MessageLookupByLibrary.simpleMessage(
            "The current information has been copied!"),
        "copyValue": MessageLookupByLibrary.simpleMessage("Copy Value"),
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
        "favorite": MessageLookupByLibrary.simpleMessage("Favorite"),
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "folder": MessageLookupByLibrary.simpleMessage("Folder"),
        "folderExists":
            MessageLookupByLibrary.simpleMessage("Folder already exists!"),
        "folders": MessageLookupByLibrary.simpleMessage("Folders"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forget Password?"),
        "handlerError":
            MessageLookupByLibrary.simpleMessage("Handling exceptions!"),
        "itemInformation":
            MessageLookupByLibrary.simpleMessage("Item Information"),
        "launcher": MessageLookupByLibrary.simpleMessage("Launcher"),
        "license": MessageLookupByLibrary.simpleMessage(
            "Copyright 2022 The sky Authors\n\nLicensed under the Apache License, Version 2.0 (the \"License\");\nyou may not use this file except in compliance with the License.\nYou may obtain a copy of the License at\n\n   http://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software\ndistributed under the License is distributed on an \"AS IS\" BASIS,\nWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\nSee the License for the specific language governing permissions and\nlimitations under the License."),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "mailX": m0,
        "name": MessageLookupByLibrary.simpleMessage("Name"),
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
        "recall": MessageLookupByLibrary.simpleMessage("Recall"),
        "restore": MessageLookupByLibrary.simpleMessage("Restore"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "sayWhat": MessageLookupByLibrary.simpleMessage("say what!"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "sourceX": m1,
        "toggleInvisible":
            MessageLookupByLibrary.simpleMessage("Toggle Invisible"),
        "toggleVisibility":
            MessageLookupByLibrary.simpleMessage("Toggle Visibility"),
        "trash": MessageLookupByLibrary.simpleMessage("Trash"),
        "unsavedChanges":
            MessageLookupByLibrary.simpleMessage("Unsaved Changes"),
        "unsavedChangesMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to leave? If you leave now them your current information will not be saved."),
        "updateInfoError":
            MessageLookupByLibrary.simpleMessage("Update error!"),
        "updated": MessageLookupByLibrary.simpleMessage("Updated"),
        "url": MessageLookupByLibrary.simpleMessage("Url"),
        "urlEx": MessageLookupByLibrary.simpleMessage(
            "\'ex. https://www.xxxxxx.com\'"),
        "userName": MessageLookupByLibrary.simpleMessage("UserName"),
        "versionX": m2,
        "view": MessageLookupByLibrary.simpleMessage("View"),
        "xCanNotEmpty": m3
      };
}
