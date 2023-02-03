import 'dart:convert';
import 'package:barber/api/mainApi.dart';
import 'package:http/http.dart' as http;

authQuery(String type, String login, String password) async {
  final queryParameters = {
    'login': login,
    'password': password,
    'subType': type,
    'type': 'auth'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

regQuery(String type, String name, String surname, String mail,
    String password) async {
  final queryParameters = {
    'mail': mail,
    'password': password,
    'name': name,
    'surname': surname,
    'subType': type,
    'type': 'reg'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

recoveryQuery(
    String type, String part, String mail, String pass, String code) async {
  final queryParameters = {
    'mail': mail,
    'pass': pass,
    'code': code,
    'part': part,
    'subType': type,
    'type': 'recovery'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

profileQuery(String authToken, String subType) async {
  final queryParameters = {
    'authToken': authToken,
    'subType': subType,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

activeAccQuery(
    String authToken, String? subType, String activeType, String code) async {
  // mailSend   mailCheck   => activeType
  final queryParameters = {
    'authToken': authToken,
    'activeType': activeType,
    'subType': subType ?? 'activeAcc',
    'code': code,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

changeDefElemQuery(
    String authToken, String table, String row, String value) async {
  final queryParameters = {
    'authToken': authToken,
    'subType': 'change',
    'changeElem': 'default',
    'table': table,
    'row': row,
    'value': value,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

changeMail(String authToken, String value) async {
  //mail pochta ozgertu
  final queryParameters = {
    'authToken': authToken,
    'subType': 'change',
    'changeElem': 'mail',
    'mail': value,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

changeLoginElemQuery(String authToken, String login) async {
  final queryParameters = {
    'authToken': authToken,
    'subType': 'change',
    'changeElem': 'login',
    'login': login,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

changeAvatarElemQuery(String authToken, String image) async {
  await http.post(
      Uri.parse(
          "http://${url}/digway/backend/modules/profile/change/elem/avatar.php"),
      body: {
        "authToken": authToken,
        "image": image.toString(),
      });
}

changeFioElemQuery(
    String authToken, String name, String surname, String otch) async {
  final queryParameters = {
    'authToken': authToken,
    'subType': 'change',
    'changeElem': 'fio',
    'name': name,
    'surname': surname,
    'otch': otch,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

changeGeoElemQuery(String authToken, String co, String ind, String obl,
    String ray, String nas, String adr) async {
  final queryParameters = {
    'authToken': authToken,
    'subType': 'change',
    'changeElem': 'geo',
    'co': co,
    'ind': ind,
    'obl': obl,
    'ray': ray,
    'nas': nas,
    'adr': adr,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}

changePasswordQuery(String authToken, String changeElem, String pass) async {
  final queryParameters = {
    'authToken': authToken,
    'subType': 'change',
    'changeElem': changeElem,
    'pass': pass,
    'type': 'profile'
  };

  final uri = Uri.http(url, path, queryParameters);
  final response = await http.get(uri);

  return json.decode(response.body);
}
