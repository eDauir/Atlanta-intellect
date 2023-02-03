import 'package:barber/api/Comments/IComments.dart';
import 'package:barber/api/mainApi.dart';



getComments({String? id , String? searchKey , String? page}) async {
  List<IComments> ? data  = await Api().getData<IComments>(params: {
    'type': 'comment',
    'subType': 'get',
    'productId' : id,
    'page': page
  } , fromJson: IComments.fromJson);
  return data;
}


