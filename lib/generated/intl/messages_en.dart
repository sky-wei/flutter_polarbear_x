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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountExists":
            MessageLookupByLibrary.simpleMessage("Account already exists!"),
        "accountPasswordError": MessageLookupByLibrary.simpleMessage(
            "Incorrect username or password!"),
        "addAccountTip": MessageLookupByLibrary.simpleMessage("Add account"),
        "addFolderTip": MessageLookupByLibrary.simpleMessage("Add folder"),
        "allItems": MessageLookupByLibrary.simpleMessage("All Items"),
        "appName": MessageLookupByLibrary.simpleMessage("PasswordX"),
        "canNotEmpty": MessageLookupByLibrary.simpleMessage("Can not be empty"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteFolder": MessageLookupByLibrary.simpleMessage("Delete Folder"),
        "deleteFolderMessage": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this folder!"),
        "deleteInfoError":
            MessageLookupByLibrary.simpleMessage("Delete error!"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editFolder": MessageLookupByLibrary.simpleMessage("Edit Folder"),
        "emptyAccountListTip":
            MessageLookupByLibrary.simpleMessage("There are no items to list."),
        "end": MessageLookupByLibrary.simpleMessage("End"),
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "folderExists":
            MessageLookupByLibrary.simpleMessage("Folder already exists!"),
        "folders": MessageLookupByLibrary.simpleMessage("Folders"),
        "forgetPassword":
            MessageLookupByLibrary.simpleMessage("Forget Password?"),
        "handlerError":
            MessageLookupByLibrary.simpleMessage("Handling exceptions!"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newAccount": MessageLookupByLibrary.simpleMessage("New Account"),
        "noFolder": MessageLookupByLibrary.simpleMessage("No Folder"),
        "notSupport":
            MessageLookupByLibrary.simpleMessage("Not currently supported!"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordError":
            MessageLookupByLibrary.simpleMessage("Wrong password!"),
        "passwordNotMatch":
            MessageLookupByLibrary.simpleMessage("Password does not match!"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "trash": MessageLookupByLibrary.simpleMessage("Trash"),
        "updateInfoError": MessageLookupByLibrary.simpleMessage("Update error!")
      };
}
