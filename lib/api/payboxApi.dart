import 'dart:collection';
import 'dart:convert';

import 'package:barber/api/Product/productApi.dart';
import 'package:barber/res/widgets/formaters.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

String url = 'api.paybox.money';

final String urlData = '78.40.108.112';

String script = 'init_payment.php';
String merchantId = '546649';
String keyToInput = 'tFf0dphcmWr4XpNa';
String keyToOutput = 'P39CBakkjCRqhdI3';
String method = 'GET';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

editMap(Map params, {bool isOut = false}) {
  final sortedQueryParametres = SplayTreeMap<String, dynamic>.from(
      params, (keys1, keys2) => keys1.compareTo(keys2));

  List<String> flatParams = [];
  sortedQueryParametres.forEach((key, value) {
    flatParams.add(value.toString());
  });

  flatParams.add(isOut ? keyToOutput : keyToInput);

  String valueToMd5 = isOut ? 'reg2nonreg' : script;

  for (var item in flatParams) {
    valueToMd5 += ';$item';
  }

  return generateMd5(valueToMd5);
}

getResultUrl(type) {
  switch (type) {
    case 'buyBook':
      return 'http://${urlData}/digway/backend/modules/books/buy.php';
    case 'buyProduct':
      return 'http://${urlData}/digway/backend/modules/orders/buy.php';
    case 'output':
      return 'http://${urlData}/digway/backend/modules/balance/output/output.php';
    case 'addWallet':
      return 'http://${urlData}/digway/backend/modules/balance/put/put.php';
    case 'unitBuy':
      return 'http://${urlData}/digway/backend/modules/units/buy.php';
  }
}

useQueryScript(type, paymentId, orderId, paramElements) {
  switch (type) {
    case 'buyProduct':
      buyCourse(
          login: paramElements['authToken'],
          id: paramElements['productId'],
          payboxLink: paramElements['payboxLink'],
          paymentId: paymentId,
          orderSold: orderId);
      break;
  }
}

buyFromPaybox(amount, desc, type, Map paramElements) async {
  var orderId = getRandomString(8);

  final queryParameters = {
    "pg_order_id": orderId,
    'pg_merchant_id': merchantId,
    'pg_amount': amount,
    'authToken': paramElements['authToken'],
    'productId': paramElements['bookId'],
    'pg_description': desc,
    'pg_salt': getRandomString(16),
    'pg_request_method': method,
  };

  queryParameters.addAll({'pg_result_url': getResultUrl(type)});
  var pg_sig = await editMap(queryParameters);
  queryParameters.addAll({'pg_sig': pg_sig});

  final uri = Uri.http(url, script, queryParameters);
  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  final document =
      XmlDocument.parse(responseBody).findElements('response').first;

  if (statusCode == 200) {
    if (document.findElements('pg_status').first.text == 'ok') {
      // paramElements.addAll(
      //     {'payboxLink': document.findElements('pg_redirect_url').first.text});
      // useQueryScript(type, document.findElements('pg_payment_id').first.text,
      //     orderId, paramElements);

      return document.findElements('pg_redirect_url').first.text;
    }
  }

  return false;
}

walletAddPaybox(amount, desc, type, authToken) async {
  var orderId = getRandomString(8);

  final queryParameters = {
    "pg_order_id": orderId,
    'pg_merchant_id': merchantId,
    'pg_amount': amount,
    'authToken': authToken,
    'android': '1',
    'pg_description': desc,
    'pg_salt': getRandomString(16),
    'pg_request_method': method,
  };

  queryParameters.addAll({'pg_result_url': getResultUrl(type)});
  var pg_sig = await editMap(queryParameters);
  queryParameters.addAll({'pg_sig': pg_sig});

  final uri = Uri.http(url, script, queryParameters);
  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  final document =
      XmlDocument.parse(responseBody).findElements('response').first;

  if (statusCode == 200) {
    if (document.findElements('pg_status').first.text == 'ok') {
      return document.findElements('pg_redirect_url').first.text;
    }
  }

  return false;
}

UnitBuyPaybox(amount, unit, desc, type, authToken) async {
  var orderId = getRandomString(8);

  final queryParameters = {
    "pg_order_id": orderId,
    'pg_merchant_id': merchantId,
    'pg_amount': amount,
    'authToken': authToken,
    'android': '1',
    'unit': unit,
    'pg_description': desc,
    'pg_salt': getRandomString(16),
    'pg_request_method': method,
  };

  queryParameters.addAll({'pg_result_url': getResultUrl(type)});
  var pg_sig = await editMap(queryParameters);
  queryParameters.addAll({'pg_sig': pg_sig});

  final uri = Uri.http(url, script, queryParameters);
  final response = await http.get(
    uri,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  final document =
      XmlDocument.parse(responseBody).findElements('response').first;

  if (statusCode == 200) {
    if (document.findElements('pg_status').first.text == 'ok') {
      return document.findElements('pg_redirect_url').first.text;
    }
  }

  return false;
}

outFromPaybox(type, amount, desc, authToken, Map paramElements) async {
  var orderId = getRandomString(8);

  final queryParameters = {
    "pg_order_id": orderId,
    'pg_merchant_id': merchantId,
    'pg_amount': amount,
    'pg_description': desc,
    'authToken': authToken,
    'pg_salt': getRandomString(16),
    'pg_back_link': 'https://ru.wikipedia.org',
    'pg_order_time_limit': '3000-01-01 12:00:00',
  };

  queryParameters.addAll({'pg_post_link': getResultUrl(type)});
  var pg_sig = await editMap(queryParameters, isOut: true);
  queryParameters.addAll({'pg_sig': pg_sig});

  final uri = Uri.http(url, 'api/reg2nonreg', queryParameters);
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );

  int statusCode = response.statusCode;
  String responseBody = response.body;
  final document =
      XmlDocument.parse(responseBody).findElements('response').first;

  if (statusCode == 200) {
    if (document.findElements('pg_status').first.text == 'ok') {
      return document.findElements('pg_redirect_url').first.text;
    }
  }

  return false;
}
