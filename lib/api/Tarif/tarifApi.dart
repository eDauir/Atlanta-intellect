


import 'package:barber/api/Tarif/ITarif.dart';
import 'package:barber/api/mainApi.dart';

getTarif() async {
  List<ITarif> ? data = await Api().getData<ITarif>(params: {
    'type': 'rate',
    'subType': 'get',
  }, fromJson: ITarif.fromJson);
  return data ?? [];
}



getTarifBought(login) async {
  List<IBoughtTarif>  data = await Api().getData<IBoughtTarif>(params: {
    'type': 'rate',
    'subType': 'getMy',
    'authToken' : login
  }, fromJson: IBoughtTarif.fromJson);
  return data ;
}



// Buy tarif
buyTarif({required String? id , required String login , required String paymentId , required String orderSold , required String payboxLink ,  String type = 'buy'}) async {
   
   var data  = await Api().getData(params: {
    'type': 'rate',
    'subType': type ,
    'authToken': login,
    'rateId': id,
    'paymentId' : paymentId,
    'orderId' : orderSold,
    'payboxLink' : payboxLink,
  } );
  return data;
}

