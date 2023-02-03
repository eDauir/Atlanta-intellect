import 'dart:convert';

import 'package:barber/api/mainApi.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:http/http.dart' as http;

EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences();

getCheckedLogin() async {
  var login = await encryptedSharedPreferences.getString('checkedLogin');

  if (login.isEmpty) return '';

  var data = await Api().getData(
    params: {
      'type': 'profile',
      'subType': 'checkAuth',
      'authToken': login,
    },
  );

  if (data == true) {
    return login;
  } else {
    return '';
  }
}

checkEditor(String login) async {
  final queryParameters = {
    'type': 'admin',
    'subType': 'check',
    'authToken': login,
  };
  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);
  var arr;
  if (response.statusCode == 200) {
    arr = json.decode(response.body);
  } else {
    arr = null;
  }
  return arr;
}
