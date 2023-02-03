import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/mainApi.dart';



delFavoriteCard(String login, String id) async {
  var data  = await Api().getData(params: {
    'type': 'like',
    'subType': 'delete',
    'authToken': login,
    'productId': id,
  });
  return data;
}


addFavoriteCard(String login, String id) async {
  var data  = await Api().getData(params: {
    'type': 'like',
    'subType': 'put',
    'authToken': login,
    'productId': id,
  });
  return data;
}



getFavoriteCards(String login , String page) async {
  List<IHome> data  = await Api().getData<IHome>(params: {
    'type': 'like',
    'subType': 'getCards',
    'authToken': login,
    'page' : page
  }, fromJson: IHome.fromJson);
  return data;
}



// ONLY ID
getFavoriteCardId(String login) async {
  var data  = await Api().getData(params: {
    'type': 'like',
    'subType': 'getList',
    'authToken': login,
  });
  return data;
}