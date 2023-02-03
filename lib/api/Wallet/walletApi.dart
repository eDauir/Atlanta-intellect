import 'dart:convert';

import 'package:barber/api/Wallet/IWallet.dart';
import 'package:barber/api/mainApi.dart';
import 'package:http/http.dart' as http;

getWalletInfo({required String login, String? page}) async {
  List<IWallet>? data = await Api().getData<IWallet>(params: {
    'type': 'balance',
    'subType': 'get',
    'authToken': login,
    'page': page
  }, fromJson: IWallet.fromJson);
  return data ?? [];
}


getBoughtUnit() async {
  List<IBoughtUnit>? data = await Api().getData<IBoughtUnit>(params: {
    'type': 'units',
    'subType': 'get',
  }, fromJson: IBoughtUnit.fromJson);
  return data ?? [];
}


buyCourseApi(
    {required String login,
    required String productId,
    required String amount}) async {
  var res = await http.post(
    Uri.parse("http://$url/digway/backend/modules/orders/buy.php"),
    body: {
      'authToken': login,
      'productId': productId,
      'pg_amount': amount,
      'ios': 'true',
    },
  );

  if (res.statusCode == 200) {
    return json.decode(res.body);
  } else {
    return false;
  }
}


buyCoursePartner(
    {required String login,
    required String productId,
    required String amount}) async {
  var res = await http.post(
    Uri.parse("http://$url/digway/backend/modules/orders/buy.php"),
    body: {
      'authToken': login,
      'productId': productId,
      'pg_amount': amount,
      'ios': 'true',
      'isPartner': 'true',
    },
  );

  if (res.statusCode == 200) {
    return json.decode(res.body);
  } else {
    return false;
  }
}



checkID({required String login, String? id}) async {
  var data = await Api().getData(
    params: {
      'type': 'balance',
      'subType': 'checkId',
      'authToken': login,
      'id': id
    },
  );
  return data;
}

transfer({required String login, String? id, String? amount}) async {
  var data = await Api().getData(
    params: {
      'type': 'balance',
      'subType': 'transfer',
      'authToken': login,
      'id': id,
      'amount': amount,
    },
  );
  return data;
}
