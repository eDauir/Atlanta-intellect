import 'package:barber/api/Product/IProduct.dart';
import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/mainApi.dart';



getProductId({String? productId}) async {
  List<IProductId>? data  = await Api().getData<IProductId>(params: {
    'type': 'products',
    'subType': 'getOne',
    'productId': productId.toString(),
  } , fromJson: IProductId.fromJson);
  return data;
}



getMentorProducts(String? id) async {
   List<IHome> data  = await Api().getData<IHome>(params: {
    'type': 'user',
    'subType': 'getProducts',
    'id': id,

  } , fromJson: IHome.fromJson );
  return data;
}


getProgressProduct(String? id , String? login) async {
   var data  = await Api().getData(params: {
    'type': 'progress',
    'subType': 'get',
    'authToken': login,
    'productId': id,
  } );
  return data;
}




getProgressProductFinish(String? id , String? login) async {
   List<IProductProgress> ? data  = await Api().getData<IProductProgress>(params: {
    'type': 'progress',
    'subType': 'getFinish',
    'authToken': login,
    'productId': id,
  } , fromJson: IProductProgress.fromJson);
  return data;
}






// Buy course

buyCourse({required String? id , required String login , required String paymentId , required String orderSold , required String payboxLink}) async {
   
   var data  = await Api().getData(params: {
    'type': 'orders',
    'subType': 'buy',
    'authToken': login,
    'productId': id,
    'paymentId' : paymentId,
    'orderSalt' : orderSold,
    'payboxLink' : payboxLink,
  } );
  return data;
}







setProgressProduct(String id , String? login ,  String progress ) async {
   var data  = await Api().getData(params: {
    'type': 'progress',
    'subType': 'update',
    'authToken': login ,
    'elemId': progress.toString(),
    'productId' : id
  } );
  return data;
}




setProgressProductFinish(String? id , elemId, String? login) async {
   var data  = await Api().getData(params: {
    'type': 'progress',
    'subType': 'updateFinish',
    'authToken': login,
    'productId': id,
    'elemId' : elemId
  } );
  return data;
}




getTest(String id ) async {
  List<Questions> ? data  = await Api().getData<Questions>(params: {
    'type': 'test',
    'subType': 'get',
    'id': id,
  } , fromJson: Questions.fromJson );
  return data ?? [];
}


sendFeedback( {required String login , required String productId , text , rating} ) async {
  var data  = await Api().getData(params: {
    'type': 'comment',
    'subType': 'put',
    'authToken':login, 
    'productId': productId,
    'text': text,
    'rating': rating,
  }  );
  return data ?? [];
}





