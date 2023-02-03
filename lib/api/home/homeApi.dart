import 'package:barber/api/home/Ihome.dart';
import 'package:barber/api/mainApi.dart';

getProduct(
    {String? id, String? searchKey, String? page, bool? isOnline}) async {
  List<IHome>? data = await Api().getData<IHome>(params: {
    'type': 'products',
    'subType': 'get',
    'categoryId': id,
    'searchKey': searchKey,
    'page': page,
    'online': isOnline == null ? '' : isOnline.toString(),
  }, fromJson: IHome.fromJson);
  return data ?? [];
}
